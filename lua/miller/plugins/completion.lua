return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = false,
  opts = {
    keymap = {
      preset = "default",
    },
    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 300 },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "lua" },
  },
}
