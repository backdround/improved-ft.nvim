local utils = require("improved-ft.utils")
local M = {}

---@type IFT_JumpOptions
local last_jump_opts = {
  forward = true,
  pattern = "",
  count = 1,
  pre = false,
}

---@return string
local function get_pattern()
  if utils.is_repeat() then
    return last_jump_opts.pattern
  end
  return utils.get_user_inputed_pattern()
end

---@return number
local function get_count()
  if vim.v.count ~= 0 then
    return vim.v.count
  end

  if utils.is_repeat() then
    return last_jump_opts.count
  end

  return 1
end

---@param forward boolean
---@param pre boolean
---@return IFT_JumpOptions
M.get_options = function(forward, pre)
  local options = {
    forward = forward,
    pattern = get_pattern(),
    count = get_count(),
    pre = pre,
  }

  last_jump_opts = options
  return options
end

---@param forward boolean
---@return IFT_JumpOptions
M.get_repeat_options = function(forward)
  local options = {
    forward = forward,
    pattern = last_jump_opts.pattern,
    count = get_count(),
    pre = last_jump_opts.pre,
  }

  last_jump_opts = options
  return options
end

return M
