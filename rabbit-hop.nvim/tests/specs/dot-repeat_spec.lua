local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("dot `.` repeat", function()
  before_each(h.get_preset("<a> <a> <a> <a> <a> <a>", { 1, 0 }))
  local pattern = "\\M<a>"

  it("should work", function()
    vim.api.nvim_feedkeys("d", "n", false)
    h.hop("forward", "pre", pattern)
    assert.buffer("<a> <a> <a> <a> <a>")

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer("<a> <a> <a> <a>")
  end)

  it("should respect old v:count", function()
    vim.api.nvim_feedkeys("2d", "n", false)
    h.hop("forward", "pre", pattern)
    assert.buffer("<a> <a> <a> <a>")

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer("<a> <a>")
  end)

  it("should choose new v:count over old v:count", function()
    vim.api.nvim_feedkeys("2d", "n", false)
    h.hop("forward", "pre", pattern)
    assert.buffer("<a> <a> <a> <a>")

    vim.api.nvim_feedkeys("3.", "nx", false)
    assert.buffer("<a>")
  end)

  it("should use last operator-pending v:count hop", function()
    vim.api.nvim_feedkeys("2d", "n", false)
    h.hop("forward", "pre", pattern)
    assert.buffer("<a> <a> <a> <a>")
    h.set_cursor(1, 0)

    vim.api.nvim_feedkeys("3", "n", false)
    h.hop("forward", "pre", pattern)
    h.set_cursor(1, 0)

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer("<a> <a>")
  end)
end)
