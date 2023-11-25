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
  if pattern ~= nil and type(pattern) ~= "string" then
    error(
      "pattern must be a string or nil, but it is: "
        .. tostring(type(pattern))
    )
  end
end

local assert_offset = function(offset)
  if
    offset ~= nil
    and offset ~= "pre"
    and offset ~= "post"
    and offset ~= "none"
  then
    error(
      'offset must be one of these "pre"|"post"|"none"|nil, but it is: '
        .. tostring(offset)
    )
  end
end

---Options that a user gives
---@class IFT_UserJumpOptions
---@field direction "forward"|"backward"|nil direction to search a given pattern
---@field offset "pre"|"post"|"none"|nil offset to cursor to place
---@field pattern string|nil pattern to search

---Asserts all the fields of the options
---@param options IFT_UserJumpOptions
M.assert = function(options)
  assert_direction(options.direction)
  assert_pattern(options.pattern)
  assert_offset(options.offset)
end

return M
