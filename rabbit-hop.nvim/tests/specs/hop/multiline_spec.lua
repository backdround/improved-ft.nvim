local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("multiline-hop", function()
  before_each(h.get_preset([[
    a = <pattern> words here
    |
    b = <pattern> words
  ]], { 2, 0 }))

  local pattern = "\\M<pattern>"

  describe("normal-mode", function()
    it("pre-forward", function()
      h.hop("forward", "pre", pattern)
      assert.cursor_at(3, 3)
    end)

    it("start-forward", function()
      h.hop("forward", "start", pattern)
      assert.cursor_at(3, 4)
    end)

    it("end-forward", function()
      h.hop("forward", "end", pattern)
      assert.cursor_at(3, 12)
    end)

    it("post-forward", function()
      h.hop("forward", "post", pattern)
      assert.cursor_at(3, 13)
    end)

    it("pre-backward", function()
      h.hop("backward", "pre", pattern)
      assert.cursor_at(1, 13)
    end)

    it("end-backward", function()
      h.hop("backward", "end", pattern)
      assert.cursor_at(1, 12)
    end)

    it("start-backward", function()
      h.hop("backward", "start", pattern)
      assert.cursor_at(1, 4)
    end)

    it("post-backward", function()
      h.hop("backward", "post", pattern)
      assert.cursor_at(1, 3)
    end)
  end)

  describe("visual-mode", function()
    before_each(h.trigger_visual)

    it("pre-forward", function()
      h.hop("forward", "pre", pattern)
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 3 })
    end)

    it("start-forward", function()
      h.hop("forward", "start", pattern)
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 4 })
    end)

    it("end-forward", function()
      h.hop("forward", "end", pattern)
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 12 })
    end)

    it("post-forward", function()
      h.hop("forward", "post", pattern)
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 13 })
    end)

    it("pre-backward", function()
      h.hop("backward", "pre", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 13 }, { 2, 0 })
    end)

    it("end-backward", function()
      h.hop("backward", "end", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 12 }, { 2, 0 })
    end)

    it("start-backward", function()
      h.hop("backward", "start", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 4 }, { 2, 0 })
    end)

    it("post-backward", function()
      h.hop("backward", "post", pattern)
      h.reset_mode()
      assert.last_selected_region({ 1, 3 }, { 2, 0 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(h.trigger_delete)

    it("pre-forward", function()
      h.hop("forward", "pre", pattern)
      assert.buffer([[
        a = <pattern> words here
        <pattern> words
      ]])
    end)

    it("start-forward", function()
      h.hop("forward", "start", pattern)
      assert.buffer([[
        a = <pattern> words here
        pattern> words
      ]])
    end)

    it("end-forward", function()
      h.hop("forward", "end", pattern)
      assert.buffer([[
        a = <pattern> words here
         words
      ]])
    end)

    it("post-forward", function()
      h.hop("forward", "post", pattern)
      assert.buffer([[
        a = <pattern> words here
        words
      ]])
    end)

    it("pre-backward", function()
      h.hop("backward", "pre", pattern)
      assert.buffer([[
        a = <pattern>|
        b = <pattern> words
      ]])
    end)

    it("end-backward", function()
      h.hop("backward", "end", pattern)
      assert.buffer([[
        a = <pattern|
        b = <pattern> words
      ]])
    end)

    it("start-backward", function()
      h.hop("backward", "start", pattern)
      assert.buffer([[
        a = |
        b = <pattern> words
      ]])
    end)

    it("post-backward", function()
      h.hop("backward", "post", pattern)
      assert.buffer([[
        a =|
        b = <pattern> words
      ]])
    end)
  end)
end)
