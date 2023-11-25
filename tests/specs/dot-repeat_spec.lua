local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("dot `.` repeat", function()
  before_each(h.get_preset([[
    a = | word a word and other words
    b = some words
    c = a word a word and other words
  ]], { 1, 4 }))

  it("should work", function()
    vim.api.nvim_feedkeys("d", "n", false)
    h.jump("forward", "none", "w")
    assert.buffer([[
      a = ord a word and other words
      b = some words
      c = a word a word and other words
    ]])

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer([[
      a = ord and other words
      b = some words
      c = a word a word and other words
    ]])
  end)

  it("should respect old v:count", function()
    vim.api.nvim_feedkeys("2d", "n", false)
    h.jump("forward", "none", "w")
    assert.buffer([[
      a = ord and other words
      b = some words
      c = a word a word and other words
    ]])

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer([[
      a = ords
      c = a word a word and other words
    ]])
  end)

  it("should choose new v:count over old v:count", function()
    vim.api.nvim_feedkeys("2d", "n", false)
    h.jump("forward", "none", "w")
    assert.buffer([[
    a = ord and other words
    b = some words
    c = a word a word and other words
    ]])

    vim.api.nvim_feedkeys("3.", "nx", false)
    assert.buffer([[
    a = ord a word and other words
    ]])
  end)

  it("should work after user-repeat", function()
    h.jump("forward", "none", "w")

    vim.api.nvim_feedkeys("d", "n", false)
    h.repeat_jump("forward")
    assert.buffer([[
      a = | ord and other words
      b = some words
      c = a word a word and other words
    ]])

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer([[
      a = | ords
      b = some words
      c = a word a word and other words
    ]])
  end)

  it("should work after user-repeat with v:count", function()
    h.jump("forward", "none", "w")

    vim.api.nvim_feedkeys("2d", "n", false)
    h.repeat_jump("forward")
    assert.buffer([[
      a = | ords
      b = some words
      c = a word a word and other words
    ]])

    vim.api.nvim_feedkeys(".", "nx", false)
    assert.buffer([[
      a = | ord a word and other words
    ]])
  end)
end)
