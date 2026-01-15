-- VSCode-Neovim specific configuration
-- Only pure vim motions and keymaps that make sense in VSCode

local vscode = require('vscode')

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Search settings (still useful)
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 4
vim.opt.smartindent = true

-- ============================================================================
-- KEYMAPS THAT WORK IN VSCODE
-- ============================================================================

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines and keep cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Center screen after scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center screen after search navigation
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Delete without overwriting register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- ============================================================================
-- VSCODE-SPECIFIC KEYMAPS (calling VSCode commands)
-- ============================================================================

-- File explorer (replaces netrw)
vim.keymap.set("n", "<leader>pv", function() vscode.action("workbench.view.explorer") end)

-- Find files (replaces Telescope find_files)
vim.keymap.set("n", "<leader>ff", function() vscode.action("workbench.action.quickOpen") end)

-- Search in files (replaces Telescope live_grep)
vim.keymap.set("n", "<leader>fg", function() vscode.action("workbench.action.findInFiles") end)

-- Switch buffer (replaces Telescope buffers)
vim.keymap.set("n", "<leader>fb", function() vscode.action("workbench.action.showAllEditorsByMostRecentlyUsed") end)

-- Go to symbol
vim.keymap.set("n", "<leader>fs", function() vscode.action("workbench.action.gotoSymbol") end)

-- Toggle terminal
vim.keymap.set("n", "<leader>t", function() vscode.action("workbench.action.terminal.toggleTerminal") end)

-- Split navigation (use VSCode's split handling)
vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.focusLeftGroup") end)
vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.focusRightGroup") end)
vim.keymap.set("n", "<C-j>", function() vscode.action("workbench.action.focusBelowGroup") end)
vim.keymap.set("n", "<C-k>", function() vscode.action("workbench.action.focusAboveGroup") end)

-- Git diff (replaces Diffview)
vim.keymap.set("n", "<leader><leader>do", function() vscode.action("git.openChange") end)
vim.keymap.set("n", "<leader><leader>dh", function() vscode.action("git.viewFileHistory") end)

-- LSP actions (handled by VSCode, but keep familiar keybinds)
vim.keymap.set("n", "gd", function() vscode.action("editor.action.revealDefinition") end)
vim.keymap.set("n", "gr", function() vscode.action("editor.action.goToReferences") end)
vim.keymap.set("n", "K", function() vscode.action("editor.action.showHover") end)
vim.keymap.set("n", "<leader>rn", function() vscode.action("editor.action.rename") end)
vim.keymap.set("n", "<leader>ca", function() vscode.action("editor.action.quickFix") end)

-- Format document
--vim.keymap.set("n", "<leader>f", function() vscode.action("editor.action.formatDocument") end)

-- Comment toggle (VSCode native)
vim.keymap.set("n", "gcc", function() vscode.action("editor.action.commentLine") end)
vim.keymap.set("v", "gc", function() vscode.action("editor.action.commentLine") end)

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

-- Highlight when yanking text (works in VSCode too)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('vscode-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
