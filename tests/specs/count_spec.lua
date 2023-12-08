local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("v:count", function()
  before_each(h.get_preset([[
    <a> <a> <a> <a> <a>
  ]], { 1, 0 }))
  local pattern = "\\M<a>"

  it("should be respected during hop", function()
    vim.api.nvim_feedkeys("3", "n", false)
    h.hop("forward", "start", pattern)
    assert.cursor_at(1, 12)
  end)

  it(
    "should be taken as a maximal possible count if v:count is too big",
    function()
      vim.api.nvim_feedkeys("22", "n", false)
      h.hop("forward", "start", pattern)
      assert.cursor_at(1, 16)
    end
  )
end)
