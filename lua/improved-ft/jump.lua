local position_monipulation = require("improved-ft.position-monipulation")
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

  if position[1] == 0 then
    return nil
  end

  position[2] = position[2] - 1

  if opts.pre then
    if opts.forward then
      position = position_monipulation.move_backward_once(position)
    else
      position = position_monipulation.move_forward_once(position)
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

  if not utils.is_operator_pending_mode() then
    vim.api.nvim_win_set_cursor(0, target_position)
    return
  end

  local start_position = vim.api.nvim_win_get_cursor(0)

  if not opts.forward then
    start_position = position_monipulation.move_backward_once(start_position)
  end

  utils.select_region(start_position, target_position)
end

return M
