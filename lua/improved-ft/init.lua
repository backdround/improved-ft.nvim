local rabbit_hop = require("improved-ft.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {
  _setup_options = {
    ignore_char_case = false,
    use_relative_repetition = false,
  },
  _last_hop_direction = "forward",
}

---@param direction "forward"|"backward"
---@param offset "pre"|"start"|"post"
---@return function
local get_hop_function = function(direction, offset)
  return function()
    local hop_options = {
      direction = direction,
      offset = offset,
    }

    if utils.is_vim_repeat() then
      local last_operator_pending_hop_options =
        rabbit_hop.get_last_operator_pending_hop_options()
      if last_operator_pending_hop_options == nil then
        return
      end
      hop_options.pattern = last_operator_pending_hop_options.pattern
    else
      hop_options.pattern =
        utils.get_user_inputed_pattern(M._setup_options.ignore_char_case)
    end

    if vim.v.count ~= 0 then
      hop_options.count = vim.v.count
    else
      hop_options.count = 1
    end

    M._last_hop_direction = hop_options.direction or "forward"
    rabbit_hop.hop(hop_options)
  end
end

---@param direction "forward"|"backward"
---@return function
local get_repetition_function = function(direction)
  return function()
    local last_hop_options = rabbit_hop.get_last_hop_options()
    if last_hop_options == nil then
      return
    end

    local hop_options = {
      pattern = last_hop_options.pattern,
      offset = last_hop_options.offset,
      direction = direction,
    }

    if
      M._setup_options.use_relative_repetition
      and M._last_hop_direction == "backward"
    then
      if hop_options.direction == "forward" then
        hop_options.direction = "backward"
      else
        hop_options.direction = "forward"
      end
    end

    if vim.v.count ~= 0 then
      hop_options.count = vim.v.count
    else
      hop_options.count = 1
    end

    rabbit_hop.hop(hop_options)
  end
end

M._reset_state = function()
  rabbit_hop.reset_state()
end

M.repeat_forward = get_repetition_function("forward")
M.repeat_backward = get_repetition_function("backward")

M.hop_forward_pre_char = get_hop_function("forward", "pre")
M.hop_forward_to_char = get_hop_function("forward", "start")
M.hop_forward_post_char = get_hop_function("forward", "post")

M.hop_backward_pre_char = get_hop_function("backward", "pre")
M.hop_backward_to_char = get_hop_function("backward", "start")
M.hop_backward_post_char = get_hop_function("backward", "post")

---@class IFT_SetupOptions
---@field use_default_mappings? boolean
---@field ignore_char_case? boolean
---@field use_relative_repetition? boolean

---@param opts? IFT_SetupOptions
M.setup = function(opts)
  opts = opts or {}
  M._setup_options = vim.tbl_extend("force", M._setup_options, opts)

  if M._setup_options.use_default_mappings then
    local map = function(key, fn, description)
      vim.keymap.set({ "n", "x", "o" }, key, fn, {
        desc = description,
      })
    end

    map("f", M.hop_forward_to_char, "Jump forward to a given char")
    map("<S-f>", M.hop_backward_to_char, "Jump backward to a given char")
    map("t", M.hop_forward_pre_char, "Jump forward before a given char")
    map("<S-t>", M.hop_backward_pre_char, "Jump backward before a given char")
    map(";", M.repeat_forward, "Jump forward to a last given char")
    map(",", M.repeat_backward, "Jump backward to a last given char")
  end

  M._reset_state()
end

return M
