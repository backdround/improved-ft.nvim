local rabbit_hop = require("improved-ft.rabbit-hop.api")
local utils = require("improved-ft.utils")

local M = {
  _last_hop_direction = "forward",
}

M.reset_state = function()
  rabbit_hop.reset_state()
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
        utils.get_user_inputed_pattern(config.ignore_char_case)
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

---@param config IFT_Conifg
---@param direction "forward"|"backward"
---@return function
M.get_repetition = function(config, direction)
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
      config.use_relative_repetition
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

return M
