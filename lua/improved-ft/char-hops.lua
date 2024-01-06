local rabbit_hop = require("improved-ft.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {}

M.reset_state = function()
  M._cache = {
    last_hop_rh_options = nil,
    changing_rh_options = nil,
  }
end
M.reset_state()

local repeat_last_operator_pending_motion = function()
  local last_changing_rh_options = M._cache.changing_rh_options
  if last_changing_rh_options == nil then
    return
  end

  local rh_options = {
    pattern = last_changing_rh_options.pattern,
    direction = last_changing_rh_options.direction,
    offset = last_changing_rh_options.offset,
    insert_mode_target_side = last_changing_rh_options.insert_mode_target_side,
  }

  if vim.v.count ~= 0 then
    rh_options.count = vim.v.count
  end

  rabbit_hop.hop(rh_options)
end

---@param ignore_char_case boolean
---@param direction "forward"|"backward"
---@param offset number
M.hop = function(ignore_char_case, direction, offset)
  if utils.is_vim_repeat() then
    repeat_last_operator_pending_motion()
    return
  end

  local pattern = utils.get_user_inputed_pattern(ignore_char_case)
  if pattern == nil then
    utils.reset_mode()
    return
  end

  local rh_options = {
    direction = direction,
    offset = offset,
    pattern = pattern,
    count = vim.v.count1,
  }

  if rh_options.direction == "forward" then
    rh_options.insert_mode_target_side = "left"
  else
    rh_options.insert_mode_target_side = "right"
  end

  M._cache.last_hop_rh_options = rh_options
  if utils.mode() == "operator-pending" then
    M._cache.changing_rh_options = rh_options
  end

  rabbit_hop.hop(rh_options)
end

---@param direction "forward"|"backward"
---@param direction_is_relative boolean direction is relative to a last hop direction
---@param offset_is_relative boolean offset is relative to a last hop direction
---@return RH_ApiHopOptions?
M._get_repetition_options = function(
  direction,
  direction_is_relative,
  offset_is_relative
)
  local last_hop_options = M._cache.last_hop_rh_options
  if last_hop_options == nil then
    return nil
  end

  local rh_options = {
    pattern = last_hop_options.pattern,
    count = vim.v.count1,
  }

  -- Set direction
  local invert_direction = last_hop_options.direction == "backward"
    and direction_is_relative

  rh_options.direction = direction
  if invert_direction then
    if direction == "forward" then
      rh_options.direction = "backward"
    else
      rh_options.direction = "forward"
    end
  end

  -- Set insert_mode_target_side
  if rh_options.direction == "forward" then
    rh_options.insert_mode_target_side = "left"
  else
    rh_options.insert_mode_target_side = "right"
  end

  -- Set offset
  local move_other_side = rh_options.direction ~= last_hop_options.direction
  if offset_is_relative and move_other_side then
    rh_options.offset = last_hop_options.offset * -1
  else
    rh_options.offset = last_hop_options.offset
  end

  return rh_options
end

---Repeats last hop.
---@param direction "forward"|"backward"
---@param direction_is_relative boolean direction is relative to a last hop direction
---@param offset_is_relative boolean offset is relative to a last hop direction
M.repeat_hop = function(direction, direction_is_relative, offset_is_relative)
  if utils.is_vim_repeat() then
    repeat_last_operator_pending_motion()
    return
  end

  local rh_options = M._get_repetition_options(
    direction,
    direction_is_relative,
    offset_is_relative
  )

  if rh_options == nil then
    return
  end

  if utils.mode() == "operator-pending" then
    M._cache.changing_rh_options = rh_options
  end

  rabbit_hop.hop(rh_options)
end

return M
