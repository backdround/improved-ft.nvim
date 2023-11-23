local utils = require("improved-ft.utils")
local position = require("improved-ft.position")

---@param opts IFT_JumpOptions
---@param n_is_pointable boolean position can point to a "\n"
---@return IFT_Position|nil
local function search_target_character_position(opts, n_is_pointable)
  local flags = "nW"
  if not opts.forward then
    flags = flags .. "b"
  end

  local ignore_position = nil
  if opts.pre then
    ignore_position = position.from_cursor_position(n_is_pointable)
    if opts.forward then
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

  local pattern = "\\M" .. vim.fn.escape(opts.char, "^$\\")
  vim.fn.searchpos(pattern, flags, nil, nil, skipper)

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

  if opts.pre then
    if opts.forward then
      target_position.backward_once()
    else
      target_position.forward_once()
    end
  end

  return target_position
end

---Performs a jump to a character
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
  if not opts.forward then
    start_position.backward_once()
  end

  start_position.select_region_to(target_position)
end

return perform
