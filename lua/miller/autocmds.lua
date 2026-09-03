-- Highlight when yanking text
--   See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client then return end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        if vim.bo.buflisted then
            vim.opt_local.number = true
            vim.opt_local.relativenumber = true
        end
    end,
})
