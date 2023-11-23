local M = {}

---@Converts a position with virtual coordinates to a byte position.
---@param position IFT_Position
---@return number[]
local function convert_from_position_to_bytes(position)
  local line = position[1]
  local column = vim.fn.virtcol2col(0, line, position[2] + 1) - 1

  -- Convert column manually if position points to a \n
  if column ~= 0 then
    if column == (vim.fn.virtcol2col(0, line, position[2]) - 1) then
      local current_line =
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      column = current_line:len() + 1
    end
  end

  return { line, column }
end

---@Converts a byte position to a virtual coordinates position.
---@param byte_position number[]
---@return  IFT_Position
M.convert_from_bytes_to_position = function(byte_position)
  return {
    byte_position[1],
    vim.fn.virtcol(byte_position)
  }
end

---@param position1 IFT_Position
---@param position2 IFT_Position
M.select_region = function(position1, position2)
  local byte_position1 = convert_from_position_to_bytes(position1)
  local byte_position2 = convert_from_position_to_bytes(position2)
  vim.api.nvim_buf_set_mark(0, "<", byte_position1[1], byte_position1[2], {})
  vim.api.nvim_buf_set_mark(0, ">", byte_position2[1], byte_position2[2], {})
  vim.cmd("normal! gv")
end

---@param position IFT_Position
M.set_cursor = function(position)
  local byte_position = convert_from_position_to_bytes(position)
  vim.api.nvim_win_set_cursor(0, byte_position)
end

---@return "operator-pending"|"visual"|"normal"
M.mode = function()
  local m = tostring(vim.fn.mode(true))

  if m:find("o") then
    return "operator-pending"
  elseif m:find("[vV]") then
    return "visual"
  else
    return "normal"
  end
end

---Returns current neovim repeat state.
---@return boolean
M.is_vim_repeat = function()
  if M._is_repeat == nil then
    M._is_repeat = false
    -- Add repeat tracker
    vim.on_key(function(key)
      if key == "." then
        M._is_repeat = true
        vim.schedule(function()
          M._is_repeat = false
        end)
      end
    end)
  end

  return M._is_repeat
end

---Returns user's pattern to search
---@return string
M.get_user_inputed_char = function()
  local char = vim.fn.getchar()
  char = vim.fn.nr2char(char)
  return char
end

return M
