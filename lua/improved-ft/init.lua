local jump = require("improved-ft.jump")
local jump_options = require("improved-ft.jump-options")

---@param forward boolean
---@param pre boolean
local function get_jump_function(forward, pre)
  return function()
    local options = jump_options.get_options(forward, pre)
    jump.perform(options)
  end
end

---@param forward boolean
local function get_repeat_jump_function(forward)
  return function()
    local options = jump_options.get_repeat_options(forward)
    jump.perform(options)
  end
end

return {
  to_char_forward = get_jump_function(true, false),
  to_pre_char_forward = get_jump_function(true, true),
  to_char_backward = get_jump_function(false, false),
  to_pre_char_backward = get_jump_function(false, true),

  repeat_forward = get_repeat_jump_function(true),
  repeat_backward = get_repeat_jump_function(false),
}
