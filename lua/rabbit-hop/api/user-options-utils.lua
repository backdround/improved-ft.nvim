local M = {}

local assert_direction = function(direction)
  if
    direction ~= nil
    and direction ~= "forward"
    and direction ~= "backward"
  then
    error(
      'direction must be one of these "forward"|"backward"|nil, but it is: '
        .. tostring(direction)
    )
  end
end

local assert_pattern = function(pattern)
  if type(pattern) ~= "string" then
    error("pattern must be a string, but it is: " .. tostring(type(pattern)))
  end
end

local assert_offset = function(offset)
  if
    offset ~= nil
    and offset ~= "pre"
    and offset ~= "start"
    and offset ~= "end"
    and offset ~= "post"
  then
    error(
      'offset must be one of these "pre"|"start"|"end"|"post"|nil, but it is: '
        .. tostring(offset)
    )
  end
end

local assert_count = function(count)
  if count ~= nil and type(count) ~= "number" then
    error("count must be a number, but it is: " .. tostring(type(count)))
  end
end

---Options that an api user gives
---@class RH_UserHopOptions
---@field pattern string pattern to search
---@field direction? "forward"|"backward" direction to search a given pattern
---@field offset? "pre"|"start"|"end"|"post" offset to cursor to place
---@field count number? count of hops to perform

---Checks and fills empty fields with default values
---@param options RH_UserHopOptions
---@return RH_HopOptions
M.get_hop_options = function(options)
  if type(options) ~= "table" then
    error("hop options must be a table, but it is: " .. tostring(type(options)))
  end

  assert_pattern(options.pattern)
  assert_direction(options.direction)
  assert_offset(options.offset)
  assert_count(options.count)

  local default = {
    direction = "forward",
    offset = "start",
    count = 1
  }

  local hop_options = vim.tbl_extend("force", default, options)
  return hop_options
end

return M
