local M = {}

---@return string[]
M.get_user_lines = function(text)
  text = text or ""
  local lines = vim.fn.split(text, "\n")

  -- Remove first line if empty
  if lines[1] and lines[1]:match("^[%s]*$") then
    table.remove(lines, 1)
  end

  -- Remove last line if empty
  if lines[#lines] and lines[#lines]:match("^[%s]*$") then
    table.remove(lines, #lines)
  end

  -- Find minimal prepending space gap
  local min_prepending_gap = lines[1]:match("^[%s]*"):len()
  for _, line in pairs(lines) do
    local prepending_gap = line:match("^[%s]*"):len()
    if prepending_gap > 0 and prepending_gap < min_prepending_gap then
      min_prepending_gap = prepending_gap
    end
  end

  -- Remove the prepending space gap
  for i, line in pairs(lines) do
    lines[i] = line:sub(min_prepending_gap + 1)
  end

  return lines
end

M.set_current_buffer = function(text)
  local lines = M.get_user_lines(text)

  -- Set current buffer
  local last_line_index = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(0, 0, last_line_index, true, lines)
end

M.reset_mode = function()
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)
end

M.reset_last_selected_region = function()
  vim.api.nvim_buf_set_mark(0, "<", 0, 0, {})
  vim.api.nvim_buf_set_mark(0, ">", 0, 0, {})
end

M.set_cursor = function(line, column)
  vim.api.nvim_win_set_cursor(0, {line, column})
end

M.perform_through_keymap = function(func, additional_keys)
  local map_label = "<Plug>(perform_through_keymap)"
  vim.keymap.set({ "n", "o", "x" }, map_label, func)
  local keys = map_label .. additional_keys
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)
end

return M
