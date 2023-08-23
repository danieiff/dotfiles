local extensions = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' }

---@ Deps

local packdir = vim.fn.stdpath 'config' .. '/pack/tett/start'

local npm_deps = { 'typescript', 'vscode-langservers-extracted', '@tailwindcss/language-server',
  '@styled/typescript-styled-plugin', 'typescript-styled-plugin' }

local language_server_repo = "https://github.com/pmizio/typescript-tools.nvim"
local language_server = vim.fn.fnamemodify(language_server_repo, ':t')
local debug_adapter_dir = vim.fn.stdpath 'config' .. '/js-debug'

AUC('FileType', {
  pattern = extensions,
  once = true,
  callback = function()
    if vim.tbl_get(vim.loop.fs_stat(packdir .. '/' .. language_server) or {}, 'type') ~= 'directory' then
      vim.fn.jobstart('git clone --depth 1 ' .. language_server_repo, {
        cwd = packdir,
        on_exit = function(_, code) if code ~= 0 then vim.print('Downloaded: ' .. language_server_repo) end end
      })
    end

    for _, d in ipairs(npm_deps) do
      if not vim.fn.system('npm -g list -p'):find(d:gsub('-', '%%-') .. '\n') then
        vim.fn.jobstart('npm i -g ' .. d,
          { on_exit = function(_, code) if code == 0 then vim.print('Downloaded: ' .. d) end end })
      end
    end

    if vim.tbl_get(vim.loop.fs_stat(debug_adapter_dir) or {}, 'type') ~= 'directory' then
      vim.cmd 'botright sp +enew'
      vim.fn.termopen('ghinstall microsoft/vscode-js-debug',
        { on_exit = function() vim.defer_fn(function() vim.api.nvim_buf_delete(0, { force = true }) end, 2000) end })
    end
  end
})

---@ Lsp

require 'typescript-tools'.setup {
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
    -- tsserver_plugins = { "@styled/typescript-styled-plugin" }
  },

}

require 'lspconfig'.tailwindcss.setup {
  on_attach = function(_, _ --[[ buffer ]]) --[[ require('tailwindcss-colors').buf_attach(_bufnr)  ]] end,
  handlers = {
    ['tailwindcss/getConfiguration'] = function(_, _, params, _, bufnr, _)
      -- tailwindcss lang server wai swap = {
      vim.lsp.buf_notify(bufnr, 'tailwindcss/getConfigurationResponse', { _id = params._id })
    end
  },
  capabilities

}

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
