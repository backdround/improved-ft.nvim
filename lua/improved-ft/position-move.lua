local M = {}

---@param index number line index
---@param n_is_placeable boolean cursor can be placed at a "\n"
---@return number
local function line_length(index, n_is_placeable)
  local line = vim.api.nvim_buf_get_lines(0, index - 1, index, true)[1]

  if n_is_placeable then
    return line:len()
  end

  return line:len() - 1
end

---Transforms any position to position into the current buffer's boundaries.
---@param position IFT_Position
---@param n_is_placeable boolean cursor can be placed at a "\n"
---@return IFT_Position
local function normalize(position, n_is_placeable)
  ------------------------------
  -- Check line boundaries
  if position[1] < 1 then
    return { 1, 0 }
  end

  local last_line = vim.api.nvim_buf_line_count(0)
  if position[1] > last_line then
    local last_line_length = line_length(last_line, n_is_placeable)
    return { last_line, last_line_length }
  end

  ------------------------------
  -- Check column boundaries
  if position[2] < 0 then
    return { position[1], 0 }
  end

  local current_line_length = line_length(position[1], n_is_placeable)
  if position[2] > current_line_length then
    return { position[1], current_line_length }
  end

  ------------------------------
  -- All is in boundaries
  return vim.deepcopy(position)
end

---Moves the given position backward once in the current buffer.
---@param position IFT_Position
---@param n_is_placeable boolean cursor can be placed at a "\n"
---@return IFT_Position
M.backward_once = function(position, n_is_placeable)
  position = normalize(position, n_is_placeable)

  if position[1] == 1 and position[2] == 0 then
    return { 1, 0 }
  end

  if position[2] == 0 then
    local previous_line_length = line_length(position[1] - 1, n_is_placeable)
    return { position[1] - 1, previous_line_length }
  end

  return { position[1], position[2] - 1 }
end

---Moves the given position forward once in the current buffer.
---@param position IFT_Position
---@param n_is_placeable boolean cursor can be placed at a "\n"
---@return IFT_Position
M.forward_once = function(position, n_is_placeable)
  position = normalize(position, n_is_placeable)

  local last_line = vim.api.nvim_buf_line_count(0)
  local current_line_length = line_length(position[1], n_is_placeable)
  if position[1] == last_line and position[2] == current_line_length then
    return { last_line, current_line_length }
  end

  if position[2] == current_line_length then
    return { position[1] + 1, 0 }
  end

  return { position[1], position[2] + 1 }
end

return M
