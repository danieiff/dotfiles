local exts_js = { 'javascript', 'typescript' }

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
}

local extensions = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'astro',
  'angular' }

local capabilities = require 'blink.cmp'.get_lsp_capabilities()

local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  local global_ts, found_ts = os.getenv 'HOME' .. '/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js', ''
  local function check_dir(path)
    found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js')
    if util.path.exists(found_ts) then return path end
  end
  return util.search_ancestors(root_dir, check_dir) and found_ts or global_ts
end

local cwd, global_node_modules = vim.loop.cwd(), vim.fn.system 'which npm':gsub('/bin/npm\n', '/lib/node_modules')
local function found(module_specific_path)
  return util.search_ancestors(cwd,
    function(path) return vim.loop.fs_stat(vim.fs.joinpath(path, module_specific_path)) end)
end

if found 'deno.json' then
  vim.g.markdown_fenced_languages = { "ts=typescript" }
  require 'lspconfig'.denols.setup {}
else
  if vim.api.nvim_buf_get_name(0) ~= '' then
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
end

local dap = require 'dap'

local db = ''
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
      url = function() return 'http://localhost:' .. vim.fn.input("Select port: ", '8080') end,
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

require 'lspconfig'.svelte.setup {}

require 'lspconfig'.astro.setup {}

require 'lspconfig'.volar.setup {
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
  end,
}


require 'lspconfig'.cssmodules_ls.setup {}

require 'lspconfig'.prismals.setup {}

-- REQUIRE {
--   ft = { "graphql", "typescriptreact", "javascriptreact" },
--   deps = { { type = 'npm', arg = 'graphql-language-service-cli' } },
--   cb = function()
--     if found 'node_modules/.bin/relay-compiler' then
--       require 'lspconfig'.relay_lsp.setup {
--         -- (default: false) Whether or not we should automatically start
--         -- the Relay Compiler in watch mode when you open a project
--         auto_start_compiler = false,
--
--         -- (default: null) Path to a relay config relative to the
--         -- `root_dir`. Without this, the compiler will search for your
--         -- config. This is helpful if your relay project is in a nested directory.
--         path_to_config = nil,
--       }
--     else
--       return {
--         cmd = { "graphql-lsp", "server", "-m", "stream" },
--         root_dir = vim.fs.dirname(vim.fs.find({ '.git', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*' },
--           { upward = true })[1])
--       }
--     end
--   end
-- }



vim.tbl_extend('error', require 'lint'.linters_by_ft,
  { javascript = { 'eslint' }, javascriptreact = { 'eslint' }, typescript = { 'eslint' }, typescriptreact = { 'eslint' } })

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

-- curl -sL "https://github.com/microsoft/vscode-js-debug/releases/download/v1.93.0/js-debug-dap-v1.93.0.tar.gz" | tar xvzf - -C vim.fn.stdpath'data'
-- for /f "tokens=5" %a in ('netstat -ano ^| findstr "LISTENING" ^| findstr ":8123"') do @taskkill /F /PID %a
dap.adapters['pwa-node'] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = { command = "node", args = { vim.fn.stdpath 'data' .. '/js-debug/src/dapDebugServer.js' } }
  -- port = "${port}",
  -- executable = { command = "node", args = { vim.fn.stdpath'data' .. '/js-debug/src/dapDebugServer.js', '${port}' } }
}

dap.adapters['pwa-chrome'] = {
  type = 'server',
  port = '${port}',
  executable = { command = "node", args = { vim.fn.stdpath 'data' .. '/js-debug/src/dapDebugServer.js', '${port}' } }
}
-- git clone --depth 1 https://github.com/Microsoft/vscode-chrome-debug && npm i && npm run build
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { vim.fn.stdpath 'data' .. "/vscode-chrome-debug/out/src/chromeDebug.js" }
}

for _, ext in ipairs(exts_js) do
  dap.configurations[ext] = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      cwd = "${workspaceFolder}",
      program = "${file}",
      outFiles = { [[${workspaceFolder}\dist\**\*.js]], [[!**\node_modules\**]] },
      resolveSourceMapLocations = { [[${workspaceFolder}\**]], [[!**\node_modules\**]] },
      trace = true,
    },
    {
      name = "Launch Current File (pwa-node with ts-node)",
      type = "pwa-node",
      request = "launch",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      runtimeArgs = { [[--loader=\usr\local\lib\node_modules\ts-node\esm.mjs]] },
      args = { "${file}" },
      skipFiles = { [[<node_internals>\**]], [[node_modules\**]] },
      resolveSourceMapLocations = { [[${workspaceFolder}\**]], [[!**\node_modules\**]] },
    },
    {
      name = "Debug Jest Tests",
      type = "pwa-node",
      request = "launch",
      runtimeExecutable = "node",
      runtimeArgs = { [[.\node_modules\jest\bin\jest.js]] }, -- "--runInBand" },
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
    {
      name = "Attach Program (pwa-node, select pid)",
      type = "pwa-node",
      request = "attach",
      processId = require 'dap.utils'.pick_process,
      skipFiles = { [[<node_internals>\**]] },
      -- restart = true, -- https:\\code.visualstudio.com\docs\nodejs\nodejs-debugging#_restarting-debug-sessions-automatically-when-source-is-edited use with nodemon
    },
    {
      name = 'Attach server',
      type = 'pwa-node',
      request = 'attach',
      port = function() return vim.fn.input('port: ', '7701') end,
      skipFiles = { '<node_internals>/**', 'node_modules/**' },
      cwd = '${workspaceFolder}',
    },
    {
      name = 'vscode-js-debug:Launch chrome',
      type = "pwa-chrome",
      request = "launch",
      url = function() return vim.fn.input('url: ', 'http://localhost:4200') end,
      sourceMaps = true,
      webRoot = "${workspaceFolder}",
    },
    {
      name = 'vscode-chrome-debug: Launch chrome',
      type = 'chrome',
      request = 'launch',
      url = function() return vim.fn.input('url: ', 'http://localhost:4200') end,
      webRoot = '${workspaceFolder}',
    }
  }
end

AUC('FileType', {
  pattern = { 'typescript', 'html' },
  callback = function(ev)
    local angular_root_dir = vim.fs.root(ev.buf, 'angular.json')
    if angular_root_dir then
      local cliend_id = assert(vim.lsp.start {
        name = 'ng-ls',
        root_dir = angular_root_dir,
        --cmd = { 'node',  [[angular.ng-template-14.0.0\server\index.js]], "--stdio", "--tsProbeLocations", 'node_modules', '--ngProbeLocations', 'node_modules' },
        cmd = { 'node', [[\Users\sugimoto-hi\AppData\Roaming\nvm\v16.20.2\node_modules\@angular\language-server\index.js]], '--stdio', '--tsProbeLocations', 'node_modules', '--ngProbeLocations', 'node_modules' },
      }, 'Should start angular language server')

      local client = assert(vim.lsp.get_client_by_id(cliend_id), 'Should get angular language server')

      K("<leader>aa", function()
        local command = vim.bo.ft == 'html' and 'angular/getComponentsWithTemplateFile' or
            vim.bo.ft == 'typescript' and 'angular/getTemplateLocationForComponent' or ''
        client.request(command, vim.lsp.util.make_position_params(0, 'utf-8'),
          function(_, result) vim.lsp.util.show_document(#result and result[1] or result, 'utf-8') end, 0)
      end)

      local buffer, _uri, ns
      K("<leader>aT", function()
        client.request('angular/getTcb', vim.lsp.util.make_position_params(0, 'utf-8'), function(_, result)
          local uri, content, ranges = result.uri, result.content, result.selections

          if not buffer or not vim.api.nvim_buf_is_loaded(buffer) then
            buffer = vim.api.nvim_create_buf(false, true)
            vim.bo[buffer].buftype = 'nofile'
            ns = vim.api.nvim_create_namespace 'ng'
          end

          uri = tostring(uri):gsub('file:///', 'ng:///')
          if _uri ~= uri then
            _uri = uri
            vim.api.nvim_buf_set_name(buffer, _uri)
            vim.bo[buffer].filetype = 'typescript'
          end

          vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.fn.split(content, '\n'))
          vim.bo[buffer].modified = false

          vim.cmd.tabnew(_uri)
          if ranges and #ranges ~= 0 then
            for _, range in ipairs(ranges) do
              vim.highlight.range(
                buffer,
                ns,
                'Visual',
                { range.start.line, range.start.character },
                { range['end'].line, range['end'].character }
              )
            end

            vim.api.nvim_win_set_cursor(0, { ranges[1].start.line + 1, ranges[1].start.character })
          end
        end, 0)
      end)
    end
  end
})
