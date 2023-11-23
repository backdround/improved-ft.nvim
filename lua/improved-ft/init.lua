local utils = require("improved-ft.utils")
local jump = require("improved-ft.jump")

local last_count = 1
---Returns specified by a user count
---@return number
local function get_count()
  if vim.v.count ~= 0 then
    last_count = vim.v.count
    return vim.v.count
  end

  if utils.is_vim_repeat() then
    return last_count
  end

  last_count = 1
  return 1
end

local last_user_char = ""
local last_pre = false

---@param forward boolean direction to jump.
---@param pre boolean jump one symbol before pattern
---@param user_repeat boolean user manually triggered repetition
---@return function
local function get_jump_function(forward, pre, user_repeat)
  return function()
    if not user_repeat then
      last_pre = pre
      if not utils.is_vim_repeat() then
        last_user_char = utils.get_user_inputed_char()
      end
    end

    ---Options that describe a jump behaviour.
    ---@class IFT_JumpOptions
    ---@field forward boolean direction to jump.
    ---@field char string char to which to jump
    ---@field pre boolean jump one symbol before pattern
    ---@field count number count of jumps to perform
    local options = {
      forward = forward,
      char = last_user_char,
      pre = last_pre,
      count = get_count(),
    }

    jump(options)
  end
end

return {
  to_char_forward = get_jump_function(true, false, false),
  to_pre_char_forward = get_jump_function(true, true, false),
  to_char_backward = get_jump_function(false, false, false),
  to_pre_char_backward = get_jump_function(false, true, false),

  repeat_forward = get_jump_function(true, false, true),
  repeat_backward = get_jump_function(false, false, true),
}
