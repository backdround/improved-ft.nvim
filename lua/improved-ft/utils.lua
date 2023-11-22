local M = {}

---@param line number
---@param virt_column number
---@return number
local function virt_column_to_byte_index(line, virt_column)
  local new_column = vim.fn.virtcol2col(0, line, virt_column + 1) - 1

  -- convert manually if virt_column points to a \n
  if new_column ~= 0 then
    if new_column == (vim.fn.virtcol2col(0, line, virt_column) - 1) then
      local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      return current_line:len() + 1
    end
  end

  return new_column
end

---@param position1 IFT_Position
---@param position2 IFT_Position
M.select_region = function(position1, position2)
  vim.api.nvim_buf_set_mark(0, "<", position1[1], position1[2], {})
  vim.api.nvim_buf_set_mark(0, ">", position2[1], position2[2], {})
  vim.cmd("normal! gv")
end

---@param position IFT_Position
M.set_cursor = function(position)
  local line = position[1]
  local column = virt_column_to_byte_index(position[1], position[2])
  vim.api.nvim_win_set_cursor(0, { line, column })
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
