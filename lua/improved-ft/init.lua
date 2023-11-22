local utils = require("improved-ft.utils")
local jump = require("improved-ft.jump")

local last_count = 1
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

---@param user_pattern string
---@param forward boolean
---@param pre boolean
---@return string
local function get_pattern(user_pattern, forward, pre)
  if not pre then
    return user_pattern
  end

  if forward then
    return string.format([[\v(\n^|.)\ze%s]], user_pattern)
  end

  return string.format([[%s\v(\n^\n|\n^.|.)]], user_pattern)
end

local last_user_pattern = ""
local last_pre = false

---@param forward boolean
---@param pre boolean
---@param user_repeat boolean
local function get_jump_function(forward, pre, user_repeat)
  return function()
    if not user_repeat then
      last_pre = pre
      if not utils.is_vim_repeat() then
        last_user_pattern = utils.get_user_inputed_pattern()
      end
    end

    local options = {
      forward = forward,
      count = get_count(),
      pattern = get_pattern(last_user_pattern, forward, last_pre)
    }

    jump.perform(options)
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
