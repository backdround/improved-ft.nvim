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

  if #lines == 0 then
    return { "" }
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
---@param cursor_position? number[] position to place the cursor
---@return function
M.get_preset = function(buffer_text, cursor_position)
  cursor_position = cursor_position or { 1, 1 }

  return function()
    -- Reset mode
    M.reset_mode()

    -- Reset options
    vim.go.selection = "inclusive"

    -- Reset last visual selection mode
    local last_visual_mode = nil
    while last_visual_mode ~= "" do
      last_visual_mode = vim.fn.visualmode(1)
    end

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
  -- Wait for visual mode to take place.
  local plug_label = "<Plug>(perform_through_keymap)"
  local plug_key = vim.api.nvim_replace_termcodes(plug_label, true, false, true)

  vim.keymap.set({ "n", "o", "x", "i" }, plug_label, function() end)
  vim.api.nvim_feedkeys(plug_key, "x", false)
end

M.trigger_delete = function()
  vim.api.nvim_feedkeys("d", "n", false)
end

M.reset_mode = function()
  local exit = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(exit, "nx", false)
  vim.api.nvim_feedkeys(escape, "n", false)
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

---@param line number 1-based
---@param char_index number 1-based character index
M.set_cursor = function(line, char_index)
  vim.fn.setcursorcharpos(line, char_index)
end

M.remove_all_mappings = function()
  local keymaps = vim.api.nvim_get_keymap("")

  for _, keymap in ipairs(keymaps) do
    if keymap.lhs:find("<Plug>") == nil then
      vim.keymap.del(keymap.mode, keymap.lhs)
    end
  end
end

---Performs a given hop function with a given character
---@param hop_function function
---@param char string
M.hop_with_character = function(hop_function, char)
  M.perform_through_keymap(hop_function, false)
  M.feedkeys(char, true)
end

---Performs a given function through a keymap
---@param fn function to perofrm
---@param wait_for_finish boolean
M.perform_through_keymap = function(fn, wait_for_finish)
  local map_label = "<Plug>(perform_through_keymap)"
  vim.keymap.set({ "n", "o", "x", "i" }, map_label, fn, { expr = true })
  local keys = vim.api.nvim_replace_termcodes(map_label, true, false, true)

  local feedkeys_flags = wait_for_finish and "x" or ""
  vim.api.nvim_feedkeys(keys, feedkeys_flags, false)
end

return M
