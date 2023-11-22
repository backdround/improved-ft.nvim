local move = require("improved-ft.position-move")
local utils = require("improved-ft.utils")
local M = {}

---@param opts IFT_JumpOptions
---@param n_is_placeable boolean position can be placed at a "\n"
---@return IFT_Position|nil
local function search_target_character_position(opts, n_is_placeable)
  local flags = "nW"
  if not opts.forward then
    flags = flags .. "b"
  end

  local ignore_position = nil
  if opts.pre then
    local current_position = vim.api.nvim_win_get_cursor(0)
    if opts.forward then
      ignore_position = move.forward_once(current_position, n_is_placeable)
    else
      ignore_position = move.backward_once(current_position, n_is_placeable)
    end
  end

  local last_found_position = nil
  local count = opts.count
  local skipper = function()
    local current_position = vim.api.nvim_win_get_cursor(0)
    if vim.deep_equal(current_position, ignore_position) then
      return 1
    end
    last_found_position = current_position
    last_found_position[2] = vim.fn.virtcol(last_found_position)
    count = count - 1
    return count
  end

  local pattern = "\\M" .. vim.fn.escape(opts.char, "^$\\")
  vim.fn.searchpos(pattern, flags, nil, nil, skipper)

  return last_found_position
end

---@param opts IFT_JumpOptions
---@param n_is_placeable boolean position can be placed at a "\n"
---@return IFT_Position|nil
local function search_target_position(opts, n_is_placeable)
  local target_position = search_target_character_position(opts, n_is_placeable)
  if not target_position then
    return nil
  end

  if opts.pre then
    if opts.forward then
      target_position = move.backward_once(target_position, n_is_placeable)
    else
      target_position = move.forward_once(target_position, n_is_placeable)
    end
  end

  return target_position
end

---Performs jump to a character
---@param opts IFT_JumpOptions
M.perform = function(opts)
  local n_is_placeable = utils.mode() ~= "normal"
  local target_position = search_target_position(opts, n_is_placeable)

  if not target_position then
    return
  end

  if utils.mode() ~= "operator-pending" then
    utils.set_cursor(target_position)
    return
  end

  local start_position = vim.api.nvim_win_get_cursor(0)

  if not opts.forward then
    start_position = move.backward_once(start_position, n_is_placeable)
  end

  utils.select_region(start_position, target_position)
end

return M
