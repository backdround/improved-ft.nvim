local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("v:count", function()
  before_each(h.get_preset([[
    a a a a a a
  ]], { 1, 0 }))

  it("should be respected during jump", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.perform_through_keymap(ft.to_char_forward, "a")
    assert.cursor_at(1, 6)
  end)

  it("should be respected during repeat", function()
    h.perform_through_keymap(ft.to_char_forward, "a")
    vim.api.nvim_feedkeys("3", "n", false)
    h.perform_through_keymap(ft.repeat_forward)
    assert.cursor_at(1, 8)
  end)

  it(
    "should be taken as a maximal possible count if v:count is too big",
    function()
      vim.api.nvim_feedkeys("22", "n", false)
      h.perform_through_keymap(ft.to_char_forward, "a")
      assert.cursor_at(1, 10)
    end
  )
end)
