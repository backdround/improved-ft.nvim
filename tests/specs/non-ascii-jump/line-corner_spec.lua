local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("non-ascii-line-corner-jump", function()
  before_each(h.get_preset([[
    несколько штук тут
    слова | и слова
    несколько штук там
  ]], { 2, 6 }))

  describe("normal-mode", function()
    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "н")
      assert.cursor_at(3, 0)
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "н")
      assert.cursor_at(2, 14)
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "т")
      assert.cursor_at(1, 17)
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "т")
      assert.cursor_at(2, 0)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "н<esc>")
      assert.last_selected_region({ 2, 6 }, { 3, 0 })
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "н<esc>")
      assert.last_selected_region({ 2, 6 }, { 2, 15 })
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "т<esc>")
      assert.last_selected_region({1, 17}, { 2, 6 })
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "т<esc>")
      assert.last_selected_region({1, 18}, { 2, 6 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.perform_through_keymap(ft.to_char_forward, "н")
      assert.buffer([[
        несколько штук тут
        слова есколько штук там
      ]])
    end)

    it("pre-forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "н")
      assert.buffer([[
        несколько штук тут
        слова несколько штук там
      ]])
    end)

    it("backward", function()
      h.perform_through_keymap(ft.to_char_backward, "т")
      assert.buffer([[
        несколько штук ту| и слова
        несколько штук там
      ]])
    end)

    it("pre-backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "т")
      assert.buffer([[
        несколько штук тут| и слова
        несколько штук там
      ]])
    end)
  end)
end)
