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

    it("should map 'f' as a forward jump to a char", function()
      vim.api.nvim_feedkeys("fc", "x", false)
      assert.cursor_at(3, 0)
    end)

    it("should map 'F' as a backward jump to a char", function()
      vim.api.nvim_feedkeys("Fa", "x", false)
      assert.cursor_at(1, 4)
    end)

    it("should map 't' as a forward jump to a pre char", function()
      vim.api.nvim_feedkeys("tc", "x", false)
      assert.cursor_at(3, 1)
    end)

    it("should map 'T' as a backward jump to a pre char", function()
      vim.api.nvim_feedkeys("Ta", "x", false)
      assert.cursor_at(1, 3)
    end)

    it("should map ';' as a forward repeat jump", function()
      vim.api.nvim_feedkeys("fc;", "x", false)
      assert.cursor_at(3, 2)
    end)

    it("should map ',' as a backward repeat jump", function()
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

  describe("ignore_user_char_case", function()
    it("if true then it should ignore user's char case", function()
      ft.setup({ ignore_user_char_case = true })
      h.perform_through_keymap(ft.jump, false)
      vim.api.nvim_feedkeys("C", "x", false)
      assert.cursor_at(3, 0)
    end)

    it("if false then it shouldn't ignore user's char case", function()
      ft.setup({ ignore_user_char_case = false })
      h.perform_through_keymap(ft.jump, false)
      vim.api.nvim_feedkeys("C", "x", false)
      assert.cursor_at(3, 4)
    end)
  end)
end)
