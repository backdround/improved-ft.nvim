local M = {}

---@param position1 IFT_Position
---@param position2 IFT_Position
M.select_region = function(position1, position2)
  vim.api.nvim_buf_set_mark(0, "<", position1[1], position1[2], {})
  vim.api.nvim_buf_set_mark(0, ">", position2[1], position2[2], {})
  vim.cmd("normal! gv")
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
M.is_repeat = function()
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
M.get_user_inputed_pattern = function()
  local char = vim.fn.getchar()
  char =  vim.fn.nr2char(char)

  local special_symbols = "^$\\"
  if vim.go.magic then
    special_symbols = "*^$.~[]\\"
  end

  return vim.fn.escape(char, special_symbols)
end

return M
