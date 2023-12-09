local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("hop", function()
  before_each(h.get_preset([[
    a = some words here
    |
    b = other words
  ]], { 2, 0 }))

  describe("normal-mode", function()
    it("forward", function()
      h.hop_with_character(ft.hop_forward_to_char, "=")
      assert.cursor_at(3, 2)
    end)

    it("pre-forward", function()
      h.hop_with_character(ft.hop_forward_pre_char, "=")
      assert.cursor_at(3, 1)
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_post_char, "=")
      assert.cursor_at(3, 3)
    end)

    it("backward", function()
      h.hop_with_character(ft.hop_backward_to_char, "=")
      assert.cursor_at(1, 2)
    end)

    it("pre-backward", function()
      h.hop_with_character(ft.hop_backward_pre_char, "=")
      assert.cursor_at(1, 3)
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_post_char, "=")
      assert.cursor_at(1, 1)
    end)
  end)

  describe("visual-mode", function()
    before_each(h.trigger_visual)

    it("forward", function()
      h.hop_with_character(ft.hop_forward_to_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 2 })
    end)

    it("pre-forward", function()
      h.hop_with_character(ft.hop_forward_pre_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 1 })
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_post_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 3 })
    end)

    it("backward", function()
      h.hop_with_character(ft.hop_backward_to_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 2 }, { 2, 0 })
    end)

    it("pre-backward", function()
      h.hop_with_character(ft.hop_backward_pre_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 3 }, { 2, 0 })
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_post_char, "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 1 }, { 2, 0 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(h.trigger_delete)

    it("forward", function()
      h.hop_with_character(ft.hop_forward_to_char, "=")
      assert.buffer([[
        a = some words here
         other words
      ]])
    end)

    it("pre-forward", function()
      h.hop_with_character(ft.hop_forward_pre_char, "=")
      assert.buffer([[
        a = some words here
        = other words
      ]])
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_post_char, "=")
      assert.buffer([[
        a = some words here
        other words
      ]])
    end)

    it("backward", function()
      h.hop_with_character(ft.hop_backward_to_char, "=")
      assert.buffer([[
        a |
        b = other words
      ]])
    end)

    it("pre-backward", function()
      h.hop_with_character(ft.hop_backward_pre_char, "=")
      assert.buffer([[
        a =|
        b = other words
      ]])
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_post_char, "=")
      assert.buffer([[
        a|
        b = other words
      ]])
    end)
  end)
end)
