# marks-vibes.nvim

Quick preview window for a Neovim mark in a Telescope-style floating window with full file context and good vibes! 🎵

## ✨ Features

- 🎯 Preview any mark (lowercase or uppercase) in a large floating window
- 📜 Full file scrolling support - not just context lines
- 🎨 Syntax highlighting preserved
- 🌍 Works with global marks (A-Z) across different files
- ⚡ Jump to mark with `<CR>`, close with `q` or `<Esc>`
- 🔭 Telescope-inspired UI (90% of screen size)

## 📦 Installation

### With lazy.nvim
```lua
{
  "ALPHAvibe/marks-vibes.nvim",
  config = function()
    local marks = require('marks-vibes')
    
    -- Add your keymaps
    vim.keymap.set('n', '<leader>fmj', function()
      marks.open_float_at_mark('J')
    end, { desc = "Preview mark J" })
  end
}
```

### With packer
```lua
use {
  'ALPHAvibe/marks-vibes.nvim',
  config = function()
    -- Add your keymaps
  end
}
```

## 🚀 Usage
```lua
-- Preview mark 'a'
require('marks-vibes').open_float_at_mark('a')

-- Preview mark 'A' (global mark, different file)
require('marks-vibes').open_float_at_mark('A')
```

### Keymaps inside floating window

- `q` or `<Esc>` - Close the floating window
- `<CR>` - Jump to the mark in the actual buffer
- All normal Vim motions work for scrolling (`j`, `k`, `Ctrl-d`, `Ctrl-u`, `gg`, `G`, etc.)

## ⚙️ Example Configuration

### Basic setup
```lua
local marks = require('marks-vibes')

-- Preview different marks
vim.keymap.set('n', '<leader>fmk', function() marks.open_float_at_mark('K') end)
vim.keymap.set('n', '<leader>fmf', function() marks.open_float_at_mark('F') end)
vim.keymap.set('n', '<leader>fmd', function() marks.open_float_at_mark('D') end)
```
