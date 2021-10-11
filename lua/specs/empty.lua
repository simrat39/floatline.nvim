vim.cmd[[
set laststatus=2
set statusline=%m\ %F\ %m\%y\ %{&fileencoding?&fileencoding:&encoding}\ %=%(C:%c\ L:%l\ %P%)
]]
