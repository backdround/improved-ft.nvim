local lazy_char_hops = function()
  return require("improved-ft.char-hops")
end

---@class IFT_Conifg
---@field ignore_char_case boolean
---@field use_relative_repetition boolean
---@field use_relative_repetition_offsets boolean

local M = {
  ---@type IFT_Conifg
  cfg = {
    ignore_char_case = false,
    use_relative_repetition = false,
    use_relative_repetition_offsets = false,
  },
}

M._reset_state = function()
  return lazy_char_hops().reset_state()
end

---@param direction "forward"|"backward"
local get_repeat = function(direction)
  return function()
    lazy_char_hops().repeat_hop(
      direction,
      M.cfg.use_relative_repetition,
      M.cfg.use_relative_repetition_offsets
    )
  end
end

---@param direction "forward"|"backward"
---@param offset number
---@return function
local get_hop = function(direction, offset)
  return function()
    return lazy_char_hops().hop(M.cfg.ignore_char_case, direction, offset)
  end
end

M.repeat_forward = get_repeat("forward")
M.repeat_backward = get_repeat("backward")

M.hop_forward_to_pre_char = get_hop("forward", -1)
M.hop_forward_to_char = get_hop("forward", 0)
M.hop_forward_to_post_char = get_hop("forward", 1)

M.hop_backward_to_pre_char = get_hop("backward", 1)
M.hop_backward_to_char = get_hop("backward", 0)
M.hop_backward_to_post_char = get_hop("backward", -1)

---@class IFT_SetupOptions
---@field use_default_mappings? boolean Maps default f/F/t/T/;/, keys.
---@field ignore_char_case? boolean Ignores case of the given characters.
---@field use_relative_repetition? boolean Uses direction-relative directions during repetition.
---@field use_relative_repetition_offsets? boolean Uses direction-relative offsets during repetition hops.

---@param opts? IFT_SetupOptions
M.setup = function(opts)
  opts = opts or {}

  if opts.use_relative_repetition ~= nil then
    M.cfg.use_relative_repetition = opts.use_relative_repetition
  end

  if opts.use_relative_repetition_offsets ~= nil then
    M.cfg.use_relative_repetition_offsets = opts.use_relative_repetition_offsets
  end

  if opts.ignore_char_case ~= nil then
    M.cfg.ignore_char_case = opts.ignore_char_case
  end

  if opts.use_default_mappings then
    local map = function(key, fn, description)
      vim.keymap.set({ "n", "x", "o" }, key, fn, {
        desc = description,
      })
    end

    map("f", M.hop_forward_to_char, "Hop forward to a given char")
    map("F", M.hop_backward_to_char, "Hop backward to a given char")
    map("t", M.hop_forward_to_pre_char, "Hop forward before a given char")
    map("T", M.hop_backward_to_pre_char, "Hop backward before a given char")
    map(";", M.repeat_forward, "Repeat hop forward to a last given char")
    map(",", M.repeat_backward, "Repeat hop backward to a last given char")
  end

  M._reset_state()
end

return M
