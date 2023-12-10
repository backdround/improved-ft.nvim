local char_hops = require("improved-ft.char-hops")

local M = {
  ---@type IFT_Conifg
  cfg = {
    ignore_char_case = false,
    use_relative_repetition = false,
  },
}

M._reset_state = char_hops.reset_state

M.repeat_forward = char_hops.get_repetition(M.cfg, "forward")
M.repeat_backward = char_hops.get_repetition(M.cfg, "backward")

M.hop_forward_to_pre_char = char_hops.get_hop(M.cfg, "forward", "pre")
M.hop_forward_to_char = char_hops.get_hop(M.cfg, "forward", "start")
M.hop_forward_to_post_char = char_hops.get_hop(M.cfg, "forward", "post")

M.hop_backward_to_pre_char = char_hops.get_hop(M.cfg, "backward", "pre")
M.hop_backward_to_char = char_hops.get_hop(M.cfg, "backward", "start")
M.hop_backward_to_post_char = char_hops.get_hop(M.cfg, "backward", "post")

---@class IFT_SetupOptions
---@field use_default_mappings? boolean
---@field ignore_char_case? boolean
---@field use_relative_repetition? boolean

---@param opts? IFT_SetupOptions
M.setup = function(opts)
  opts = opts or {}

  if opts.use_relative_repetition ~= nil then
    M.cfg.use_relative_repetition = opts.use_relative_repetition
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
