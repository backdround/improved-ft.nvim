local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("oneline-jump", function()
  before_each(h.get_preset([[
    a = some | words here
  ]], { 1, 9 }))

  describe("normal-mode", function()
    it("forward", function()
      h.jump("forward", "none", "h")
      assert.cursor_at(1, 17)
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "h")
      assert.cursor_at(1, 16)
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      assert.cursor_at(1, 2)
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      assert.cursor_at(1, 3)
    end)
  end)

  describe("visual-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("v", "n", false)
    end)

    it("forward", function()
      h.jump("forward", "none", "h")
      h.reset_mode()
      assert.last_selected_region({ 1, 9 }, { 1, 17 })
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "h")
      h.reset_mode()
      assert.last_selected_region({ 1, 9 }, { 1, 16 })
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 2 }, { 1, 9 })
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      h.reset_mode()
      assert.last_selected_region({ 1, 3 }, { 1, 9 })
    end)
  end)

  describe("operator-pending-mode", function()
    before_each(function()
      vim.api.nvim_feedkeys("d", "n", false)
    end)

    it("forward", function()
      h.jump("forward", "none", "h")
      assert.buffer("a = some ere")
    end)

    it("pre-forward", function()
      h.jump("forward", "pre", "h")
      assert.buffer("a = some here")
    end)

    it("backward", function()
      h.jump("backward", "none", "=")
      assert.buffer("a | words here")
    end)

    it("pre-backward", function()
      h.jump("backward", "pre", "=")
      assert.buffer("a =| words here")
    end)
  end)
end)
