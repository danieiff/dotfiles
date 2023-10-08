local extensions = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'astro' }

local npm_deps = { 'typescript', 'vscode-langservers-extracted', '@tailwindcss/language-server',
  '@styled/typescript-styled-plugin', 'typescript-styled-plugin', 'cssmodules-language-server' }

local debug_adapter_dir = vim.fn.stdpath 'config' .. '/js-debug'

local typescript_aug = vim.api.nvim_create_augroup('TypescriptAUG', {})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

AUC('FileType', {
  pattern = extensions,
  once =true,
  callback = function()
    for _, d in ipairs( npm_deps ) do
      if not vim.g.npm_list:find(d:gsub('-', '%%-') .. '\n') then
        vim.fn.jobstart('npm i -g ' .. d) 
      end
    end

    require 'util'.ensure_pack_installed {
      {
        url = "https://github.com/pmizio/typescript-tools.nvim",
        callback = function()
          require 'typescript-tools'.setup {
            capabilities = capabilities,
            settings = {
              tsserver_file_preferences = {
                -- includeInlayParameterNameHints = "none",
                -- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                -- includeInlayFunctionParameterTypeHints = false,
                -- includeInlayVariableTypeHints = false,
                -- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                -- includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
                -- includeCompletionsForModuleExports = true,
              },
              tsserver_format_options = {
                -- allowIncompleteCompletions = false,
                -- allowRenameOfImportPath = false,
              },
              importModuleSpecifierPreference = "non-relative",
              -- tsserver_plugins = { "@styled/typescript-styled-plugin" }
            }
          }
        end
      },
      { url = "https://github.com/nvim-neotest/neotest-jest" }
    }

    if vim.tbl_get(vim.loop.fs_stat(debug_adapter_dir) or {}, 'type') ~= 'directory' then
      vim.cmd 'botright sp +enew'
      vim.fn.termopen('cd ' .. vim.fn.stdpath 'config' .. ' && ghinstall microsoft/vscode-js-debug',
        { on_exit = function() vim.defer_fn(function() vim.api.nvim_buf_delete(0, { force = true }) end, 2000) end })
    end

    ---@ Lsp

    if vim.tbl_get(vim.loop.fs_stat('./deno.json') or {}, 'type') == 'file' then
      vim.g.markdown_fenced_languages = { "ts=typescript" }
      require 'lspconfig'.denols.setup {}
    end

    require 'lspconfig'.tailwindcss.setup {
      on_attach = function(_, _ --[[ buffer ]]) 
        client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      --[[ require('tailwindcss-colors').buf_attach(_bufnr)  ]] end,


      handlers = {
        ['tailwindcss/getConfiguration'] = function(_, _, params, _, bufnr, _)
          -- tailwindcss lang server wai swap = {
          vim.lsp.buf_notify(bufnr, 'tailwindcss/getConfigurationResponse', { _id = params._id })
        end
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "tv\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },  -- for tailwind-variants
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },  -- for cva
              { "cx\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" } -- for cva
            },
          },
        },
      }
    }

    if vim.tbl_get(vim.loop.fs_stat('./node_modules/.bin/relay-compiler') or {}, 'type') == 'file' then
      require 'lspconfig'.relay_lsp.setup {
        -- (default: false) Whether or not we should automatically start
        -- the Relay Compiler in watch mode when you open a project
        auto_start_compiler = false,

        -- (default: null) Path to a relay config relative to the
        -- `root_dir`. Without this, the compiler will search for your
        -- config. This is helpful if your relay project is in a nested directory.
        path_to_config = nil,
      }
    end

    --[[
     require'lspconfig'.cssmodules_ls.setup {
     on_attach = function (client)
         -- avoid accepting `definitionProvider` responses from this LSP
         -- client.server_capabilities.definitionProvider = false
     end,
     }
     ]]


    ---@ Dap

    local dap = require 'dap'

    for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = "node", args = { debug_adapter_dir .. "/src/dapDebugServer.js", "${port}" } }
      }
    end
    for _, ext in ipairs(extensions) do
      dap.configurations[ext] = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          outFiles = { "${workspaceFolder}/dist/**/*.js", "!**/node_modules/**" },
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          -- trace = true, -- include debugger info (available in all configs of 'vscode-js-debug')
        },
        {
          name = "Launch Current File (pwa-node with ts-node)",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "node",
          runtimeArgs = { "--loader", "ts-node/esm" },
          args = { "${file}" },
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
        },
        {
          name = "Launch Test Current File (pwa-node with deno)",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "deno",
          runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
          console = "integratedTerminal",
          attachSimplePort = 9229,
        },
        {
          name = "Debug Jest Tests",
          type = "pwa-node",
          request = "launch",
          runtimeExecutable = "node",
          runtimeArgs = { "./node_modules/jest/bin/jest.js" }, -- "--runInBand" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          name = "Launch Test Current File (pwa-node with vitest)",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
          args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          name = "Debug Mocha Tests",
          request = "launch",
          type = "pwa-node",
          runtimeExecutable = "node",
          runtimeArgs = { "./node_modules/mocha/bin/mocha.js" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          name = "Attach Program (pwa-node, select pid)",
          type = "pwa-node",
          request = "attach",
          processId = require 'dap.utils'.pick_process,
          skipFiles = { "<node_internals>/**" },
          -- restart = true, -- https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_restarting-debug-sessions-automatically-when-source-is-edited use with nodemon
        },
        {
          name = 'Launch chrome',
          type = "pwa-chrome",
          request = "launch",
          program = "${file}",
          url = function() return 'http://localhost:' .. vim.fn.input("Select port: ", 8080) end,
          port = 9222
        },
        {
          name = 'Attach chrome',
          type = "pwa-chrome",
          request = "attach",
          program = "${file}",
          port = 9222
        }
      }
    end

    vim.schedule(vim.cmd.edit)
  end
})

AUC('FileType', {
  pattern = 'vue',
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { '@vue/language-server' }
    --https://github.com/johnsoncodehk/volar/tree/20d713b/packages/vue-language-server

    local util = require 'lspconfig.util'
    local function get_typescript_server_path(root_dir)
      local global_ts = '/usr/local/lib/node_modules/typescript/lib'
      local found_ts = ''
      local function check_dir(path)
        found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib')
        if util.path.exists(found_ts) then return path end
      end
      return util.search_ancestors(root_dir, check_dir) and found_ts or global_ts
    end
    require 'lspconfig'.volar.setup {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end,

    }
  end
})

AUC('FileType', {
  pattern = 'svelte',
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { 'svelte-language-server' }
    require 'lspconfig'.svelte.setup {}
  end
})

AUC('FileType', {
  pattern = 'astro',
  once = true,
  callback = function()
    local cmd = 'npm install -g @astrojs/language-server'
    local npm_list = vim.fn.system('npm -g list -p')
    local job_npm = vim.tbl_map(function(d)
      if not npm_list:find(d:gsub('-', '%%-') .. '\n') then return vim.fn.jobstart('npm i -g ' .. d) end
    end, npm_deps)
    require 'lspconfig'.astro.setup {}
    -- https://github.com/withastro/language-tools/tree/main/packages/language-server
    -- default:
    -- `cmd` :
    --{ "astro-ls", "--stdio" }
    -- `filetypes` :
    --{ "astro" }
    -- `init_options` :
    --{ typescript = {} }
    -- `on_new_config` :
    --see source file
    -- `root_dir` :
    --root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
  end
})

AUC('FileType', {
  pattern = 'prisma',
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { '@prisma/language-server' }
    require 'lspconfig'.prismals.setup {}
  end
})
