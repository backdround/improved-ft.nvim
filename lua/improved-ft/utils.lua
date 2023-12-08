local M = {}

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

---Returns user's pattern to jump
---@pattern ignore_case boolean
---@return string
M.get_user_inputed_pattern = function(ignore_case)
  local char = vim.fn.getchar()
  char = vim.fn.nr2char(char)

  local pattern = "\\M" .. vim.fn.escape(char, "^$\\")

  local search_flags = "\\C"
  if ignore_case then
    search_flags = "\\c"
  end

  pattern = search_flags .. pattern
  return pattern
end

return M
