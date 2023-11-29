# Improved-ft.nvim
It's a Neovim plugin that improves default `f/t` jump abilities

It provides:

- multiline jump to a given character.
- ability to jump to a user defined vim-pattern.
- stable next / previous jumps that don't depend on last jump direction.
- additional `post` character offset (as well as default `pre` and `none` offsets).

Differences to other similar plugins:

- Doesn't use any labels.
- Doesn't depend on `vim-repeat`.
- Uses lua only.
- Adds ability to jump to a user defined vim-pattern.

### Configuration example
```lua
local ft = require("improved-ft")
ft.setup({
  -- Maps default f/F/t/T/;/, keys
  -- default: false
  use_default_mappings = true
  -- Ignores case of interactively given characters.
  -- default: false
  ignore_user_char_case = true
})
```

### Additional configuration examples
<details><summary>Jump pass a character</summary>

```lua
-- Jump forward pass a given by user character.
vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward"
    offset = "post",
    pattern = nil,
  })
end)

-- Jump backward pass a given by user character.
vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "post",
    pattern = nil,
  })
end)
```

</details>

<details><summary>Jump pass any quotes</summary>

```lua
-- Jump forward pass any quotes.
vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward"
    offset = "post",
    pattern = "\\v[\"'`]",
  })
end)

-- Jump backward pass any quotes.
vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "post",
    pattern = "\\v[\"'`]",
  })
end)
```

</details>

<details><summary>Jump inside round brackets</summary>

```lua
-- Jump forward inside round brackets.
vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward"
    offset = "post",
    pattern = "\\M(",
  })
end)

-- Jump backward inside round brackets.
vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "post",
    pattern = "\\M)",
  })
end)
```

</details>

<details><summary>Jump inside / outside round brackets</summary>

```lua
-- Jump forward inside / outside round brackets.
vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward"
    offset = "post",
    pattern = "\\v[()]",
    -- If you don't want to jump post ) that is the last character on the line.
    -- use this pattern: "\\v((|\\)$@!)"
  })
end)

-- Jump backward inside / outside round brackets.
vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "post",
    pattern = "\\v[()]",
  })
end)
```

</details>

<details><summary>Jump to a number</summary>

```lua
-- Jump forward to a number.
vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward"
    offset = "none",
    pattern = "\\v\\d+",
  })
end)

-- Jump backward to a number.
vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "none",
    pattern = "\\v\\d+",
  })
end)
```

</details>

### API Functions
- `jump` - Perform a jump to a character or a predefined pattern.
- `repeat_forward` - Repeat last saved jump forward.
- `repeat_backward` - Repeat last saved jump backward.

| `jump` option | Default | Possible | Description |
| --- | --- | --- | --- |
| `direction` | `"forward"` | `"forward"`, `"backward"` | Direction to jump |
| `pattern` | `nil` (wait for a user input) | any vim pattern | Pattern to jump |
| `offset` | `"none"` | `"pre"`, `"none"`, `"post"` | Offset to a character / pattern |
| `save_for_repetition` | `pattern` == `nil` | `true`, `false` | Save the jump for `repeat_forward` and `repeat_backward`

#### Api usage example:
```lua

local ft = require("improved-ft")

vim.keymap.set({"n", "x", "o"}, ")", ft.repeat_forward)
vim.keymap.set({"n", "x", "o"}, "(", ft.repeat_backward)

vim.keymap.set({"n", "x", "o"}, "s", function()
  ft.jump({
    direction = "forward",
    offset = "none",
    pattern = "\\M=",
    save_for_repetition = false,
  })
end)

vim.keymap.set({"n", "x", "o"}, "S", function()
  ft.jump({
    direction = "backward",
    offset = "none",
    pattern = "\\M=",
    save_for_repetition = false,
  })
end)
```
