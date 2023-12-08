local rabbit_hop = require("improved-ft.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {
  _setup_options = {
    ignore_user_char_case = false,
    use_relative_repetition = false,
  },
  _last_hop_direction = "forward",
}

M._reset_state = function()
  rabbit_hop.reset_state()
end
M._reset_state()

M.jump = function(opts)
  opts = vim.deepcopy(opts or {})

  if opts.offset == "none" then
    opts.offset = "start"
  end

  if utils.is_vim_repeat() then
    local last_operator_hop_options =
      rabbit_hop.get_last_operator_pending_hop_options()
    if last_operator_hop_options == nil then
      return
    end
    opts.pattern = last_operator_hop_options.pattern
  else
    opts.pattern =
      utils.get_user_inputed_pattern(M._setup_options.ignore_user_char_case)
  end

  if vim.v.count ~= 0 then
    opts.count = vim.v.count
  else
    opts.count = 1
  end

  M._last_hop_direction = opts.direction or "forward"
  rabbit_hop.hop(opts)
end

M.repeat_forward = function()
  local last_hop_options = rabbit_hop.get_last_hop_options()
  if last_hop_options == nil then
    return
  end

  local hop_options = {
    pattern = last_hop_options.pattern,
    offset = last_hop_options.offset,
  }

  if not M._setup_options.use_relative_repetition then
    hop_options.direction = "forward"
  else
    hop_options.direction = M._last_hop_direction
  end

  if vim.v.count ~= 0 then
    hop_options.count = vim.v.count
  else
    hop_options.count = 1
  end

  rabbit_hop.hop(hop_options)
end

M.repeat_backward = function()
  local last_hop_options = rabbit_hop.get_last_hop_options()
  if last_hop_options == nil then
    return
  end

  local hop_options = {
    pattern = last_hop_options.pattern,
    offset = last_hop_options.offset,
  }

  if not M._setup_options.use_relative_repetition then
    hop_options.direction = "backward"
  else
    if M._last_hop_direction == "forward" then
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

---@class IFT_SetupOptions
---@field use_default_mappings? boolean
---@field ignore_user_char_case? boolean
---@field use_relative_repetition? boolean

---@param opts? IFT_SetupOptions
M.setup = function(opts)
  opts = opts or {}
  M._setup_options = vim.tbl_extend("force", M._setup_options, opts)

  if M._setup_options.use_default_mappings then
    local map = function(key, fn, fn_options, description)
      vim.keymap.set({ "n", "x", "o" }, key, function()
        fn(fn_options)
      end, {
        desc = description,
      })
    end

    local description = "Jump forward to a given char"
    map("f", M.jump, { direction = "forward", offset = "none" }, description)

    description = "Jump backward to a given char"
    map("<S-f>", M.jump, { direction = "backward", offset = "none" }, description)

    description = "Jump forward before a given char"
    map("t", M.jump, { direction = "forward", offset = "pre" }, description)

    description = "Jump backward before a given char"
    map("<S-t>", M.jump, { direction = "backward", offset = "pre" }, description)

    map(";", M.repeat_forward, nil, "Jump forward to a last given char")
    map(",", M.repeat_backward, nil, "Jump backward to a last given char")
  end

  M._reset_state()
end

return M
