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

---@class IFT_Conifg
---@field ignore_char_case boolean
---@field use_relative_repetition boolean

---@param config IFT_Conifg
---@param direction "forward"|"backward"
---@param offset "pre"|"start"|"post"
---@return function
M.get_hop = function(config, direction, offset)
  return function()
    if utils.is_vim_repeat() then
      repeat_last_operator_pending_motion()
      return
    end

    local hop_options = {
      direction = direction,
      offset = offset,
      pattern = utils.get_user_inputed_pattern(config.ignore_char_case)
    }

    if utils.mode() == "insert" then
      if hop_options.direction == "forward" then
        hop_options.insert_mode_target_side = "left"
      else
        hop_options.insert_mode_target_side = "right"
      end
    end

    if vim.v.count ~= 0 then
      hop_options.count = vim.v.count
    else
      hop_options.count = 1
    end

    M._last_hop_direction = hop_options.direction or "forward"
    rabbit_hop.hop(hop_options, true)
  end
end

---@param config IFT_Conifg
---@param direction "forward"|"backward"
---@return function
M.get_repetition = function(config, direction)
  return function()
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
      direction = direction,
    }

    if
      config.use_relative_repetition
      and M._last_hop_direction == "backward"
    then
      if hop_options.direction == "forward" then
        hop_options.direction = "backward"
      else
        hop_options.direction = "forward"
      end
    end

    if utils.mode() == "insert" then
      if hop_options.direction == "forward" then
        hop_options.insert_mode_target_side = "left"
      else
        hop_options.insert_mode_target_side = "right"
      end
    end

    if vim.v.count ~= 0 then
      hop_options.count = vim.v.count
    else
      hop_options.count = 1
    end

    rabbit_hop.hop(hop_options, true)
  end
end

return M
