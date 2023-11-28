local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("specific-cases", function()
  before_each(h.get_preset([[
    a a | a a
  ]], { 1, 4 }))

  describe("motion in operator-pending mode", function()
    before_each(h.get_preset([[
      a a | b b
      a a
    ]], { 1, 4 }))

    it("should work after linewise visual selection", function()
      h.feedkeys("V<esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)

    it("should work after charwise visual selection", function()
      h.feedkeys("v<esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)

    it("should work after blockwise visual selection", function()
      h.feedkeys("<C-v><esc>", true)

      h.trigger_delete()
      h.jump("forward", "none", "a")

      assert.buffer("a a  a")
    end)
  end)
end)
