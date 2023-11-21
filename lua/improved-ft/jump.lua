local position_move = require("improved-ft.position-move")
local utils = require("improved-ft.utils")
local M = {}

---Searches target jump position
---@param opts IFT_JumpOptions
---@return IFT_Position|nil
local function search_target_position(opts)
  local flags = "nW"
  if not opts.forward then
    flags = flags .. "b"
  end

  local count = opts.count
  local skipper = function()
    count = count - 1
    return count
  end

  local position = vim.fn.searchpos(opts.pattern, flags, nil, nil, skipper)
  position[2] = position[2] - 1

  if position[1] == 0 then
    return nil
  end


  if opts.pre then
    local n_is_placeable = utils.mode() ~= "normal"
    if opts.forward then
      position = position_move.backward_once(position, n_is_placeable)
    else
      position = position_move.forward_once(position, n_is_placeable)
    end
  end

  return position
end

---Performs jump to a character
---@param opts IFT_JumpOptions
M.perform = function(opts)
  local target_position = search_target_position(opts)

  if not target_position then
    return
  end

  if utils.mode() ~= "operator-pending" then
    vim.api.nvim_win_set_cursor(0, target_position)
    return
  end

  local start_position = vim.api.nvim_win_get_cursor(0)

  if not opts.forward then
    start_position = position_move.backward_once(start_position, true)
  end

  utils.select_region(start_position, target_position)
end

return M
