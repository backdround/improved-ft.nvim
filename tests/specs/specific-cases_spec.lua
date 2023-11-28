local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("specific-cases", function()
  before_each(h.get_preset([[
    a a | a a
  ]], { 1, 4 }))

  describe("should work in operator-pending mode after", function()
    before_each(h.get_preset([[
      a a | b b
      a a
    ]], { 1, 4 }))

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
end)
