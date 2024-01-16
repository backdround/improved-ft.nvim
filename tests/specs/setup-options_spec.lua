local h = require("tests.helpers")
local ft = require("improved-ft")

require("tests.custom-asserts").register()

describe("setup-options", function()
  before_each(h.get_preset([[
    A a a
    b
    c c C
  ]], { 2, 1 }))

  describe("use_default_mappings == true", function()
    before_each(function()
      h.remove_all_mappings()
      ft.setup({ use_default_mappings = true })
    end)

    it("should map 'f' as a forward hop to a char", function()
      vim.api.nvim_feedkeys("fc", "x", false)
      assert.cursor_at(3, 1)
    end)

    it("should map 'F' as a backward hop to a char", function()
      vim.api.nvim_feedkeys("Fa", "x", false)
      assert.cursor_at(1, 5)
    end)

    it("should map 't' as a forward hop to a pre char", function()
      vim.api.nvim_feedkeys("tc", "x", false)
      assert.cursor_at(3, 2)
    end)

    it("should map 'T' as a backward hop to a pre char", function()
      vim.api.nvim_feedkeys("Ta", "x", false)
      assert.cursor_at(1, 4)
    end)

    it("should map ';' as a forward repeat hop", function()
      vim.api.nvim_feedkeys("fc;", "x", false)
      assert.cursor_at(3, 3)
    end)

    it("should map ',' as a backward repeat hop", function()
      vim.api.nvim_feedkeys("Fa,", "x", false)
      assert.cursor_at(1, 3)
    end)
  end)

  it("use_default_mappings == false shouldn't map anything", function()
    h.remove_all_mappings()
    ft.setup({ use_default_mappings = false })

    local keymaps = vim.api.nvim_get_keymap("")
    local count_of_maps = 0
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs:find("<Plug>") == nil then
        count_of_maps = count_of_maps + 1
      end
    end
    assert.are.equals(0, count_of_maps)
  end)

  describe("ignore_char_case", function()
    it("if true then it should ignore search char case", function()
      ft.setup({ ignore_char_case = true })
      h.hop_with_character(ft.hop_forward_to_char, "C")
      assert.cursor_at(3, 1)
    end)

    it("if false then it shouldn't ignore user's char case", function()
      ft.setup({ ignore_char_case = false })
      h.hop_with_character(ft.hop_forward_to_char, "C")
      assert.cursor_at(3, 5)
    end)
  end)

  describe("use_relative_repetition == true should respect a last hop direction.", function()
    before_each(function()
      h.get_preset([[
        a a a a a a a
      ]], { 1, 7 })()
      ft.setup({ use_relative_repetition = true })
    end)

    after_each(function()
      ft.setup({ use_relative_repetition = false })
    end)

    describe("repeat_forward", function()
      it("should hop forward after forward hop", function()
        h.hop_with_character(ft.hop_forward_to_char, "a")
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 11)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 13)
      end)

      it("should hop backward after backward hop", function()
        h.hop_with_character(ft.hop_backward_to_char, "a")
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 3)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 1)
      end)
    end)

    describe("repeat_backward", function()
      it("should hop backward after forward hop", function()
        h.hop_with_character(ft.hop_forward_to_char, "a")
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 7)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 5)
      end)

      it("should hop forward after backward hop", function()
        h.hop_with_character(ft.hop_backward_to_char, "a")
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 7)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 9)
      end)
    end)
  end)

  local description =
    "use_relative_repetition_offsets == true should adjust offset according to the direction"
  describe(description, function()
    before_each(function()
      h.get_preset([[
        a = a word a word and other words
        b = | words
        c = a word a word and other words
      ]], { 2, 5 })()
      ft.setup({ use_relative_repetition_offsets = true })
    end)

    after_each(function()
      ft.setup({ use_relative_repetition_offsets = false })
    end)

    describe("repeat_forward", function()
      it("with pre offset", function()
        h.hop_with_character(ft.hop_backward_to_pre_char, "w")
        assert.cursor_at(1, 30)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(2, 6)

        h.hop_with_character(ft.hop_forward_to_pre_char, "a")
        assert.cursor_at(3, 4)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(3, 11)
      end)

      it("with post offset", function()
        h.hop_with_character(ft.hop_backward_to_post_char, "w")
        assert.cursor_at(1, 28)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(1, 30)

        h.hop_with_character(ft.hop_forward_to_post_char, "a")
        assert.cursor_at(3, 6)
        h.perform_through_keymap(ft.repeat_forward, true)
        assert.cursor_at(3, 13)
      end)
    end)

    describe("repeat_backward", function()
      it("with pre offset", function()
        h.hop_with_character(ft.hop_forward_to_pre_char, "w")
        assert.cursor_at(2, 6)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 30)

        h.hop_with_character(ft.hop_backward_to_pre_char, "a")
        assert.cursor_at(1, 20)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 13)
      end)

      it("with post offset", function()
        h.hop_with_character(ft.hop_forward_to_post_char, "w")
        assert.cursor_at(2, 8)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(2, 6)

        h.hop_with_character(ft.hop_backward_to_post_char, "a")
        assert.cursor_at(1, 18)
        h.perform_through_keymap(ft.repeat_backward, true)
        assert.cursor_at(1, 11)
      end)
    end)
  end)
end)
