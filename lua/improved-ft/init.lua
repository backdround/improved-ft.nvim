local uo = require("improved-ft.user-options")
local utils = require("improved-ft.utils")
local jump = require("improved-ft.jump")

local dot_repetition_cache = {}
local user_repetition_cache = {}

---@param opts IFT_UserJumpOptions
local perform_jump = function(opts)
  local user_options = vim.deepcopy(opts or {})
  uo.assert(user_options)
  uo.fill_default(user_options)

  local jump_options = {
    direction = user_options.direction,
    offset = user_options.offset,
  }

  -- Get pattern
  if utils.is_vim_repeat() then
    jump_options.pattern = dot_repetition_cache.pattern
  elseif user_options.pattern ~= nil then
    jump_options.pattern = user_options.pattern
  else
    jump_options.pattern = utils.get_user_inputed_pattern()
  end

  -- Get count
  if vim.v.count ~= 0 then
    jump_options.count = vim.v.count
  elseif utils.is_vim_repeat() then
    jump_options.count = dot_repetition_cache.count
  else
    jump_options.count = 1
  end

  -- Save caches
  dot_repetition_cache = jump_options
  if user_options.save_for_repetition then
    user_repetition_cache = jump_options
  end

  jump(jump_options)
end

---@param direction "forward"|"backward"
local get_repeat = function(direction)
  return function()
    if user_repetition_cache.pattern == nil then
      return
    end

    perform_jump({
      direction = direction,
      pattern = user_repetition_cache.pattern,
      offset = user_repetition_cache.offset,
    })
  end
end

return {
  jump = perform_jump,

  repeat_forward = get_repeat("forward"),
  repeat_backward = get_repeat("backward"),
}
