local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("multiline-jump", function()
  before_each(h.get_preset([[
    a = some words here
    |
    b = other words
  ]], { 2, 0 }))

  describe("normal-mode", function()
    it("forward", function()
      h.jump("forward", "none", "=")
      assert.cursor_at(3, 2)
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "=")
      assert.cursor_at(3, 1)
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      assert.cursor_at(1, 2)
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      assert.cursor_at(1, 3)
    end)
  end)

  describe("visual-mode", function()
    before_each(h.trigger_visual)

    it("forward", function()
      h.jump("forward", "none", "=")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 2 })
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "=")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 1 })
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 2 }, { 2, 0 })
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 3 }, { 2, 0 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(h.trigger_delete)

    it("forward", function()
      h.jump("forward", "none", "=")
      assert.buffer([[
        a = some words here
         other words
      ]])
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "=")
      assert.buffer([[
        a = some words here
        = other words
      ]])
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      assert.buffer([[
        a |
        b = other words
      ]])
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      assert.buffer([[
        a =|
        b = other words
      ]])
    end)
  end)
end)
