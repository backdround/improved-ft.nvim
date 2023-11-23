local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("non-ascii-oneline-jump", function()
  before_each(h.get_preset([[
    a = несколько | слов тут
  ]], { 1, 14 }))

  describe("normal-mode", function()
    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "т")
      assert.cursor_at(1, 21)
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "т")
      assert.cursor_at(1, 20)
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "ь")
      assert.cursor_at(1, 10)
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "ь")
      assert.cursor_at(1, 11)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "т<esc>")
      assert.last_selected_region({ 1, 14 }, { 1, 21 })
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "т<esc>")
      assert.last_selected_region({ 1, 14 }, { 1, 20 })
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "ь<esc>")
      assert.last_selected_region({ 1, 10 }, { 1, 14 })
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "ь<esc>")
      assert.last_selected_region({ 1, 11 }, { 1, 14 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "т")
      assert.buffer("a = несколько ут")
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "т")
      assert.buffer("a = несколько тут")
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "ь")
      assert.buffer("a = нескол| слов тут")
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "ь")
      assert.buffer("a = несколь| слов тут")
    end)
  end)
end)
