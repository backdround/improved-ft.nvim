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

  it("should preserve options after another hop", function()
    h.feedkeys("d", false)
    h.hop_with_character(ft.hop_forward_to_char, "w")
    assert.buffer("a  a w a w a w a w end")

    h.hop_with_character(ft.hop_forward_to_char, "a")

    h.feedkeys(".", true)
    assert.buffer("a   a w a w a w end")
  end)

  it("should preserve options after user repeat", function()
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

  it("should work with custom-operators", function()
    vim.keymap.set("n", "f", ft.hop_forward_to_char)

    local start_column = nil
    local end_column = nil
    local update_operator_area = function()
      start_column = vim.api.nvim_buf_get_mark(0, "[")[2] + 1
      end_column = vim.api.nvim_buf_get_mark(0, "]")[2] + 1
    end

    -- selene: allow(global_usage)
    _G.Test_operator = update_operator_area
    vim.opt.operatorfunc = "v:lua.Test_operator"

    vim.api.nvim_feedkeys("g@fw", "nx", false)
    assert.are.same(3, start_column)
    assert.are.same(7, end_column)

    h.set_cursor(1, 7)
    vim.api.nvim_feedkeys(".", "nx", false)
    assert.are.same(7, start_column)
    assert.are.same(11, end_column)
  end)

  it("should work in macros that uses dot", function()
    vim.keymap.set("n", "f", ft.hop_forward_to_char)

    vim.api.nvim_feedkeys("dwu", "ntx", true)
    vim.fn.setreg("a", ".fw")

    vim.api.nvim_feedkeys("@a", "nx", true)
    assert.buffer("a a w a w a w a w a w end")
    assert.cursor_at(1, 5)
  end)
end)
