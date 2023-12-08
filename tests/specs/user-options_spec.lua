local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("user-options", function()
  before_each(h.get_preset([[
    a b a b a b a b
  ]], { 1, 0 }))

  it("can be empty", function()
    h.perform_through_keymap(ft.jump, false)
    vim.api.nvim_feedkeys("a", "x", false)
    assert.cursor_at(1, 4)
  end)

  it("'direction' should be 'forward' by default", function()
    h.jump(nil, "none", "a")
    assert.cursor_at(1, 4)
  end)

  it("'offset' should be 'none' by default", function()
    h.jump("forward", nil, "a")
    assert.cursor_at(1, 4)
  end)
end)
