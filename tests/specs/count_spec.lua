local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("v:count", function()
  before_each(h.get_preset([[
    a a a a a a
  ]], { 1, 0 }))

  it("should be respected during jump", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.jump("forward", "none", "a")
    assert.cursor_at(1, 6)
  end)

  it("should be respected during repeat", function()
    h.jump("forward", "none", "a")
    vim.api.nvim_feedkeys("3", "n", false)
    h.repeat_jump("forward")
    assert.cursor_at(1, 8)
  end)

  it(
    "should be taken as a maximal possible count if v:count is too big",
    function()
      vim.api.nvim_feedkeys("22", "n", false)
      h.jump("forward", "none", "a")
      assert.cursor_at(1, 10)
    end
  )
end)
