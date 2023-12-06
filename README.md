# Improved-ft.nvim
It's a Neovim plugin that improves default `f/t` jump abilities

It provides:

- Multiline jump to a given character.
- Stable next / previous jumps that don't depend on last `f/t` jump direction.
- Additional `post` character offset (as well as default `pre` and `none` offsets).

<!-- panvimdoc-ignore-start -->

### Preview
#### Jump to a character (pre / none / post)
<img src="https://github.com/backdround/improved-ft.nvim/assets/17349169/0931c570-e0ef-4eb1-940f-20c268262f1b" width="650px" />

---

<!-- panvimdoc-ignore-end -->

### Configuration example
```lua
local ft = require("improved-ft")
ft.setup({
  -- Maps default f/F/t/T/;/, keys
  -- default: false
  use_default_mappings = true,
  -- Ignores case of the given characters.
  -- default: false
  ignore_char_case = true,
  -- Takes a last jump direction into account during repetition jumps.
  -- default: false
  use_relative_repetition = true,
})
```
