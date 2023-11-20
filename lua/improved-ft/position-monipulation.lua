local M = {}

---@param index number line index
---@return number
local function line_length(index)
  local line = vim.api.nvim_buf_get_lines(0, index - 1, index, true)[1]
  return line:len()
end

---Transforms any position to position into the current buffer's boundaries.
---@param position IFT_Position
---@return IFT_Position
local function normalize(position)
  ------------------------------
  -- Check line boundaries
  if position[1] < 1 then
    return { 1, 0 }
  end

  local last_line = vim.api.nvim_buf_line_count(0)
  if position[1] > last_line then
    return { last_line, line_length(last_line) }
  end

  ------------------------------
  -- Check column boundaries
  if position[2] < 0 then
    return { position[1], 0 }
  end

  local current_line_length = line_length(position[1])
  if position[2] > current_line_length then
    return { position[1], current_line_length }
  end

  ------------------------------
  -- All is in boundaries
  return vim.deepcopy(position)
end

---Moves the given position backward once in the current buffer.
---@param position IFT_Position
---@return IFT_Position
M.move_backward_once = function(position)
  position = normalize(position)

  if position[1] == 1 and position[2] == 0 then
    return { 1, 0 }
  end

  if position[2] == 0 then
    return { position[1] - 1, line_length(position[1] - 1) }
  end

  return { position[1], position[2] - 1 }
end

---Moves the given position forward once in the current buffer.
---@param position IFT_Position
---@return IFT_Position
M.move_forward_once = function(position)
  position = normalize(position)

  local last_line = vim.api.nvim_buf_line_count(0)
  local current_line_length = line_length(position[1])
  if position[1] == last_line and position[2] == current_line_length then
    return { last_line, current_line_length }
  end

  if position[2] == current_line_length then
    return { position[1] + 1, 0 }
  end

  return { position[1], position[2] + 1 }
end

return M
