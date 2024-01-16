local M = {}

local replace_termcodes = function(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

---@return "operator-pending"|"visual"|"normal"|"insert"
M.mode = function()
  local m = tostring(vim.fn.mode(true))

  if m:find("o") then
    return "operator-pending"
  elseif m:find("[vV]") then
    return "visual"
  elseif m:find("i") then
    return "insert"
  else
    return "normal"
  end
end

---Returns user's pattern to hop
---@param ignore_char_case boolean
---@return string?
M.get_user_inputed_pattern = function(ignore_char_case)
  local char = vim.fn.getchar()
  char = vim.fn.nr2char(char)

  if char == replace_termcodes("<esc>") then
    return nil
  end

  local pattern = "\\M" .. vim.fn.escape(char, "^$\\")

  local search_flags = "\\C"
  if ignore_char_case then
    search_flags = "\\c"
  end

  pattern = search_flags .. pattern
  return pattern
end

M.reset_mode = function()
  local exit = replace_termcodes("<C-\\><C-n>")
  local escape = replace_termcodes("<Esc>")
  vim.api.nvim_feedkeys(exit, "nx", false)
  vim.api.nvim_feedkeys(escape, "n", false)
end

return M
