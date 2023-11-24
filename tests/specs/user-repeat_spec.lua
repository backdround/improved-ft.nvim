local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("user-repeat", function()
  before_each(h.get_preset([[
    a = a word a word and other words
    b = | words
    c = a word a word and other words
  ]], { 2, 4 }))

  describe("forward", function()
    it("after to_char_forward", function()
      h.perform_through_keymap(ft.to_char_forward, "w")
      assert.cursor_at(2, 6)
      h.perform_through_keymap(ft.repeat_forward)
      assert.cursor_at(3, 6)
    end)

    it("after to_pre_char_forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "w")
      assert.cursor_at(2, 5)
      h.perform_through_keymap(ft.repeat_forward)
      assert.cursor_at(3, 5)
    end)

    it("after to_char_backward", function()
      h.perform_through_keymap(ft.to_char_backward, "w")
      assert.cursor_at(1, 28)
      h.perform_through_keymap(ft.repeat_forward)
      assert.cursor_at(2, 6)
    end)

    it("after to_pre_char_backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "w")
      assert.cursor_at(1, 29)
      h.perform_through_keymap(ft.repeat_forward)
      assert.cursor_at(2, 5)
    end)
  end)

  describe("backward", function()
    it("after to_char_forward", function()
      h.perform_through_keymap(ft.to_char_forward, "w")
      assert.cursor_at(2, 6)
      h.perform_through_keymap(ft.repeat_backward)
      assert.cursor_at(1, 28)
    end)

    it("after to_pre_char_forward", function()
      h.perform_through_keymap(ft.to_pre_char_forward, "w")
      assert.cursor_at(2, 5)
      h.perform_through_keymap(ft.repeat_backward)
      assert.cursor_at(1, 29)
    end)

    it("after to_char_backward", function()
      h.perform_through_keymap(ft.to_char_backward, "w")
      assert.cursor_at(1, 28)
      h.perform_through_keymap(ft.repeat_backward)
      assert.cursor_at(1, 13)
    end)

    it("after to_pre_char_backward", function()
      h.perform_through_keymap(ft.to_pre_char_backward, "w")
      assert.cursor_at(1, 29)
      h.perform_through_keymap(ft.repeat_backward)
      assert.cursor_at(1, 14)
    end)
  end)

  it("shouldn't respect previous v:count", function()
    vim.api.nvim_feedkeys("2", "n", false)
    h.perform_through_keymap(ft.to_char_forward, "w")
    assert.cursor_at(3, 6)

    h.perform_through_keymap(ft.repeat_forward)
    assert.cursor_at(3, 13)
  end)

  it("should respect new v:count", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.perform_through_keymap(ft.to_char_forward, "w")
    assert.cursor_at(3, 13)

    vim.api.nvim_feedkeys("2", "n", false)
    h.perform_through_keymap(ft.repeat_backward)
    assert.cursor_at(2, 6)
  end)

  it("should do nothing if it's called before anything", function()
    package.loaded["improved-ft"] = nil
    ft = require("improved-ft")
    assert.cursor_at(2, 4)
    h.perform_through_keymap(ft.repeat_forward)
    assert.cursor_at(2, 4)
  end)
end)
