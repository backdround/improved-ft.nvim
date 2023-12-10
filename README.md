# Improved-ft.nvim
It's a feature-rich, but straight-forward Neovim plugin that improves default
`f/t` hop abilities.

Additional features:
- Works in multiline;
- Works in `insert` mode;
- Has the additional `post` offset;
- Has the aibilty of stable next / previous hops (don't depend on last hop direction).

<!-- panvimdoc-ignore-start -->

### Preview
#### Hop to a character (pre / none / post)
<img src="https://github.com/backdround/improved-ft.nvim/assets/17349169/0931c570-e0ef-4eb1-940f-20c268262f1b" width="650px" />

---

<!-- panvimdoc-ignore-end -->

### Basic configuration
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
### Advanced configuration

<details><summary>Basic mappings</summary>

```lua
local map = function(key, fn, description)
  vim.keymap.set({ "n", "x", "o" }, key, fn, {
    desc = description,
  })
end

map("f", ft.hop_forward_to_char, "Hop forward to a given char")
map("F", ft.hop_backward_to_char, "Hop backward to a given char")

map("t", ft.hop_forward_to_pre_char, "Hop forward before a given char")
map("T", ft.hop_backward_to_pre_char, "Hop backward before a given char")

map(";", ft.repeat_forward, "Repeat hop forward to a last given char")
map(",", ft.repeat_backward, "Repeat hop backward to a last given char")
```

</details>

<details><summary>Post character mappings</summary>

```lua
local map = function(key, fn, description)
  vim.keymap.set({ "n", "x", "o" }, key, fn, {
    desc = description,
  })
end

map("s", ft.hop_forward_to_post_char, "Hop forward after a given char")
map("S", ft.hop_backward_to_post_char, "Hop backward after a given char")

```

</details>

<details><summary>Insert mode mappings</summary>

```lua
local imap = function(key, fn, description)
  vim.keymap.set("i", key, fn, {
    desc = description,
  })
end

imap("<M-f>", ft.hop_forward_to_char, "Hop forward to a given char")
imap("<M-F>", ft.hop_backward_to_char, "Hop forward to a given char")

imap("<M-t>", ft.hop_forward_to_pre_char, "Hop forward before a given char")
imap("<M-T>", ft.hop_backward_to_pre_char, "Hop forward before a given char")

imap("<M-;>", ft.repeat_forward, "Repeat hop forward to a last given char")
imap("<M-,>", ft.repeat_backward, "Repeat hop backward to a last given char")
```

</details>
