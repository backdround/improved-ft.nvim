local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("hop", function()
  before_each(h.get_preset([[
    a = some words here
    |
    b = other words
  ]], { 2, 1 }))

  describe("normal-mode", function()
    it("forward", function()
      h.hop_with_character(ft.hop_forward_to_char, "=")
      assert.cursor_at(3, 3)
    end)

    it("pre-forward", function()
      h.hop_with_character(ft.hop_forward_to_pre_char, "=")
      assert.cursor_at(3, 2)
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_to_post_char, "=")
      assert.cursor_at(3, 4)
    end)

    it("backward", function()
      h.hop_with_character(ft.hop_backward_to_char, "=")
      assert.cursor_at(1, 3)
    end)

    it("pre-backward", function()
      h.hop_with_character(ft.hop_backward_to_pre_char, "=")
      assert.cursor_at(1, 4)
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_to_post_char, "=")
      assert.cursor_at(1, 2)
    end)
  end)

  describe("visual-mode", function()

    it("forward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_forward_to_char, "=")
      assert.selected_region({ 2, 1 }, { 3, 3 })
    end)

    it("pre-forward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_forward_to_pre_char, "=")
      assert.selected_region({ 2, 1 }, { 3, 2 })
    end)

    it("post-forward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_forward_to_post_char, "=")
      assert.selected_region({ 2, 1 }, { 3, 4 })
    end)

    it("backward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_backward_to_char, "=")
      assert.selected_region({ 1, 3 }, { 2, 1 })
    end)

    it("pre-backward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_backward_to_pre_char, "=")
      assert.selected_region({ 1, 4 }, { 2, 1 })
    end)

    it("post-backward", function()
      h.trigger_visual()

      h.hop_with_character(ft.hop_backward_to_post_char, "=")
      assert.selected_region({ 1, 2 }, { 2, 1 })
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
      h.hop_with_character(ft.hop_forward_to_pre_char, "=")
      assert.buffer([[
        a = some words here
        = other words
      ]])
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_to_post_char, "=")
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
      h.hop_with_character(ft.hop_backward_to_pre_char, "=")
      assert.buffer([[
        a =|
        b = other words
      ]])
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_to_post_char, "=")
      assert.buffer([[
        a|
        b = other words
      ]])
    end)
  end)

  describe("insert-mode", function()
    before_each(function()
      h.feedkeys("i", false)
    end)

    it("forward", function()
      h.hop_with_character(ft.hop_forward_to_char, "=")
      assert.cursor_at(3, 2)
    end)

    it("pre-forward", function()
      h.hop_with_character(ft.hop_forward_to_pre_char, "=")
      assert.cursor_at(3, 1)
    end)

    it("post-forward", function()
      h.hop_with_character(ft.hop_forward_to_post_char, "=")
      assert.cursor_at(3, 3)
    end)

    it("backward", function()
      h.hop_with_character(ft.hop_backward_to_char, "=")
      assert.cursor_at(1, 3)
    end)

    it("pre-backward", function()
      h.hop_with_character(ft.hop_backward_to_pre_char, "=")
      assert.cursor_at(1, 4)
    end)

    it("post-backward", function()
      h.hop_with_character(ft.hop_backward_to_post_char, "=")
      assert.cursor_at(1, 2)
    end)
  end)

  it("multi-byte text", function()
    h.get_preset("некоторый Текст", { 1, 1 })()

    h.hop_with_character(ft.hop_forward_to_char, "Т")
    assert.cursor_at(1, 11)
  end)

  it("multi-column text", function()
    local double_tab = "		"
    local buffer = "text" .. double_tab .. "here"
    h.get_preset(buffer, { 1, 1 })()

    h.hop_with_character(ft.hop_forward_to_char, "h")
    assert.cursor_at(1, 7)
  end)
end)
