local rh = require("rabbit-hop")
local h = require("tests.helpers")

require("tests.custom-asserts").register()

describe("user-options", function()
  before_each(h.get_preset([[
    aa bb aa bb aa bb
  ]], { 1, 0 }))

  it('"direction" should be "forward" by default', function()
    h.perform_through_keymap(rh.hop, true, {
      direction = nil,
      offset = "start",
      pattern = "aa"
    })
    assert.cursor_at(1, 6)
  end)

  it('"offset" should be "start" by default', function()
    h.perform_through_keymap(rh.hop, true, {
      direction = "forward",
      offset = nil,
      pattern = "aa"
    })
    assert.cursor_at(1, 6)
  end)
end)
