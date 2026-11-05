return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-live-grep-args.nvim',
  },

  config = function()
    local telescope = require('telescope')
    local lga_actions = require('telescope-live-grep-args.actions')

    telescope.setup {
      pickers = {
        find_files = {
          theme = 'ivy'
        }
      },
      extensions = {
        live_grep_args = {
          mappings = {
            i = {
              ['<C-k>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        },
      },
    }
    telescope.load_extension('live_grep_args')

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args,
      { desc = 'Telescope live grep (args)' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath('config') }
      end,
      { desc = 'Telescope find files in nvim config dir' })
  end
}
