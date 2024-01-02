local rabbit_hop = require("improved-ft.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {
  _last_hop_direction = "forward",
}

M.reset_state = function()
  rabbit_hop.reset_state()
end

local repeat_last_operator_pending_motion = function()
  local last_changing_hop_options =
    rabbit_hop.get_last_operator_pending_hop_options()

  if last_changing_hop_options == nil then
    return
  end

  local hop_options = {
    pattern = last_changing_hop_options.pattern,
    direction = last_changing_hop_options.direction,
    offset = last_changing_hop_options.offset,
    insert_mode_target_side = last_changing_hop_options.insert_mode_target_side,
  }

  if vim.v.count ~= 0 then
    hop_options.count = vim.v.count
  end

  rabbit_hop.hop(hop_options, false)
end

---@param ignore_char_case boolean
---@param direction "forward"|"backward"
---@param offset "pre"|"start"|"post"
M.hop = function(ignore_char_case, direction, offset)
  if utils.is_vim_repeat() then
    repeat_last_operator_pending_motion()
    return
  end

  local hop_options = {
    direction = direction,
    offset = offset,
    pattern = utils.get_user_inputed_pattern(ignore_char_case),
    count = vim.v.count1,
  }

  if hop_options.direction == "forward" then
    hop_options.insert_mode_target_side = "left"
  else
    hop_options.insert_mode_target_side = "right"
  end

  M._last_hop_direction = hop_options.direction or "forward"
  rabbit_hop.hop(hop_options, true)
end

---Repeats last hop forward.
---@param use_relative_repetition boolean
M.repeat_forward = function(use_relative_repetition)
  if utils.is_vim_repeat() then
    repeat_last_operator_pending_motion()
    return
  end

  local last_hop_options = rabbit_hop.get_last_hop_options()
  if last_hop_options == nil then
    return
  end

  local hop_options = {
    pattern = last_hop_options.pattern,
    offset = last_hop_options.offset,
    direction = "forward",
    insert_mode_target_side = "left",
    count = vim.v.count1,
  }

  if use_relative_repetition and M._last_hop_direction == "backward" then
    hop_options.direction = "backward"
    hop_options.insert_mode_target_side = "right"
  end

  rabbit_hop.hop(hop_options, true)
end

---Repeats last hop backward.
---@param use_relative_repetition boolean
M.repeat_backward = function(use_relative_repetition)
  if utils.is_vim_repeat() then
    repeat_last_operator_pending_motion()
    return
  end

  local last_hop_options = rabbit_hop.get_last_hop_options()
  if last_hop_options == nil then
    return
  end

  local hop_options = {
    pattern = last_hop_options.pattern,
    offset = last_hop_options.offset,
    direction = "backward",
    insert_mode_target_side = "right",
    count = vim.v.count1,
  }

  if use_relative_repetition and M._last_hop_direction == "backward" then
    hop_options.direction = "forward"
    hop_options.insert_mode_target_side = "left"
  end

  rabbit_hop.hop(hop_options, true)
end

return M
