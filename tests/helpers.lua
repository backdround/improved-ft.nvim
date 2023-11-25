local ft = require("improved-ft")
local M = {}

---Formats text and split to lines.
---@param text string
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

---Returns a function that resets neovim state
---@param buffer_text string to set current buffer
---@param cursor_position number[]
---@return function
M.get_preset = function(buffer_text, cursor_position)
  return function()
    -- Reset mode
    M.reset_mode()

    -- Reset last selected region
    vim.api.nvim_buf_set_mark(0, "<", 0, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", 0, 0, {})

    -- Wait for deferred cleanups
    vim.wait(0)

    -- Set the current buffer
    local lines = M.get_user_lines(buffer_text)
    local last_line_index = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_buf_set_lines(0, 0, last_line_index, true, lines)

    -- Set the cursor
    M.set_cursor(unpack(cursor_position))
  end
end

M.reset_mode = function()
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)
end

---@param line number 1-bazed
---@param column number 0-bazed virtual column
M.set_cursor = function(line, column)
  column = vim.fn.virtcol2col(0, line, column + 1) - 1
  vim.api.nvim_win_set_cursor(0, { line, column })
end

M.reload_ft = function()
  package.loaded["improved-ft"] = nil
  ft = require("improved-ft")
end

---Performs the ft.jump through a keymap
---@param direction "forward"|"backward"
---@param offset "pre"|"post"|"none"
---@param pattern string
M.jump = function(direction, offset, pattern)
  local map_label = "<Plug>(jump_through_keymap)"
  vim.keymap.set({ "n", "o", "x" }, map_label, function()
    ft.jump({
      direction = direction,
      pattern = pattern,
      offset = offset,
    })
  end)
  local keys = vim.api.nvim_replace_termcodes(map_label, true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)
end

---Performs the ft.repeat_forward/backward through a keymap
---@param direction "forward"|"backward"
M.repeat_jump = function(direction)
  local map_label = "<Plug>(repeat_jump_through_keymap)"
  vim.keymap.set({ "n", "o", "x" }, map_label, function()
    if direction == "forward" then
      ft.repeat_forward()
    else
      ft.repeat_backward()
    end
  end)
  local keys = vim.api.nvim_replace_termcodes(map_label, true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)
end

return M
