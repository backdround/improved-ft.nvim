local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("non-ascii-multiline-jump", function()
  before_each(h.get_preset([[
    несколько штук тут
    |
    несколько штук там
  ]], { 2, 0 }))

  describe("normal-mode", function()
    it("forward", function()
      h.jump("forward", "none", "ш")
      assert.cursor_at(3, 10)
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "ш")
      assert.cursor_at(3, 9)
    end)

    it("backward", function()
      h.jump("backward", "none", "ш")
      assert.cursor_at(1, 10)
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "ш")
      assert.cursor_at(1, 11)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.jump("forward", "none", "ш")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 10 })
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "ш")
      h.reset_mode()
      assert.last_selected_region({ 2, 0 }, { 3, 9 })
    end)

    it("backward", function()
      h.jump("backward", "none", "ш")
      h.reset_mode()
      assert.last_selected_region({ 1, 10 }, { 2, 0 })
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "ш")
      h.reset_mode()
      assert.last_selected_region({ 1, 11 }, { 2, 0 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.jump("forward", "none", "ш")
      assert.buffer([[
        несколько штук тут
        тук там
      ]])
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "ш")
      assert.buffer([[
        несколько штук тут
        штук там
      ]])
    end)

    -- несеколько штук тут
    -- |
    -- другие штуки
    it("backward", function()
      h.jump("backward", "none", "ш")
      assert.buffer([[
        несколько |
        несколько штук там
      ]])
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "ш")
      assert.buffer([[
        несколько ш|
        несколько штук там
      ]])
    end)
  end)
end)
