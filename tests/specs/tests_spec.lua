local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

local function preset()
  h.set_current_buffer([[
    {
    several words
    here
    }
  ]])
  h.set_cursor(2, 0)

  local escape = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(escape, "nx", false)
end

describe("a describe stub", function()
  before_each(preset)
  it("a test stub", function()
    assert.cursor_at(2, 0)
  end)
end)
