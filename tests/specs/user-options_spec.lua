local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("user-options", function()
  before_each(h.get_preset([[
    a b a b a b a b
  ]], { 1, 0 }))

  it("can be empty", function()
    h.perform_through_keymap(ft.jump, false)
    vim.api.nvim_feedkeys("a", "x", false)
    assert.cursor_at(1, 4)
  end)

  it("'direction' should be 'forward' by default", function()
    h.perform_through_keymap(ft.jump, true, {
      direction = nil,
      offset = "none",
      pattern = "a"
    })
    assert.cursor_at(1, 4)
  end)

  it("'offset' should be 'none' by default", function()
    h.perform_through_keymap(ft.jump, true, {
      direction = "forward",
      offset = nil,
      pattern = "a"
    })
    assert.cursor_at(1, 4)
  end)

  it(
    "'pattern' should be taken interactively from a user if isn't set",
    function()
      h.perform_through_keymap(ft.jump, false, {
        direction = "forward",
        offset = "none",
        pattern = nil,
      })
      vim.api.nvim_feedkeys("a", "x", false)
      assert.cursor_at(1, 4)
    end
  )

  describe("'save_for_repetition'", function()
    it("should change repetition behaviour", function()
      h.perform_through_keymap(ft.jump, true, {
        pattern = "b",
        save_for_repetition = true,
      })
      assert.cursor_at(1, 2)

      h.perform_through_keymap(ft.jump, true, {
        pattern = "a",
        save_for_repetition = false,
      })
      assert.cursor_at(1, 4)

      h.repeat_jump("forward")
      assert.cursor_at(1, 6)
    end)

    it("should be 'false' by default if a pattern given in options", function()
      package.loaded["improved-ft"] = nil
      ft = require("improved-ft")

      h.perform_through_keymap(ft.jump, true, {
        pattern = "a"
      })
      assert.cursor_at(1, 4)

      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(1, 4)
    end)

    it("should be 'true' by default if a pattern taken interactively", function()
      ft._reset_state()

      h.perform_through_keymap(ft.jump, false, {})
      vim.api.nvim_feedkeys("a", "x", false)
      assert.cursor_at(1, 4)

      h.perform_through_keymap(ft.repeat_forward, true)
      assert.cursor_at(1, 8)
    end)
  end)
end)
