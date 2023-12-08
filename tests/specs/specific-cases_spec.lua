local h = require("tests.helpers")
local ft = require("improved-ft")

require("tests.custom-asserts").register()

describe("specific-cases", function()
  before_each(h.get_preset([[
    a a | b b
    a a
  ]], { 1, 4 }))

  describe("should work in operator-pending mode after", function()
    it("linewise visual selection", function()
      h.feedkeys("V<esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)

    it("charwise visual selection", function()
      h.feedkeys("v<esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)

    it("blockwise visual selection", function()
      h.feedkeys("<C-v><esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)

    it("none visual selection", function()
      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)
  end)

  describe("should work properly with 'selection' == 'exclusive'", function()
    before_each(function()
      vim.go.selection = "exclusive"
    end)

    it("during backward jump", function()
      h.trigger_visual()
      h.perform_through_keymap(ft.jump, false, {
        direction = "backward",
        offset = "none",
      })
      h.feedkeys("ad", true)

      assert.buffer([[
        a | b b
        a a
      ]])
    end)

    it("during forward jump", function()
      h.trigger_visual()
      h.perform_through_keymap(ft.jump, false, {
        direction = "forward",
        offset = "none",
      })
      h.feedkeys("bd", true)

      assert.buffer([[
        a a  b
        a a
      ]])
    end)

    it("during forward jump to a new line", function()
      h.trigger_visual()
      h.feedkeys("2", false)
      h.perform_through_keymap(ft.jump, false, {
        direction = "forward",
        offset = "post",
      })
      h.feedkeys("bd", true)

      assert.buffer([[
        a a a a
      ]])
    end)
  end)
end)
