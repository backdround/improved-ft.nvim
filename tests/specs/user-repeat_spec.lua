local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("user-repeat", function()
  before_each(h.get_preset([[
    a = a word a word and other words
    b = | words
    c = a word a word and other words
  ]], { 2, 4 }))

  describe("forward", function()
    it("should work after forward jump", function()
      h.jump("forward", "none", "w", { save_for_repetition = true })
      assert.cursor_at(2, 6)
      h.repeat_jump("forward")
      assert.cursor_at(3, 6)
    end)

    it("should work after pre forward jump", function()
      h.jump("forward", "pre", "w", { save_for_repetition = true })
      assert.cursor_at(2, 5)
      h.repeat_jump("forward")
      assert.cursor_at(3, 5)
    end)

    it("should work after backward jump", function()
      h.jump("backward", "none", "w", { save_for_repetition = true })
      assert.cursor_at(1, 28)
      h.repeat_jump("forward")
      assert.cursor_at(2, 6)
    end)

    it("should work after pre backward jump", function()
      h.jump("backward", "pre", "w", { save_for_repetition = true })
      assert.cursor_at(1, 29)
      h.repeat_jump("forward")
      assert.cursor_at(2, 5)
    end)
  end)

  describe("backward", function()
    it("should work after forward jump", function()
      h.jump("forward", "none", "w", { save_for_repetition = true })
      assert.cursor_at(2, 6)
      h.repeat_jump("backward")
      assert.cursor_at(1, 28)
    end)

    it("should work after pre forward jump", function()
      h.jump("forward", "pre", "w", { save_for_repetition = true })
      assert.cursor_at(2, 5)
      h.repeat_jump("backward")
      assert.cursor_at(1, 29)
    end)

    it("should work after backward jump", function()
      h.jump("backward", "none", "w", { save_for_repetition = true })
      assert.cursor_at(1, 28)
      h.repeat_jump("backward")
      assert.cursor_at(1, 13)
    end)

    it("should work after pre backward jump", function()
      h.jump("backward", "pre", "w", { save_for_repetition = true })
      assert.cursor_at(1, 29)
      h.repeat_jump("backward")
      assert.cursor_at(1, 14)
    end)
  end)

  it("shouldn't respect previous v:count", function()
    vim.api.nvim_feedkeys("2", "n", false)
    h.jump("forward", "none", "w", { save_for_repetition = true })
    assert.cursor_at(3, 6)

    h.repeat_jump("forward")
    assert.cursor_at(3, 13)
  end)

  it("should respect new v:count", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.jump("forward", "none", "w", { save_for_repetition = true })
    assert.cursor_at(3, 13)

    vim.api.nvim_feedkeys("2", "n", false)
    h.repeat_jump("backward")
    assert.cursor_at(2, 6)
  end)

  it("should do nothing if it's called before anything", function()
    assert.cursor_at(2, 4)
    h.reload_ft()
    h.repeat_jump("forward")
    assert.cursor_at(2, 4)
  end)
end)
