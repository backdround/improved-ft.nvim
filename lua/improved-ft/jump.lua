local utils = require("improved-ft.utils")
local position = require("improved-ft.position")

---@param opts IFT_JumpOptions
---@param n_is_pointable boolean position can point to a "\n"
---@return IFT_Position|nil
local function search_target_character_position(opts, n_is_pointable)
  local flags = "nW"
  if opts.direction == "backward" then
    flags = flags .. "b"
  end

  local ignore_position = nil
  if opts.offset == "pre" then
    ignore_position = position.from_cursor_position(n_is_pointable)
    if opts.direction == "forward" then
      ignore_position.forward_once()
    else
      ignore_position.backward_once()
    end
  end

  local last_found_position = nil
  local count = opts.count
  local skipper = function()
    local current_position = position.from_cursor_position(n_is_pointable)
    if current_position == ignore_position then
      return 1
    end
    last_found_position = current_position
    count = count - 1
    return count
  end

  vim.fn.searchpos(opts.pattern, flags, nil, nil, skipper)

  return last_found_position
end

---@param opts IFT_JumpOptions
---@param n_is_pointable boolean position can point to a "\n"
---@return IFT_Position|nil
local function search_target_position(opts, n_is_pointable)
  local target_position = search_target_character_position(opts, n_is_pointable)
  if not target_position then
    return nil
  end

  if opts.offset == "pre" then
    if opts.direction == "forward" then
      target_position.backward_once()
    else
      target_position.forward_once()
    end
  end

  if opts.offset == "post" then
    if opts.direction == "forward" then
      target_position.forward_once()
    else
      target_position.backward_once()
    end
  end

  return target_position
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

  local start_position = position.from_cursor_position(n_is_pointable)
  if opts.direction == "backward" then
    start_position.backward_once()
  end

  start_position.select_region_to(target_position)
end

return perform
