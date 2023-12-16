local hop = require(... .. ".hop")
local api_options_utils = require(... .. ".api-options-utils")

local M = {}

---@return boolean
local is_operator_pending_mode = function()
  return vim.fn.mode(true):find("o") ~= nil
end

M.reset_state = function()
  M._last_hop_options = nil
  M._last_operator_pending_hop_options = nil
end
M.reset_state()

---@param api_hop_options RH_ApiHopOptions
M.hop = function(api_hop_options)
  local hop_options = api_options_utils.get_hop_options(api_hop_options)
  M._last_hop_options = hop_options
  if is_operator_pending_mode() then
    M._last_operator_pending_hop_options = hop_options
  end
  hop(hop_options)
end

---@return RH_HopOptions|nil
M.get_last_hop_options = function()
  return vim.deepcopy(M._last_hop_options)
end

---@return RH_HopOptions|nil
M.get_last_operator_pending_hop_options = function()
  return vim.deepcopy(M._last_operator_pending_hop_options)
end

return M
