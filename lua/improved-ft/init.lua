local jump = require("improved-ft.jump")

local M = {}

M._reset_state = function()
  M._jump_options_manager = require("improved-ft.jump-options-manager").new()
end
M._reset_state()

---@param opts IFT_UserJumpOptions
M.jump = function(opts)
  local jump_options = M._jump_options_manager.get_from_user_options(opts)
  jump(jump_options)
end

M.repeat_forward = function()
  local jump_options = M._jump_options_manager.get_repeating_options("forward")
  if jump_options ~= nil then
    jump(jump_options)
  end
end

M.repeat_backward = function()
  local jump_options = M._jump_options_manager.get_repeating_options("backward")
  if jump_options ~= nil then
    jump(jump_options)
  end
end

return M
