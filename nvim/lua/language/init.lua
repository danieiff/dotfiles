require 'nvim-treesitter.install'.compilers = { 'zig' }
local builtin_ts_parsers = { 'lua', 'vim', 'vimdoc', 'markdown', 'markdown_inline', 'c' }
for _, lang in ipairs(builtin_ts_parsers) do
  vim.treesitter.language.add(lang, { path = vim.fn.getenv 'VIM' .. '/../../lib/nvim/parser/' .. lang .. '.dll' })
end
require "nvim-treesitter.configs".setup {
  sync_install = false,
  auto_install = true,
  ensure_installed = {},
  ignore_install = builtin_ts_parsers,
  modules = {},
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<cr>",
      node_incremental = "<cr>",
      scope_incremental = "<leader><cr>",
      node_decremental = "<bs>"
    }
  }
}

require 'mason'.setup {}

AUC('FileType', { pattern = { 'json', 'jsonc', 'yaml', 'c', 'cpp', 'java', 'go' }, command = 'setlocal tabstop=4' })
AUC('FileType', { pattern = 'xml', command = 'setlocal formatexpr=xmlformat#Format()' })

require 'language.repl'
require 'language.web'
require 'language.typescript'
require 'language.java'
require 'language.json_yaml'

require 'lint'.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' }
}
AUC({ "BufWritePost" }, {
  callback = function(ev)
    if vim.fn.index(vim.fn.keys(require 'lint'.linters_by_ft), vim.bo[ev.buf].ft) >= 0 then
      require 'lint'.try_lint {}
    end
  end
})

local fmts = {
  prettier = { 'prettierd', prettier = 'fallback' }
}
require 'conform'.setup {
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    css = fmts.prettier,
    graphql = fmts.prettier,
    html = fmts.prettier,
    javascript = fmts.prettier,
    javascriptreact = fmts.prettier,
    json = fmts.prettier,
    markdown = fmts.prettier,
    python = { "isort", "black" },
    sql = { "sql-formatter" },
    svelte = fmts.prettier,
    typescript = fmts.prettier,
    typescriptreact = fmts.prettier,
    yaml = fmts.prettier,
    php = nil
  },
}

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = "jest --watch ",
      jestConfigFile = function() -- monorepo
        local file = vim.fn.expand('%:p')
        if file:find "/packages/" then
          return file:match "(.-/[^/]+/)src" .. "jest.config.ts"
        end
        return vim.fn.getcwd() .. "/jest.config.ts"
      end, cwd = function() -- monorepo
      local file = vim.fn.expand '%:p'
      if file:find "/packages/" then return file:match "(.-/[^/]+/)src" end
      return vim.fn.getcwd()
    end,
      env = { CI = true }
    },
    -- require 'neotest-vitest',
  }
}

K('<leader>tr', neotest.run.run)
K('<leadler>tf', function() neotest.run.run(vim.fn.expand '%') end)
K('<leader>td', function() neotest.run.run { strategy = 'dap' } end)
K('<leader>ts', neotest.run.stop)
K('<leader>ta', neotest.run.attach)

---@ DAP

local dap, dapui, dap_widgets = require 'dap', require 'dapui', require 'dap.ui.widgets'

-- :help dap-adapter dap-configuration dap.txt dap-mapping dap-api dap-widgets
K("<Leader>di", dap.toggle_breakpoint)
K("<Leader>dI", function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end)
K("<Leader>dp", function() dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end)
K("<Leader>ds", function()
    if vim.bo.filetype == "ruby" then
      vim.fn.setenv("RUBYOPT", "-rdebug/open")
      if vim.api.nvim_buf_get_name(0):find 'spec' then
        require("dap").run({
          type = "ruby",
          name = "debug rspec file",
          request = "attach",
          command = "rspec",
          script = "${file}",
          port = 38698,
          server = "127.0.0.1",
          localfs = true,      -- required to be able to set breakpoints locally
          stopOnEntry = false, -- This has no effect
        })
        return
      end
      vim.fn.setenv("RUBYOPT", "-rdebug/open")
      dap.continue()
      dap.continue()
    end
    dap.continue()
  end,
  { desc = "Start/Continue" })
K("<Leader>dl", dap.run_to_cursor)
K("<Leader>dS", dap.disconnect)
K("<Leader>dn", dap.step_over)
K("<Leader>dN", dap.step_into)
K("<Leader>do", dap.step_out)
K("<Leader>dww", function() dap.toggle() end)
K("<Leader>dw[", function() dap.toggle(1) end)
K("<Leader>dw]", function() dap.toggle(2) end)
K('<Leader>dr', dap.repl.open)
K('<Leader>dl', dap.run_last)
K('<Leader>dh', dap_widgets.hover, { mode = { 'n', 'v' } })
K('<Leader>dH', dap_widgets.preview, { mode = { 'n', 'v' } })
K('<Leader>dm', function() dap_widgets.centered_float(dap_widgets.frames) end)
K('<Leader>dM', function() dap_widgets.centered_float(dap_widgets.scopes) end)
K('<leader>dk', require 'dap.ui.widgets'.hover, { silent = true })

CMD("DapRunWithArgs", function(t)
  local args = vim.split(vim.fn.expand(t.args), '\n')
  if vim.fn.confirm(("Will try to run:\n%s %s %s\n? "):format(vim.bo.filetype, vim.fn.expand '%', t.args)) == 1 then
    dap.run({
      type = vim.bo.filetype == 'javascript' and 'pwa-node' or vim.bo.filetype == 'typescript' and 'pwa-node',
      request = 'launch',
      name = 'Launch file with custom arguments (adhoc)',
      program = '${file}',
      args = args,
    })
  end
end, { nargs = '*' })

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end

require 'nvim-dap-virtual-text'.setup {}

AUC('FileType', { pattern = 'dap-repl', callback = require 'dap.ext.autocompl'.attach })

require 'dap.ext.vscode'.load_launchjs(nil, {
  ["pwa-node"] = { "javascript", "typescript" },
  ["node"] = { "javascript", "typescript" },
  ["pwa-chrome"] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
  ["chrome"] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
  -- ["python"] = { "python" },
  -- ["dlv"] = { "go" },
})

---@ LSP

-- vim.lsp.set_log_level 'DEBUG' -- :LspLog
CMD('LspRestart', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd.edit()', {})

CMD('LspConfigReference', function()
  local ft = vim.fn.input { prompt = 'Search lsp config for filetype: ', default = vim.bo.ft }
  if ft == '' then return vim.notify 'no input' end

  vim.system(
    { 'curl', '-fsSL', 'https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/doc/configs.txt' },
    { text = true },
    function(res)
      if res.code ~= 0 then return vim.notify(res.stderr) end

      local server_configs_txt = res.stdout:gsub('\n##', '¬')
      local pattern = ('lua%%s+require\'lspconfig\'%%.([%%a_-]+)%%.setup[^¬]+%%- `filetypes` :%%s+```lua%%s+%%{[%%a", ]*"%s"[%%a", ]*%%}')
          :format(ft)

      local founds = server_configs_txt:gmatch(pattern)
      for ls in founds do
        local fname = ls .. '.lua'
        vim.system(
          { 'curl', '-fsSL', ('https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/server_configurations/' .. fname) },
          {}, function(curl_lsconfig_res)
            if curl_lsconfig_res.code ~= 0 then return vim.notify(curl_lsconfig_res.stderr) end
            vim.schedule(function()
              vim.cmd 'tabe'
              vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(curl_lsconfig_res.stdout, '\n'))
              vim.api.nvim_buf_set_name(0, fname)
              vim.bo.ft = 'lua'
            end)
          end)
      end
    end
  )
end, {})

CMD('LspCapa', function()
  local clients = vim.lsp.get_clients()
  vim.ui.select(vim.tbl_map(function(item) return item.name end, clients), {},
    function(_, idx)
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_win(bufnr, true, {
        relative = 'editor',
        col = 0,
        row = 0,
        width = vim.o.columns,
        height = vim.o.lines,
      })
      vim.api.nvim_buf_set_lines(bufnr, 0, 1, false,
        vim.split(
          '# config.capabilities: Config passed to vim.lsp.start_client()' ..
          '\n' .. vim.inspect(clients[idx].config.capabilities) .. '\n\n' ..
          '# server_capabilities:' .. '\n' .. vim.inspect(clients[idx].server_capabilities),
          "\n"))
      K('q', '<cmd>q!<cr>', { buffer = bufnr })
    end)
end, {})

require 'symbol-usage'.setup {}

AUC('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id), 'should have a client')

    -- if client.server_capabilities.foldingRangeProvider then
    --   vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    -- end

    if client:supports_method 'textDocument/documentColor' then
      vim.lsp.document_color.enable(true, ev.buf)
    end

    --[[
      Use CTRL-w ] to split the current window and jump to the definition of the symbol under the cursor in the upper window.
      Use CTRL-w } to open a preview window with the definition of the symbol under the cursor.
      gq (format)
      vim.lsp.codelens.refresh()
      vim.lsp.start { cmd = vim.lsp.rpc.connect('127.0.0.1', 6008), ... } -- builtin TCP support
    ]]
    K('<leader>d', vim.diagnostic.open_float)

    K('gd', vim.lsp.buf.definition)
    K('gt', vim.lsp.buf.type_definition)
    K('gl', vim.lsp.buf.declaration)
    K('gr', vim.lsp.buf.references)
    K('gi', vim.lsp.buf.implementation)
    K('<Leader>ci', vim.lsp.buf.incoming_calls)
    K('<Leader>co', vim.lsp.buf.outgoing_calls)
    K('cv', function()
      vim.lsp.buf.rename(nil, {
        filter = function(_client)
          local deprioritised = { 'typescript-tools' }
          return not vim.tbl_contains(deprioritised, _client.name) or
              #vim.lsp.get_clients { method = 'textDocument/rename' } < 1
        end
      })
    end)
    K('<space>rf', vim.lsp.util.rename)
    K('<space>ca', vim.lsp.buf.code_action)
    K('<space>pa', vim.lsp.buf.add_workspace_folder)
    K('<space>pr', vim.lsp.buf.remove_workspace_folder)
    K('<space>pl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end)
  end
})

vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = require 'blink.cmp'.get_lsp_capabilities()
})

-- require 'flutter-tools'.setup {
--   debugger = {
--     enabled = true,
--     register_configurations = function(_)
--       if vim.loop.fs_stat(vim.fn.getcwd() .. '/.vscode/launch.json') then
--         require 'dap'.configurations.dart = {}
--         require 'dap.ext.vscode'.load_launchjs()
--       end
--     end,
--   },
-- }
-- require 'fzf-lua'.load_extension 'flutter'

-- https://github.com/fatih/gomodifytags
-- https://github.com/yoheimuta/protolint
-- https://github.com/rhysd/actionlint

AUC('FileType', {
  pattern = 'go',
  once = true,
  callback = function()
    -- https://github.com/golang/tools/blob/master/gopls/README.md
    -- go install golang.org/x/tools/gopls@latest
    -- require 'lspconfig'.gopls.setup { capabilities, {
    --   hints = {
    --     assignVariableTypes = true,
    --     compositeLiteralFields = true,
    --     constantValues = true,
    --     functionTypeParameters = true,
    --     parameterNames = true,
    --     rangeVariableTypes = true
    --   }
    -- } }

    -- "https://github.com/ray-x/go.nvim",

    if vim.fn.executable 'golangci-lint' == 0 then
      vim.fn.jobstart('go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest')
    end
  end
})

AUC('FileType', {
  pattern = 'rust',
  once = true,
  callback = function()
    -- https://rust-analyzer.github.io/manual.html#installation
    -- "https://github.com/simrat39/rust-tools.nvim",
    -- "https://github.com/Saecki/crates.nvim",

    -- require 'lspconfig'.rust_analyzer.setup {
    --   settings = {
    --     ['rust-analyzer'] = {
    --       diagnostics = {
    --         enable = false,
    --       }
    --     }
    --   }
    -- }

    -- local rt = require 'rust-tools'
    -- rt.setup({
    --   server = {
    --     on_attach = function(_, bufnr)
    --       -- Hover actions
    --       vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
    --       -- Code action groups
    --       vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
    --     end,
    --   },
    --   capabilities
    -- })
  end
})

require 'lspconfig'.sourcery.setup {}

-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
-- https://github.com/linux-cultist/venv-selector.nvim/tree/regexp
-- pip install python-lsp-server
-- pip install "python-lsp-server[all]"
-- pip install pylsp-rope
require 'lspconfig'.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        ruff = { -- pip install python-lsp-ruff
          enabled = true,
          extendSelect = { "I" },
        },
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        },
        black = { -- pip install pylsp-black
          enabled = true
        }
      }
    }
  }
}

require 'lspconfig'.solidity_ls_nomicfoundation.setup {}

require 'lspconfig'.bashls.setup {}

dap.adapters.bashdb = {
  type = 'executable',
  name = 'bashdb',
  command = 'node',
  args = { '(bashdb executable)' }
}
dap.configurations.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = "Launch file",
    showDebugOutput = true,
    -- pathBashdb = DEPS_DIR.bin .. '/bash-debug/extension/bashdb_dir/bashdb',
    -- pathBashdbLib = DEPS_DIR.bin .. '/bash-debug/extension/bashdb_dir',
    trace = true,
    file = "${file}",
    program = "${file}",
    cwd = '${workspaceFolder}',
    pathCat = "cat",
    pathBash = "/bin/bash",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    args = {},
    env = {},
    terminalKind = "integrated",
  }
}

-- https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
require 'lspconfig'.ruby_lsp.setup {}
require 'dap-ruby'.setup() -- gem install rdbg rspec

require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
      }
    }
  }
}

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { [[xdebug.php-debug-1.34.0\out\phpDebug.js]] }
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    -- pathMappings = { ['/var/www/html'] = vim.fn.getcwd() }, -- .. '/',
    -- hostname = '0.0.0.0',
  }
}

require 'lspconfig'.intelephense.setup {
  -- cmd = { 'node', 'bmewburn.vscode-intelephense-client-1.10.4/node_modules/intelephense/lib/intelephense.js', '--stdio' },
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          -- '/ZendFramework-1.12.5',
          -- '/Smarty',
        }
      }
    }
  }
}

-- https://github.com/alexpasmantier/pymple.nvim

-- https:\\github.com\mtshiba\pylyzer
-- pip install pylyzer
require 'lspconfig'.pylyzer.setup {}

-- https:\\github.com\python-lsp\python-lsp-server\blob\develop\CONFIGURATION.md

-- https://github.com/nanotee/sqls.nvim/
-- https://github.com/sqls-server/sqls
require 'lspconfig'.sqls.setup {}
-- https://github.com/hat0uma/csvview.nvim
