vim.cmd([[packadd lualine.nvim]])
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'powerline',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    lualine_c = { },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
