vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "clangd",
  "bash_ls"
})
