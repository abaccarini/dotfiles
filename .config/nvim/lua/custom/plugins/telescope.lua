return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    -- branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
  -- 'nvim-telescope/telescope-frecency.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
  -- 'nvim-telescope/telescope-frecency.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'Mofiqul/dracula.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local dracula = require 'dracula'
      local colors = dracula.colors()

      vim.cmd.hi('TelescopeResultsMethod  guifg= ' .. colors['bright_magenta'])
      vim.cmd.hi('TelescopeResultsConstructor  guifg= ' .. colors['bright_blue'])
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'TelescopeResults',
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd('TelescopeParent', '\t\t.*$')
            vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
          end)
        end,
      })

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --

        defaults = {
          -- sorting_strategy = "ascending",
          file_ignore_patterns = { 'add.spl', 'pdf', 'png', 'csv', 'final', 'eps', 'pgf', 'bbl', 'bbx', 'ipe', 'bst', 'bcf', 'snm', 'nav', 'run.xml' },
          -- makes the telescope prompt slightly transparent
          -- winblend = 10,
          -- path_display = function(_, path)
          --   local tail = require('telescope.utils').path_tail(path)
          --   return string.format('%s (%s)', tail, path), { { { 1, #tail }, 'Constant' } }
          -- end,
          -- path_display = function(_, path)
          --   local tail = require('telescope.utils').path_tail(path)
          --   return string.format('%s (%s)', tail, path)
          -- end,
          mappings = {
            i = { ['<c-s-n>'] = require('telescope.actions').move_selection_previous },
          },
          path_display = { filename_first = {
            reverse_directories = false,
          } },
        },
        pickers = {
          find_files = {
            path_display = { filename_first = {
              reverse_directories = false,
            } },
            -- theme = 'ivy',
            -- theme = 'dropdown',
            -- hidden = true,
          },
          oldfiles = {
            cwd_only = true,
          },

          live_grep = {
            -- only_sort_text = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          file_browser = {
            hidden = { file_browser = true, folder_browser = true },
            -- theme = 'ivy',
            hijack_netrw = true,
            vim.keymap.set('n', '<space>pv', ':Telescope file_browser<CR>'),
          },
          project = {},
          -- frecency = {
          --   --   default_workspace = "CWD",
          --   --   db_safe_mode = false,
          --   path_display = { filename_first = {
          --     reverse_directories = false,
          --   } },
          -- },
        },
      }

      -- vim.cmd.hi('TelescopePreviewLine  guibg=none guifg=' .. colors['red'])
      -- vim.cmd.hi('TelescopeMatching  guibg=none guifg=' .. colors['red'])
      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')
      pcall(require('telescope').load_extension, 'project')
      -- pcall(require('telescope').load_extension, 'live_grep_args')
      -- pcall(require('telescope').load_extension, 'frecency')
      -- require'telescope.builtin'.grep_string{ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' }
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch in existing [B]uffers' })
      vim.keymap.set('n', '<leader>pl', require('telescope').extensions.project.project, { desc = 'Switch [P]roject' })
      -- vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope frecency<CR>', { desc = '[S]earch [F]iles' })

      -- vim.keymap.set('n', '<leader><leader>', function()
      --   require('telescope').extensions.frecency.frecency { workspace = 'CWD' }
      -- end)

      vim.keymap.set('n', '<leader>sw', function()
        builtin.grep_string { word_match = '-w', only_sort_text = false, search = '' }
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          preview = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          vim.wo.wrap = true
        end,
      })
    end,
  },
  --   {
  --   'nvim-telescope/telescope-file-browser.nvim',
  --   event = 'VimEnter',
  --   dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  --   config = function() end,
  -- }, {
  --   'nvim-telescope/telescope-project.nvim',
  --   event = 'VimEnter',
  --   dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-file-browser.nvim' },
  --   config = function()
  --     require('telescope').load_extension 'project'
  --     -- local builtin = require 'telescope.extensions.project'
  --   end,
  -- },
  -- {
  --   'nvim-telescope/telescope-frecency.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'nvim-telescope/telescope.nvim',
  --   },
  --   config = function()
  --     require('telescope').load_extension 'frecency'
  --   end,
  -- },
}
