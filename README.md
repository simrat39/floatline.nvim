# floatline.nvim
Make 1 global statusline on floating window

It is not a statusline plugin. It copy your statusline to floating window
It support all statusline plugin.
I tested vim-airline,lightline.vim,lualine.nvim

Credit to [@shadmansaleh](https://github.com/shadmansaleh/) for an ffi code

you should carefully to use it. It use ffi code to call from lua to c

## Installation

``` vim
Plug 'windwp/floatline.nvim'
```

```lua
--- Packer
use 'windwp/floatline.nvim'


require('floatline').setup()
```


## How do I do that?

* create a floating window on bottom
* use luv(vim.loop) to update text and highlight by extmark.

## Issue
- If you open another tabpage and you close the last window by command.
`:quit or :bdelete :close` . It will throw error so you need to change to use
command `:Wquit and :Wbdelete.`

issue https://github.com/neovim/neovim/issues/11440 it will not happen if that issue is fixed

- a floating window can overlap some messages from command line mode

## Warning
floatline.nvim only copy the statusline to floating window.
It can't hide the default statusline on active window because it belong to
statusline plugin.


If you want to looking for a statusline support to hide it.

You can try for better experiences
* [windline.nvim](https://github.com/windwp/windline.nvim)
