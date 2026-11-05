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

    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { buffer = args.buf, desc = 'LSP: ' .. desc })
    end
    local function telescope(picker)
      return function() require('telescope.builtin')[picker]() end
    end

    -- Neovim defaults kept: K hover, grn rename, gra code action, grr references,
    -- gri implementation, grt type definition, gO document symbols, <C-s> signature help (insert)

    -- Jumping
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('gy', vim.lsp.buf.type_definition, 'Go to type definition')
    map('gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('grr', telescope('lsp_references'), 'References')
    map('<leader>gd', function()
      vim.cmd.vsplit()
      vim.lsp.buf.definition()
    end, 'Definition in vertical split')

    -- Symbols
    map('<leader>fs', telescope('lsp_document_symbols'), 'Document symbols')
    map('<leader>fw', telescope('lsp_dynamic_workspace_symbols'), 'Workspace symbols')

    -- Hierarchies
    map('<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming calls')
    map('<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing calls')
    map('<leader>ch', function() vim.lsp.buf.typehierarchy('supertypes') end, 'Type hierarchy: supertypes')
    map('<leader>cH', function() vim.lsp.buf.typehierarchy('subtypes') end, 'Type hierarchy: subtypes')

    -- Diagnostics ([d / ]d are Neovim defaults)
    map('<leader>e', vim.diagnostic.open_float, 'Line diagnostics')
    map('<leader>q', vim.diagnostic.setqflist, 'Diagnostics to quickfix')

    -- Header/source switch (clangd only)
    if client.name == 'clangd' then
      map('<leader>o', '<cmd>LspClangdSwitchSourceHeader<CR>', 'Switch source/header')
    end
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
