local extensions = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'astro',
  'angular' }

local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  local global_ts, found_ts = os.getenv 'HOME' .. '/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js', ''
  local function check_dir(path)
    found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js')
    if util.path.exists(found_ts) then return path end
  end
  return util.search_ancestors(root_dir, check_dir) and found_ts or global_ts
end

local cwd = vim.loop.cwd()
local function found(module_specific_path)
  return util.search_ancestors(cwd,
    function(path) return vim.loop.fs_stat(vim.fs.joinpath(path, module_specific_path)) end)
end

REQUIRE({
    { type = 'npm', arg = 'typescript' },
    { type = 'npm', arg = 'ts-node' },
    {
      type = 'bin',
      arg =
      [[ VERSION=$(curl -s https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest | grep -Po '"tag_name": "\K[^"]*') && curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/latest/download/js-debug-dap-${VERSION}.tar.gz | tar xz ]],
      executable = 'js-debug/src/dapDebugServer.js'
    }
  },
  function(_, _, db)
    if found 'deno.json' then
      vim.g.markdown_fenced_languages = { "ts=typescript" }
      require 'lspconfig'.denols.setup {}
    else
      require 'typescript-tools'.setup {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
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
        }
      }
    end

    local dap = require 'dap'

    for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = { command = "node", args = { db, "${port}" } }
      }
    end
    for _, ext in ipairs(extensions) do
      dap.configurations[ext] = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = "${file}",
          outFiles = { "${workspaceFolder}/dist/**/*.js", "!**/node_modules/**" },
          resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          trace = true,
        },
        {
          name = "Launch Current File (pwa-node with ts-node)",
          type = "pwa-node",
          request = "launch",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "node",
          runtimeArgs = { "--loader=/usr/local/lib/node_modules/ts-node/esm.mjs" },
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
  end
)

REQUIRE({ { type = 'npm', arg = 'svelte-language-server' } },
  function()
    require 'lspconfig'.svelte.setup {}
  end
)

REQUIRE({ { type = 'npm', arg = '@astrojs/language-server' } },
  function()
    require 'lspconfig'.astro.setup {}
  end
)

REQUIRE({ { type = 'npm', arg = '@vue/language-server' } },
  function()
    if not found 'node_modules/vue' then return end

    require 'lspconfig'.volar.setup {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
      on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
      end,
    }
  end
)

REQUIRE({
    { type = 'npm', arg = '@angular/language-server@16.1.4', cache_key = '@angular/language-server' }, -- for typescript >=4.8. @latest requires >=5.
    { type = 'npm', arg = '@angular/cli' }
  },
  function()
    if not found 'node_modules/@angular' then return end

    require 'lspconfig'.angularls.setup {
      on_new_config = function(new_config, new_root_dir)
        new_config.cmd = { "ngserver", "--stdio", "--tsProbeLocations", get_typescript_server_path(new_root_dir),
          "--ngProbeLocations", "/usr/local/lib/node_modules/@angular/language-server/bin" }
      end,
    }

    local ng = require "ng";
    K("<leader>at", ng.goto_template_for_component)
    K("<leader>ac", ng.goto_component_with_template_file)
    K("<leader>aT", ng.get_template_tcb)
  end
)

REQUIRE({ { type = 'npm', arg = 'cssmodules-language-server' } },
  function()
    require 'lspconfig'.cssmodules_ls.setup {
      on_attach = function(client)
        -- Disabling so not to conflict with other lsp's goToDef
        client.server_capabilities.definitionProvider = false
      end,
    }
  end
)

REQUIRE({ { type = 'npm', arg = '@tailwindcss/language-server' } },
  function()
    if not found 'node_modules/tailwindcss' then return end
    require 'lspconfig'.tailwindcss.setup {
      on_attach = function(client --[[ , bufnr ]])
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        --[[ require('tailwindcss-colors').buf_attach(_bufnr)  ]]
      end,

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
  end
)

REQUIRE({ { type = 'npm', arg = '@prisma/language-server' } },
  function()
    require 'lspconfig'.prismals.setup {}
  end
)

if found 'node_modules/.bin/relay-compiler' then
  require 'lspconfig'.relay_lsp.setup {
    -- (default: false) Whether or not we should automatically start
    -- the Relay Compiler in watch mode when you open a project
    auto_start_compiler = false,

    -- (default: null) Path to a relay config relative to the
    -- `root_dir`. Without this, the compiler will search for your
    -- config. This is helpful if your relay project is in a nested directory.
    path_to_config = nil,
  }
else
  REQUIRE({ { type = 'npm', arg = 'graphql-language-service-cli' } },
    function()
      require 'lspconfig'.graphql.setup {}
    end
  )
end

REQUIRE({ { type = 'npm', arg = 'vscode-langservers-extracted' } },
  function()
    require 'lspconfig'.html.setup {
      capabilities = capabilities,
    }
    require 'lspconfig'.cssls.setup {
      capabilities = capabilities,
    }
  end
)
