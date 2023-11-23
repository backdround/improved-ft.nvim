local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("oneline-jump", function()
  before_each(h.get_preset([[
    a = some | words here
  ]], { 1, 9 }))

  describe("normal-mode", function()
    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "h")
      assert.cursor_at(1, 17)
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "h")
      assert.cursor_at(1, 16)
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "=")
      assert.cursor_at(1, 2)
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "=")
      assert.cursor_at(1, 3)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "h<esc>")
      assert.last_selected_region({ 1, 9 }, { 1, 17 })
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "h<esc>")
      assert.last_selected_region({ 1, 9 }, { 1, 16 })
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "=<esc>")
      assert.last_selected_region({ 1, 2 }, { 1, 9 })
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "=<esc>")
      assert.last_selected_region({ 1, 3 }, { 1, 9 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "h")
      assert.buffer("a = some ere")
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "h")
      assert.buffer("a = some here")
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "=")
      assert.buffer("a | words here")
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "=")
      assert.buffer("a =| words here")
    end)
  end)
end)
