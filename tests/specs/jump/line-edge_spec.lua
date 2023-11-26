local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("line-edge-jump", function()
  before_each(h.get_preset([[
    a = some words here
    b = | words
    c = other words
  ]], { 2, 4 }))

  describe("normal-mode", function()
    it("forward", function()
      h.jump("forward", "none", "c")
      assert.cursor_at(3, 0)
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "c")
      assert.cursor_at(2, 10)
    end)

    it("post-forward", function()
      h.jump("forward", "post", "s")
      assert.cursor_at(3, 0)
    end)

    it("backward", function()
      h.jump("backward", "none", "e")
      assert.cursor_at(1, 18)
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "e")
      assert.cursor_at(2, 0)
    end)

    it("post-backward", function()
      h.jump("backward", "post", "b")
      assert.cursor_at(1, 18)
    end)
  end)

  describe("visual-mode", function()
    before_each(h.trigger_visual)

    it("forward", function()
      h.jump("forward", "none", "c")
      h.reset_mode()
      assert.last_selected_region({ 2, 4 }, { 3, 0 })
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "c")
      h.reset_mode()
      assert.last_selected_region({ 2, 4 }, { 2, 11 })
    end)

    it("post-forward", function()
      h.jump("forward", "post", "s")
      h.reset_mode()
      assert.last_selected_region({ 2, 4 }, { 2, 11 })
    end)

    it("backward", function()
      h.jump("backward", "none", "e")
      h.reset_mode()
      assert.last_selected_region({1, 18}, { 2, 4 })
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "e")
      h.reset_mode()
      assert.last_selected_region({1, 19}, { 2, 4 })
    end)

    it("post-backward", function()
      h.jump("backward", "post", "b")
      h.reset_mode()
      assert.last_selected_region({ 1, 19 }, { 2, 4 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(h.trigger_delete)

    it("forward", function()
      h.jump("forward", "none", "c")
      assert.buffer([[
        a = some words here
        b =  = other words
      ]])
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "c")
      assert.buffer([[
        a = some words here
        b = c = other words
      ]])
    end)

    it("post-forward", function()
      h.jump("forward", "post", "s")
      assert.buffer([[
        a = some words here
        b = c = other words
      ]])
    end)

    it("backward", function()
      h.jump("backward", "none", "e")
      assert.buffer([[
        a = some words her| words
        c = other words
      ]])
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "e")
      assert.buffer([[
        a = some words here| words
        c = other words
      ]])
    end)

    it("post-backward", function()
      h.jump("backward", "post", "b")
      assert.buffer([[
        a = some words here| words
        c = other words
      ]])
    end)
  end)
end)
