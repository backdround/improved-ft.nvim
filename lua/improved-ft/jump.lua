--# selene: allow(if_same_then_else)

local utils = require("improved-ft.utils")
local position = require("improved-ft.position")

---@return IFT_IgnoredPositions
local function new_ignored_positions()
  ---Represents positions that must be ignored during pattern search.
  ---@class IFT_IgnoredPositions
  local ip = {}

  ---Tests if a given position must be ignored.
  ---@param tested_position IFT_Position
  ---@return boolean
  ip.is_ignored = function(tested_position)
    for _, ignored_position in ipairs(ip) do
      if tested_position == ignored_position then
        return true
      end
    end
    return false
  end

  ---Adds an ignored position
  ---@param ignored_position IFT_Position
  ip.add = function(ignored_position)
    ignored_position = vim.deepcopy(ignored_position)
    table.insert(ip, ignored_position)
  end

  return ip
end

---@class IFT_Pattern
---@field start_position IFT_Position
---@field end_position IFT_Position

---@param opts IFT_JumpOptions
---@param n_is_pointable boolean position can point to a "\n"
---@return IFT_Pattern|nil
local function search_target_pattern(opts, n_is_pointable)
  local flags = "cnW"
  if opts.direction == "backward" then
    flags = flags .. "b"
  end

  local ignored_positions = new_ignored_positions()
  do
    local initial_position = position.from_cursor(n_is_pointable)

    if opts.offset == "none" or opts.offset == "pre" then
      ignored_positions.add(initial_position)
    end

    if opts.offset == "pre" and opts.direction == "forward" then
      initial_position.forward_once()
      ignored_positions.add(initial_position)
    elseif opts.offset == "pre" and opts.direction == "backward" then
      initial_position.backward_once()
      ignored_positions.add(initial_position)
    end
  end

  local found_pattern = nil
  local count = opts.count
  local search_callback = function()
    local current_position = position.from_cursor(n_is_pointable)
    if ignored_positions.is_ignored(current_position) then
      return 1
    end

    -- Construct found_pattern
    found_pattern = {
      start_position = current_position,
    }
    local find_end_position = function()
      found_pattern.end_position =
        position.from_cursor(n_is_pointable)
      return 0
    end
    vim.fn.searchpos(opts.pattern, "nWce", nil, nil, find_end_position)

    count = count - 1
    return count
  end

  vim.fn.searchpos(opts.pattern, flags, nil, nil, search_callback)

  return found_pattern
end

---@param opts IFT_JumpOptions
---@param n_is_pointable boolean position can point to a "\n"
---@return IFT_Position|nil
local function search_target_position(opts, n_is_pointable)
  local target_pattern = search_target_pattern(opts, n_is_pointable)
  if not target_pattern then
    return nil
  end

  local pattern_start = target_pattern.start_position
  local pattern_end = target_pattern.end_position

  local forward = opts.direction == "forward"
  local backward = opts.direction == "backward"
  local pre = opts.offset == "pre"
  local post = opts.offset == "post"
  local none = opts.offset == "none"
  local normal_mode = utils.mode() == "normal"

  if forward and pre then
    pattern_start.backward_once()
    return pattern_start
  elseif forward and none and normal_mode then
    return pattern_start
  elseif forward and none and not normal_mode then
    return pattern_end
  elseif forward and post then
    pattern_end.forward_once()
    return pattern_end
  elseif backward and pre then
    pattern_end.forward_once()
    return pattern_end
  elseif backward and none then
    return pattern_start
  elseif backward and post then
    pattern_start.backward_once()
    return pattern_start
  end
end

---Options that describe the jump behaviour.
---@class IFT_JumpOptions
---@field direction "forward"|"backward" direction to search a given pattern
---@field offset "pre"|"post"|"none" offset to cursor to place
---@field pattern string pattern to search
---@field count number count of jumps to perform

---Performs a jump to a given pattern
---@param opts IFT_JumpOptions
local perform = function(opts)
  local n_is_pointable = utils.mode() ~= "normal"
  local target_position = search_target_position(opts, n_is_pointable)

  if not target_position then
    return
  end

  if utils.mode() ~= "operator-pending" then
    target_position.set_cursor()
    return
  end

  local start_position = position.from_cursor(n_is_pointable)
  if opts.direction == "backward" then
    start_position.backward_once()
  end

  start_position.select_region_to(target_position)
end

return perform
