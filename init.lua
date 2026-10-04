----------------------------------------
-- neovim settings
----------------------------------------

do
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = true

  -- line numbers
  vim.o.number = true
  vim.o.relativenumber = true

  -- line breaks
  vim.o.linebreak = true

  -- tab stuff
  vim.o.expandtab = true -- expand tab input with spaces characters
  vim.o.autoindent = true -- automatically add indents to newlines
  vim.o.smartindent = true -- syntax aware indentations for newline inserts
  vim.o.tabstop = 2 -- num of space characters per tab
  vim.o.shiftwidth = 2 -- spaces per indentation level

  -- import keymaps
  require('keymaps')

  -- label folds
  vim.opt.foldcolumn = '1'
  vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ... ' . '(' . (v:foldend - v:foldstart + 1) . ' lines)']]
  vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:,foldinner: ]]
  vim.opt.foldlevel = 99

  -- window borders
  vim.o.winborder = 'single'

  -- mouse mode
  vim.o.mouse = 'a'

  -- hide mode (handled by lualine)
  vim.o.showmode = false

  -- sync clipboard
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  -- enable break indent
  vim.o.breakindent = true

  -- enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- decrease update time
  vim.o.updatetime = 250

  -- decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- whitespace display
  vim.o.list = true
  vim.opt.listchars = {
    tab = '  ',
    -- trail = '·',
    -- nbsp = '␣'
  }

  -- live substitution preview
  vim.o.inccommand = 'split'

  -- show cursor line
  vim.o.cursorline = true

  -- minimum screen lines above/below cursor
  vim.o.scrolloff = 8

  -- confirm before quitting/saving
  vim.o.confirm = true

  -- diagnostic Config & Keymaps
  -- see :help vim.diagnostic.Opts
  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = 'if_many',
    },
    underline = {
      severity = {
        min = vim.diagnostic.severity.WARN,
      },
    },

    -- can switch between these as you prefer
    virtual_text = true,   -- text shows up at the end of the line
    virtual_lines = false, -- text shows up underneath the line, with virtual lines

    -- auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      float = true,
    },
  })

  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {
      clear = true,
    }),
    callback = function()
      vim.hl.on_yank()
    end,
  })
end

----------------------------------------
-- vim.pack setup, build hooks
----------------------------------------

do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then
        output = 'No output from build command.'
      end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- Runs build commands for plugins on install or update

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable('make') == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.hase('win32') ~= 1 and vim.fn.executable('make') == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then
          vim.cmd.packadd('nvim-treesitter')
        end
        vim.cmd('TSUpdate')
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function github(repo)
  return 'https://github.com/' .. repo
end

----------------------------------------
-- ui / core ux plugins
----------------------------------------

do
  -- guess-indent
  vim.pack.add({ github('NMAC427/guess-indent.nvim') })
  require('guess-indent').setup({})

  -- nvim-web-devicons
  if vim.g.have_nerd_font then
    vim.pack.add({ github('nvim-tree/nvim-web-devicons') })
  end

  -- gitsigns
  vim.pack.add({ github('lewis6991/gitsigns.nvim') })
  require('gitsigns').setup({
    signs = {
      add = { text = '+' }, ---@diagnostic disable-next-line: missing-fields
      change = { text = '+' }, ---@diagnostic disable-next-line: missing-fields
      delete = { text = '+' }, ---@diagnostic disable-next-line: missing-fields
      topdelete = { text = '+' }, ---@diagnostic disable-next-line: missing-fields
      changedelete = { text = '+' }, ---@diagnostic disable-next-line: missing-fields
    },
  })

  -- color scheme
  vim.opt.rtp:append({ '~/.config/nvim/lua/chroma' })
  require('chroma').setup()
  vim.cmd.colorscheme('chroma')

  -- highlight comments
  vim.pack.add({ github('folke/todo-comments.nvim') })
  require('todo-comments').setup({ signs = false })

  -- mini.nvim
  vim.pack.add({ github('nvim-mini/mini.nvim') })

  require('mini.ai').setup({
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim >=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  })

  -- require('mini.surround').setup()

  require('mini.files').setup({
    mappings = {
      synchronize = 'w',
      go_in_plus = '<CR>',
    },
  })

  vim.keymap.set('n', '<leader>e', function()
    require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
  end, { desc = 'Open mini.files' })

  vim.keymap.set('n', '<leader>E', function()
    require('mini.files').open(vim.fn.getcwd(), true)
  end, { desc = 'Open mini.files (cwd)' })
end

----------------------------------------
-- search and navigation
----------------------------------------

do
  local telescope_plugins = {
    github('nvim-lua/plenary.nvim'),
    github('nvim-telescope/telescope.nvim'),
    github('nvim-telescope/telescope-ui-select.nvim'),
  }
  if vim.fn.executable('make') == 1 then
    table.insert(telescope_plugins, github('nvim-telescope/telescope-fzf-native.nvim'))
  end

  vim.pack.add(telescope_plugins)

  require('telescope').setup({
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  })

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files (\'.\' for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  -- If you later switch picker plugins, this is where to update these mappings.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set(
        'n',
        'gW',
        builtin.lsp_dynamic_workspace_symbols,
        { buffer = buf, desc = 'Open Workspace Symbols' }
      )

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set(
        'n',
        'grt',
        builtin.lsp_type_definitions,
        { buffer = buf, desc = '[G]oto [T]ype Definition' }
      )
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- It's also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep({
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    })
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files({ cwd = vim.fn.stdpath('config') })
  end, { desc = '[S]earch [N]eovim files' })
end

----------------------------------------
-- language servers
----------------------------------------

do
  -- useful status updates for LSP
  vim.pack.add({ github('j-hui/fidget.nvim') })
  require('fidget').setup({})

  -- runs on LSP attach to buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- rename variable under the cursor
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- execute a code action
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- goto Declaration
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- highlight references of word under cursor; see `:help CursorHold`
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
          end,
        })
      end

      -- toggle inlay hints
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, '[T]oggle Inlay [H]ints')
      end

      --------------------
      -- generate build.hxml for OpenFL projects (needed for LSP)
      --------------------
      if vim.fn.filereadable('project.xml') == 1 and vim.fn.filereadable('build.hxml') == 0 then
        print('build.hxml not found for Haxe project. Creating build.hxml...')
        vim.fn.system('haxelib run lime display cpp > build.hxml')
      end
    end,
  })

  -- Enable language servers
  --
  ---@type table<string, vim.lsp.Config>
  local servers = {
    stylua = {}, -- used for Lua code formatting
    clangd = {  -- used for C/C++
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
      }
    },
    fortls = { -- used for fortran
      cmd = {
        'fortls',
        '--lowercase_intrinsics'
      }
    },
    cssls = {}, -- used for CSS
    css_variables = {}, --  ditto
    ts_ls = {}, -- typescript/javascript
    jsonls = {}, -- json
    ruby_lsp = {}, -- ruby
    texlab = {}, -- latex
    pylsp = {}, --python
    haxe_language_server = {
      cmd = { 'haxe-language-server' },
      filetypes = { 'haxe' },
      root_markers = { 'project.xml' },
      settings = {
        haxe = {
          executable = 'haxe',
        },
      },
      init_options = {
        displayArguments = { 'build.hxml' },
      },
    },
    emmet_language_server = {
      filetypes = { 'css', 'html', 'javascript', 'eruby', 'scss', 'sass', 'less', 'ejs' },
      init_options = {
        preferences = {
          ['output.indent'] = '  ',
        },
      },
    },
    lua_ls = { -- special lua config recommended by nvim help docs
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- disable formatting (covered by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath('config')
            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- disable formatting (covered by stylua)
        },
      },
    },
  }

  vim.pack.add({
    github('neovim/nvim-lspconfig'),
    github('mason-org/mason.nvim'),
    github('mason-org/mason-lspconfig.nvim'),
    github('WhoIsSethDaniel/mason-tool-installer.nvim'),
  })

  -- auto install LSPs and related tools to nvim stdpath
  require('mason').setup({})

  -- ensure the above are installed (run :Mason)
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- other tools for mason to install can be added
  })

  require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

----------------------------------------
-- formatting
----------------------------------------

do
  -- conform.nvim
  vim.pack.add({ github('stevearc/conform.nvim') })
  require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
      local enabled_filetypes = {
        -- filetypes to autoformat on save
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- use external formatters if configured below
    },
    formatters_by_ft = {
      -- specify external formatters. use `stop_after_first = true` to stop after first formatter
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format({ async = true })
  end, { desc = '[Format] buffer' })
end

----------------------------------------
-- autocomplete
----------------------------------------

do
  -- blink.cmp
  vim.pack.add { { src = github 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      preset = 'default'
    },

    appearance = {
      nerd_font_variant = 'mono'
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 }
    },

    sources = {
      default = { 'lsp', 'path' }
    },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true }
  }
end

----------------------------------------
-- treesitter
----------------------------------------

do
  vim.pack.add { { src = github 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end

    -- treesitter based folding
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'

    vim.treesitter.start(buf, language)
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then vim.bo.indentexpr = 'v:lua.require\'nvim-treesitter\'.indentexpr()' end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        treesitter_try_attach(buf, language)
      end
    end
  })
end

----------------------------------------
-- modular plugins
----------------------------------------

do
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.gitsigns'
  require 'plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
