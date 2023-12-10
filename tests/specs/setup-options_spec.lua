local h = require("tests.helpers")
local ft = require("improved-ft")

require("tests.custom-asserts").register()

describe("setup-options", function()
  before_each(h.get_preset([[
    A a a
    b
    c c C
  ]], { 2, 0 }))

  describe("use_default_mappings == true", function()
    before_each(function()
      h.remove_all_mappings()
      ft.setup({ use_default_mappings = true })
    end)

    it("should map 'f' as a forward hop to a char", function()
      vim.api.nvim_feedkeys("fc", "x", false)
      assert.cursor_at(3, 0)
    end)

    it("should map 'F' as a backward hop to a char", function()
      vim.api.nvim_feedkeys("Fa", "x", false)
      assert.cursor_at(1, 4)
    end)

    it("should map 't' as a forward hop to a pre char", function()
      vim.api.nvim_feedkeys("tc", "x", false)
      assert.cursor_at(3, 1)
    end)

    it("should map 'T' as a backward hop to a pre char", function()
      vim.api.nvim_feedkeys("Ta", "x", false)
      assert.cursor_at(1, 3)
    end)

    it("should map ';' as a forward repeat hop", function()
      vim.api.nvim_feedkeys("fc;", "x", false)
      assert.cursor_at(3, 2)
    end)

    it("should map ',' as a backward repeat hop", function()
      vim.api.nvim_feedkeys("Fa,", "x", false)
      assert.cursor_at(1, 2)
    end)
  end)

  it("use_default_mappings == false shouldn't map anything", function()
    h.remove_all_mappings()
    ft.setup({ use_default_mappings = false })

    local keymaps = vim.api.nvim_get_keymap("")
    assert.are.equals(0, #keymaps)
  end)

  describe("ignore_char_case", function()
    it("if true then it should ignore search char case", function()
      ft.setup({ ignore_char_case = true })
      h.hop_with_character(ft.hop_forward_to_char, "C")
      assert.cursor_at(3, 0)
    end)

    it("if false then it shouldn't ignore user's char case", function()
      ft.setup({ ignore_char_case = false })
      h.hop_with_character(ft.hop_forward_to_char, "C")
      assert.cursor_at(3, 4)
    end)
  end)

  describe("use_relative_repetition == true should respect a last hop direction.", function()
    before_each(function()
      h.get_preset([[
        a a a a a a a
      ]], { 1, 6 })()
      ft.setup({ use_relative_repetition = true })
    end)

    after_each(function()
      ft.setup({ use_relative_repetition = false })
    end)

    describe("repeat_forward", function()
      it("should hop forward after forward hop", function()
        h.hop_with_character(ft.hop_forward_to_char, "a")
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 10)
      end)

      it("should hop backward after backward hop", function()
        h.hop_with_character(ft.hop_backward_to_char, "a")
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 2)
      end)
    end)

    describe("repeat_backward", function()
      it("should hop backward after forward hop", function()
        h.hop_with_character(ft.hop_forward_to_char, "a")
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 6)
      end)

      it("should hop forward after backward hop", function()
        h.hop_with_character(ft.hop_backward_to_char, "a")
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 6)
      end)
    end)
  end)
end)
