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

describe("line-corner-jump", function()
  before_each(get_preset([[
    a = some words here
    b = | words
    c = other words
  ]], { 2, 4 }))

  describe("normal-mode", function()
    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "c")
      assert.cursor_at(3, 0)
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "c")
      assert.cursor_at(2, 10)
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "e")
      assert.cursor_at(1, 18)
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "e")
      assert.cursor_at(2, 0)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "c<esc>")
      assert.last_selected_region({ 2, 4 }, { 3, 0 })
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "c<esc>")
      assert.last_selected_region({ 2, 4 }, { 2, 11 })
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "e<esc>")
      assert.last_selected_region({1, 18}, { 2, 4 })
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "e<esc>")
      assert.last_selected_region({1, 19}, { 2, 4 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "c")
      assert.buffer([[
        a = some words here
        b =  = other words
      ]])
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "c")
      assert.buffer([[
        a = some words here
        b = c = other words
      ]])
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "e")
      assert.buffer([[
        a = some words her| words
        c = other words
      ]])
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "e")
      assert.buffer([[
        a = some words here| words
        c = other words
      ]])
    end)
  end)
end)
