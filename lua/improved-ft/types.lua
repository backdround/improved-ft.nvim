
---Represents cursor position.
---@class IFT_Position
---@field [1] number line index: [1, last_line_index]
---@field [2] number column index: [0, last_symbol_index / \n_index]

---Options that describe a jump behaviour.
---@class IFT_JumpOptions
---@field forward boolean direction to jump.
---@field char string char to which to jump
---@field pre boolean jump one symbol before pattern
---@field count number count of jumps to perform
