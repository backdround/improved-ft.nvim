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

M.trigger_visual = function()
  vim.api.nvim_feedkeys("v", "n", false)
end

M.trigger_delete = function()
  vim.api.nvim_feedkeys("d", "n", false)
end

M.reset_mode = function()
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)
end

---@param keys string
---@param wait_for_finish boolean
M.feedkeys = function(keys, wait_for_finish)
  local flags = "n"
  if wait_for_finish then
    flags = flags .. "x"
  end

  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, flags, false)
end

---@param line number 1-bazed
---@param column number 0-bazed virtual column
M.set_cursor = function(line, column)
  column = vim.fn.virtcol2col(0, line, column + 1) - 1
  vim.api.nvim_win_set_cursor(0, { line, column })
end

M.reset_ft = function()
  ft._reset_state()
end

M.remove_all_mappings = function()
  local keymaps = vim.api.nvim_get_keymap("")

  for _, keymap in ipairs(keymaps) do
    vim.keymap.del(keymap.mode, keymap.lhs)
  end
end

---Performs the ft.jump through a keymap
---@param direction "forward"|"backward"
---@param offset "pre"|"post"|"none"
---@param pattern string|nil
---@param additional_options table|nil
M.jump = function(direction, offset, pattern, additional_options)
  local jump_options = vim.deepcopy(additional_options or {})
  jump_options.direction = direction
  jump_options.offset = offset
  jump_options.pattern = pattern

  M.perform_through_keymap(ft.jump, true, jump_options)
end

---Performs the ft.repeat_forward/backward through a keymap
---@param direction "forward"|"backward"
M.repeat_jump = function(direction)
  M.perform_through_keymap(function()
    if direction == "forward" then
      ft.repeat_forward()
    else
      ft.repeat_backward()
    end
  end, true)
end

---Performs a given function with given arguments through a keymap
---@param fn function to perofrm
---@param wait_for_finish boolean
---@param ... any arguments for fn
M.perform_through_keymap = function(fn, wait_for_finish, ...)
  local args = {...}
  local map_label = "<Plug>(perform_through_keymap)"
  vim.keymap.set({ "n", "o", "x" }, map_label, function()
    fn(unpack(args))
  end)
  local keys = vim.api.nvim_replace_termcodes(map_label, true, false, true)

  local feedkeys_flags = wait_for_finish and "x" or ""
  vim.api.nvim_feedkeys(keys, feedkeys_flags, false)
end

return M
