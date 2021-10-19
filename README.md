# floatline.nvim
Make 1 global statusline on floating window

It need neovim 0.6 lastest.
It is not a statusline plugin. It copy your statusline to floating window
It support all statusline plugin.
I tested vim-airline,lightline.vim,lualine.nvim

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

## custom status.
```lua
local count = 1
local txt = '%#Visual# shadman so lazy %##'
require('floatline').setup({
    status = function()
        local space = string.rep(' ', vim.o.columns - count- 15)
        if count < vim.o.columns then
            count = count + 2
        else
          return nil
        end
        return space .. txt
    end,
})
```
you can use it to do something fun or intergation with your plugin statusline

## Issue
- If you open another tabpage and close the last window by command.
`:quit or :bdelete :close` . It will throw error so you need to change to use
command `:Wquit and :Wbdelete.`

Issue https://github.com/neovim/neovim/issues/11440 it will not happen if that issue is fixed
or you can build neovim with PR https://github.com/neovim/neovim/pull/14387


- a floating window can overlap some messages from command line mode

## Warning
floatline.nvim only copy the statusline to floating window.
It can't hide the default statusline on active window because it belong to
statusline plugin.


If you want to looking for a statusline support to hide it.

You can try for better experiences
* [windline.nvim](https://github.com/windwp/windline.nvim)
