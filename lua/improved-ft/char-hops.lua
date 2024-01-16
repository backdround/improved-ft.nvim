local rabbit_hop = require("improved-ft.rabbit-hop.lua.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {
  hop_plug = "<Plug>(improved-ft-hop)",
  hop_dot_plug = "<Plug>(improved-ft-dot-hop)",
}

M.reset_state = function()
  M.last_real_rh_options = nil
  M.rh_options_to_perform = nil
  M.rh_dot_options_to_perform = nil
end
M.reset_state()

vim.keymap.set({ "n", "x", "o", "i" }, M.hop_plug, function()
  if M.rh_options_to_perform ~= nil then
    rabbit_hop.hop(M.rh_options_to_perform)
  end
end)

vim.keymap.set({ "n", "x", "o", "i" }, M.hop_dot_plug, function()
  if M.rh_dot_options_to_perform ~= nil then
    if vim.v.count ~= 0 then
      M.rh_dot_options_to_perform.count = vim.v.count
    end
    rabbit_hop.hop(M.rh_dot_options_to_perform)
  end
end)

---Performs hop through a <Plug>(...) mapping. It's required for correct
---dot and macro repetitions.
---@param rh_options RH_ApiHopOptions
---@return string mappings to use by a mapping with { expr = true }
M._perform = function(rh_options)
  if utils.mode() ~= "operator-pending" then
    M.rh_options_to_perform = rh_options
    return M.hop_plug
  end

  M.rh_dot_options_to_perform = rh_options
  return M.hop_dot_plug
end

---@param ignore_char_case boolean
---@param direction "forward"|"backward"
---@param offset number
---@return string mappings to use by a mapping with { expr = true }
M.hop = function(ignore_char_case, direction, offset)
  local pattern = utils.get_user_inputed_pattern(ignore_char_case)

  if pattern == nil then
    if utils.mode() == "operator-pending" then
      return "<Esc>"
    end
    return ""
  end

  local rh_options = {
    direction = direction,
    offset = offset,
    pattern = pattern,
    count = vim.v.count1,
    fold_policy = "ignore",
  }

  if rh_options.direction == "forward" then
    rh_options.insert_mode_target_side = "left"
  else
    rh_options.insert_mode_target_side = "right"
  end

  M.last_real_rh_options = rh_options
  return M._perform(rh_options)
end

---Repeats last hop.
---@param direction "forward"|"backward"
---@param direction_is_relative boolean direction is relative to a last hop direction
---@param offset_is_relative boolean offset is relative to a last hop direction
---@return string mappings to use by a mapping with { expr = true }
M.repeat_hop = function(direction, direction_is_relative, offset_is_relative)
  local last_hop_options = M.last_real_rh_options

  if last_hop_options == nil then
    if utils.mode() == "operator-pending" then
      return "<Esc>"
    end
    return ""
  end

  local rh_options = {
    pattern = last_hop_options.pattern,
    count = vim.v.count1,
    fold_policy = "ignore",
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

  return M._perform(rh_options)
end

return M
