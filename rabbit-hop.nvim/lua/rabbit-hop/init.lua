local hop_api = require("rabbit-hop.api")

local M = {}

M.hop = function(user_options)
  user_options = vim.deepcopy(user_options)

  if vim.v.count ~= 0 then
    user_options.count = vim.v.count
  else
    user_options.count = 1
  end

  hop_api.hop(user_options)
end

return M
