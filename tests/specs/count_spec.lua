local ft = require("improved-ft")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("v:count", function()
  before_each(h.get_preset([[
    a a a a a a
  ]], { 1, 0 }))

  it("should be respected during hop", function()
    h.feedkeys("3", false)
    h.hop_with_character(ft.hop_forward_to_char, "a")
    assert.cursor_at(1, 6)
  end)

  it("should be respected during repeat", function()
    h.hop_with_character(ft.hop_forward_to_char, "a")
    h.feedkeys("3", false)
    h.perform_through_keymap(ft.repeat_forward, true)
    assert.cursor_at(1, 8)
  end)

  it(
    "should be taken as a maximal possible count if v:count is too big",
    function()
      h.feedkeys("22", false)
      h.hop_with_character(ft.hop_forward_to_char, "a")
      assert.cursor_at(1, 10)
    end
  )
end)
