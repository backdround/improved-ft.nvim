local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("misc", function()
  before_each(h.get_preset([[
    a a a a a a
  ]], { 1, 0 }))

  describe("v:count", function()
    it("should be respected during jump", function()
      vim.api.nvim_feedkeys("3", "n", false)
      h.jump("forward", "none", "a")
      assert.cursor_at(1, 6)
    end)

    it("should be respected during repeat", function()
      h.jump("forward", "none", "a", { save_for_repetition = true })
      vim.api.nvim_feedkeys("3", "n", false)
      h.repeat_jump("forward")
      assert.cursor_at(1, 8)
    end)

    it(
      "should be taken as a maximal possible count if v:count is too big",
      function()
        vim.api.nvim_feedkeys("22", "n", false)
        h.jump("forward", "none", "a")
        assert.cursor_at(1, 10)
      end
    )
  end)

  describe("interactive jump", function()
    it("should take char from user input if a given pattern is nil", function()
      h.perform_through_keymap(ft.jump, {
        direction = "forward",
        offset = "none",
        pattern = nil
      })
      vim.api.nvim_feedkeys("a", "x", false)
      assert.cursor_at(1, 2)
    end)
  end)
end)
