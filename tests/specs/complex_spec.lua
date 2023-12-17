local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("complex cases", function()
  before_each(h.get_preset("a | a w a w a w a w a w end", { 1, 2 }))

  describe("operator pending modification by a repetition hop", function()
    it("shouldn't be affected by hops", function()
      h.hop_with_character(ft.hop_forward_to_char, "a")
      h.feedkeys("d", false)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.buffer("a |  w a w a w a w end")

      h.hop_with_character(ft.hop_forward_to_char, "w")
      h.feedkeys(".", true)
      assert.buffer("a |   w a w a w end")
    end)

    it("shouldn't affect repetition hops", function()
      h.hop_with_character(ft.hop_forward_to_char, "a")
      h.feedkeys("d", false)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.buffer("a |  w a w a w a w end")

      h.hop_with_character(ft.hop_forward_to_char, "w")
      h.feedkeys(".", true)
      assert.buffer("a |   w a w a w end")

      vim.wait(0)

      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(1, 6)
    end)
  end)
end)
