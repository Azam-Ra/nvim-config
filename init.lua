require("miller.base")
require("miller.remap")
require("miller.autocmds")
require("miller.lazy")
require("miller.lsp")

-- Plugins related config
--   Colorscheme 
vim.cmd.colorscheme("catppuccin-mocha")
--
--   Bar line 
local custom_theme = require'lualine.themes.modus-vivendi'
-- custom_theme.command.a.bg = '#babbf1'
require('lualine').setup {
  options = { theme  = custom_theme },
  ...
}
--
--  lsp
vim.diagnostic.config({
  virtual_text = true,
})

