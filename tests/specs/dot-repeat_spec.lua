local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("dot `.` repeat", function()
  before_each(h.get_preset("a | a w a w a w a w a w end", { 1, 3 }))

  it("should work", function()
    h.feedkeys("d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w a w end")

    h.feedkeys(".", true)
    assert.buffer("a  a w a w a w end")
  end)

  it("should preserve option after another hop", function()
    h.feedkeys("d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w a w end")

    h.hop_with_character(ft.hop_forward_to_char, "a")

    h.feedkeys(".", true)
    assert.buffer("a   a w a w a w end")
  end)

  it("should preserve option after user repeat", function()
    h.feedkeys("d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w a w end")

    h.perform_through_keymap(ft.repeat_forward, true)
    h.feedkeys(".", true)
    assert.buffer("a  a  a w a w end")
  end)

  it("should respect old v:count", function()
    h.feedkeys("2d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w end")

    h.feedkeys(".", true)
    assert.buffer("a  a w end")
  end)

  it("should choose new v:count over old v:count", function()
    h.feedkeys("2d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w end")

    h.feedkeys("3.", true)
    assert.buffer("a  end")
  end)

  it("should work with user-repeat with v:count", function()
    h.hop_with_character(ft.hop_forward_to_char, "w")

    h.feedkeys("2d", false)
    h.perform_through_keymap(ft.repeat_forward, true)
    assert.buffer("a | a  a w a w end")

    h.feedkeys(".", true)
    assert.buffer("a | a  end")
  end)
end)
