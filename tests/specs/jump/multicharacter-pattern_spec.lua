local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("multicharacter-pattern-jump", function()
  before_each(h.get_preset([[
    a = <a_pattern> | words <a_pattern> here
  ]], { 1, 16 }))

  local pattern = "\\M<a_pattern>"

  describe("normal-mode", function()
    it("forward", function()
      h.jump("forward", "none", pattern)
      assert.cursor_at(1, 24)
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", pattern)
      assert.cursor_at(1, 23)
    end)

    it("post-forward", function()
      h.jump("forward", "post", pattern)
      assert.cursor_at(1, 35)
    end)

    it("backward", function()
      h.jump("backward", "none", pattern)
      assert.cursor_at(1, 4)
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", pattern)
      assert.cursor_at(1, 15)
    end)

    it("post-backward", function()
      h.jump("backward", "post", pattern)
      assert.cursor_at(1, 3)
    end)
  end)

  describe("visual-mode", function()
    before_each(h.trigger_visual)

    it("forward", function()
      h.jump("forward", "none", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 16 }, { 1, 34 })
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 16 }, { 1, 23 })
    end)

    it("post-forward", function()
      h.jump("forward", "post", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 16 }, { 1, 35 })
    end)


    it("backward", function()
      h.jump("backward", "none", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 4 }, { 1, 16 })
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 15 }, { 1, 16 })
    end)

    it("post-backward", function()
      h.jump("backward", "post", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 3 }, { 1, 16 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(h.trigger_delete)

    it("forward", function()
      h.jump("forward", "none", pattern)
      assert.buffer("a = <a_pattern>  here")
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", pattern)
      assert.buffer("a = <a_pattern> <a_pattern> here")
    end)

    it("post-forward", function()
      h.jump("forward", "post", pattern)
      assert.buffer("a = <a_pattern> here")
    end)

    it("backward", function()
      h.jump("backward", "none", pattern)
      assert.buffer("a = | words <a_pattern> here")
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", pattern)
      assert.buffer("a = <a_pattern>| words <a_pattern> here")
    end)

    it("post-backward", function()
      h.jump("backward", "post", pattern)
      assert.buffer("a =| words <a_pattern> here")
    end)
  end)
end)
