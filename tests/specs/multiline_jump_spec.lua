local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

local function get_preset(buffer_text, cursor_position)
  return function()
    h.reset_mode()
    h.reset_last_selected_region()

    h.set_current_buffer(buffer_text)
    h.set_cursor(unpack(cursor_position))
  end
end

describe("multiline-jump", function()
  before_each(get_preset([[
    a = some words here
    |
    b = other words
  ]], { 2, 0 }))

  describe("normal-mode", function()
    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "=")
      assert.cursor_at(3, 2)
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "=")
      assert.cursor_at(3, 1)
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
      h.perform_through_keymap(ft.to_char_forward, "=<esc>")
      assert.last_selected_region({ 2, 0 }, { 3, 2 })
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "=<esc>")
      assert.last_selected_region({ 2, 0 }, { 3, 1 })
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "=<esc>")
      assert.last_selected_region({ 1, 2 }, { 2, 0 })
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "=<esc>")
      assert.last_selected_region({ 1, 3 }, { 2, 0 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "=")
      assert.buffer([[
        a = some words here
         other words
      ]])
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "=")
      assert.buffer([[
        a = some words here
        = other words
      ]])
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "=")
      assert.buffer([[
        a |
        b = other words
      ]])
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "=")
      assert.buffer([[
        a =|
        b = other words
      ]])
    end)
  end)
end)
