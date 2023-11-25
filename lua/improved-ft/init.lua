local user_options = require("improved-ft.user-options")
local utils = require("improved-ft.utils")
local jump = require("improved-ft.jump")

local cache = {}

---@param opts IFT_UserJumpOptions
local perform_jump = function(opts)
  user_options.assert(opts)

  -- Get direction
  if opts.direction == nil then
    cache.direction = "forward"
  else
    cache.direction = opts.direction
  end

  -- Get offset
  if opts.offset == nil then
    cache.offset = "none"
  else
    cache.offset = opts.offset
  end

  -- Get pattern
  if utils.is_vim_repeat() then
    cache.pattern = cache.pattern
  elseif opts.pattern == nil then
    cache.pattern = utils.get_user_inputed_pattern()
  else
    cache.pattern = opts.pattern
  end

  -- Get count
  if vim.v.count ~= 0 then
    cache.count = vim.v.count
  elseif not utils.is_vim_repeat() then
    cache.count = 1
  else
    cache.count = cache.count
  end

  jump(cache)
end

local get_jump = function(direction, offset)
  return function()
    perform_jump({
      direction = direction,
      offset = offset,
    })
  end
end

---@param forward boolean
local get_repeat = function(direction)
  return function()
    if cache.pattern == nil then
      return
    end

    perform_jump({
      direction = direction,
      pattern = cache.pattern,
      offset = cache.offset,
    })
  end
end

return {
  to_char_forward = get_jump("forward", "none"),
  to_pre_char_forward = get_jump("forward", "pre"),
  to_char_backward = get_jump("backward", "none"),
  to_pre_char_backward = get_jump("backward", "pre"),

  repeat_forward = get_repeat("forward"),
  repeat_backward = get_repeat("backward"),
}
