local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("repeat", function()
  before_each(h.get_preset([[
    a = a word a word and other words
    b = | words
    c = a word a word and other words
  ]], { 2, 4 }))

  describe("forward", function()
    it("should work after forward hop", function()
      h.hop_with_character(ft.hop_forward_to_char, "w")
      assert.cursor_at(2, 6)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(3, 6)
    end)

    it("should work after pre forward hop", function()
      h.hop_with_character(ft.hop_forward_pre_char, "w")
      assert.cursor_at(2, 5)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(3, 5)
    end)

    it("should work after backward hop", function()
      h.hop_with_character(ft.hop_backward_to_char, "w")
      assert.cursor_at(1, 28)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(2, 6)
    end)

    it("should work after pre backward hop", function()
      h.hop_with_character(ft.hop_backward_pre_char, "w")
      assert.cursor_at(1, 29)
      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(2, 5)
    end)
  end)

  describe("backward", function()
    it("should work after forward hop", function()
      h.hop_with_character(ft.hop_forward_to_char, "w")
      assert.cursor_at(2, 6)
      h.perform_through_keymap(ft.repeat_backward, true)
      assert.cursor_at(1, 28)
    end)

    it("should work after pre forward hop", function()
      h.hop_with_character(ft.hop_forward_pre_char, "w")
      assert.cursor_at(2, 5)
      h.perform_through_keymap(ft.repeat_backward, true)
      assert.cursor_at(1, 29)
    end)

    it("should work after backward hop", function()
      h.hop_with_character(ft.hop_backward_to_char, "w")
      assert.cursor_at(1, 28)
      h.perform_through_keymap(ft.repeat_backward, true)
      assert.cursor_at(1, 13)
    end)

    it("should work after pre backward hop", function()
      h.hop_with_character(ft.hop_backward_pre_char, "w")
      assert.cursor_at(1, 29)
      h.perform_through_keymap(ft.repeat_backward, true)
      assert.cursor_at(1, 14)
    end)
  end)

  it("shouldn't respect previous v:count", function()
    vim.api.nvim_feedkeys("2", "n", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.cursor_at(3, 6)

    h.perform_through_keymap(ft.repeat_forward, true)
    assert.cursor_at(3, 13)
  end)

  it("should respect current v:count", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.cursor_at(3, 13)

    vim.api.nvim_feedkeys("2", "n", false)
    h.perform_through_keymap(ft.repeat_backward, true)
    assert.cursor_at(2, 6)
  end)

  it("should do nothing if it's called before anything", function()
    ft._reset_state()
    h.perform_through_keymap(ft.repeat_forward, true)
    assert.cursor_at(2, 4)
  end)
end)
