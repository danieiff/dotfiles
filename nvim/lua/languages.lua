REQUIRE {
  deps = {
    {
      type = 'bin',
      arg =
      [[ VERSION=$(curl -s https://api.github.com/repos/mattn/efm-langserver/releases/latest | grep -Po '"tag_name": "\K[^"]*') && curl -fsSL https://github.com/mattn/efm-langserver/releases/latest/download/efm-langserver_${VERSION}_linux_amd64.tar.gz | tar xz --strip-components=1 ]],
      executable = 'efm-langserver'
    },
    { type = 'npm', arg = 'cspell' },
  },
  cb = function(ls)
    local languages = {
      php = {
        {
          -- https://github.com/phpstan/phpstan https://github.com/nunomaduro/larastan
          prefix = 'phpstan',
          lintSource = 'phpstan',
          lintCommand =
          './vendor/bin/phpstan analyse --no-progress --no-ansi --error-format=raw "${INPUT}"',
          lintStdin = false,
          lintFormats = { '%.%#:%l:%m' },
          rootMarkers = { 'phpstan.neon', 'phpstan.neon.dist', 'composer.json' },
        }
      },
      ['='] = {
        {
          lintSource = 'cspell',
          lintCommand = 'cspell --no-color --no-progress --no-summary "${INPUT}"',
          lintIgnoreExitCode = true,
          lintStdin = false,
          lintFormats = { '%f:%l:%c - Unknown word (%m)' --[[ , '%f:%l:%c %m' ]] },
          lintSeverity = vim.diagnostic.severity.INFO,
        }
      }
    }
    local prettier = {
      formatCanRange = true,
      formatCommand =
      "prettierd '${INPUT}' ${--tab-width=tabSize} ${--use-tabs=!insertSpaces} ${--range-start=charStart} ${--range-end=charEnd}",
      -- "./node_modules/.bin/prettier --stdin --stdin-filepath '${INPUT}' ${--range-start:charStart} ${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}",
      formatStdin = true,
      rootMarkers = {
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.js',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.json5',
        '.prettierrc.mjs',
        '.prettierrc.cjs',
        '.prettierrc.toml',
        'package.json',
      },
    }
    local eslint = {
      prefix = 'eslint',
      lintCommand = './node_modules/.bin/eslint --no-color --format visualstudio --stdin-filename ${INPUT} --stdin',
      lintStdin = true,
      lintFormats = { '%f(%l,%c): %trror %m', '%f(%l,%c): %tarning %m' },
      lintIgnoreExitCode = true,
      rootMarkers = {
        '.eslintrc',
        '.eslintrc.cjs',
        '.eslintrc.js',
        '.eslintrc.yaml',
        '.eslintrc.json',
        '.eslintrc.yml',
        'package.json',
      },
    }
    local stylelint = {
      prefix = 'stylelint',
      lintCommand = './node_modules/.bin/stylelint --no-color --formatter compact --stdin --stdin-filename ${INPUT}',
      lintStdin = true,
      lintFormats = { '%.%#: line %l, col %c, %trror - %m', '%.%#: line %l, col %c, %tarning - %m' },
      -- rootMarkers = { '.stylelintrc' },
    }
    local exts_js = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'astro' }
    for _, ext in ipairs(exts_js) do languages[ext] = { prettier, eslint } end
    local exts_prettier = { 'html', 'json', 'jsonc', 'yaml', 'markdown' }
    for _, ext in ipairs(exts_prettier) do languages[ext] = { prettier } end
    local exts_css = { "css", "scss", "less", "sass" }
    for _, ext in ipairs(exts_css) do languages[ext] = { prettier, stylelint } end

    require 'lspconfig'.efm.setup {
      cmd = { ls },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        -- documentSymbol = true,
        codeAction = true,
        completion = true
      },
      settings = {
        rootMarkers = { ".git/" },
        languages = languages,
      },
      filetypes = { '*' }
    }
  end
}

REQUIRE {
  ft = 'lua',
  lsp_mode = true,
  deps = {
    {
      type = 'bin',
      arg =
      [[mkdir lua-language-server && cd $_ && VERSION=$(curl -s https://api.github.com/repos/LuaLS/lua-language-server/releases/latest | grep -Po '"tag_name": "\K[^"]*') && curl -fsSL https://github.com/LuaLS/lua-language-server/releases/download/${VERSION}/lua-language-server-${VERSION}-linux-x64.tar.gz | tar xz]],
      executable = 'lua-language-server/bin/lua-language-server'
    } },
  cb = function(ls)
    local capa = vim.lsp.protocol.make_client_capabilities()
    capa.textDocument.formatting = true
    capa.textDocument.rangeFormatting = true
    return {
      cmd = { ls },
      capabilities = capa,
      root_dir = vim.fn.getcwd(),
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
          }
        }
      }
    }
  end
}

REQUIRE {
  deps = { { type = 'npm', arg = 'vscode-langservers-extracted' } },
  cb = function()
    local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
    jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- print(vim.inspect(jsonls_capabilities.textDocument.completion))
    -- print(vim.inspect(capabilities))
    -- print(vim.tbl_deep_extend('error',jsonls_capabilities, capabilities))
    require 'lspconfig'.jsonls.setup {
      capabilities = jsonls_capabilities, --vim.tbl_deep_extend('error',jsonls_capabilities, capabilities),
      settings = {
        json = {
          schemas = require 'schemastore'.json.schemas(),
          validate = { enable = true }
        }
      }
    }
  end
}

REQUIRE {
  ft = { 'sql', 'mysql' },
  lsp_mode = true,
  deps = { { type = 'npm', arg = 'sql-language-server' } },
  cb = function()
    return {
      cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
      root_dir = vim.fs.dirname(vim.fs.find('.sqllsrc.json', { upward = true })[1])
    }
  end
}

REQUIRE {
  ft = 'php',
  deps = {
    { type = 'bin',
      arg = [[REPO=xdebug/vscode-php-debug && VERSION=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep -Po '"tag_name": "v\K[^"]*') && curl -L https://github.com/$REPO/releases/download/v$VERSION/php-debug-$VERSION.vsix -o php-debug.zip && unzip $_ -d php-debug]],
      executable = 'php-debug/extension/out/phpDebug.js'
    },
    { type = 'npm', arg = 'intelephense' }
  },
  cb = function()
    require 'dap'.adapters.php = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath 'config' .. '/vscode-php-debug/out/phpDebug.js' }
    }
    require 'dap'.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        pathMappings = {
          ["/var/www/html"] = vim.fn.getcwd()
        }
      }
    }
    return {
      cmd = { 'intelephense', '--stdio' },
      root_dir = vim.fs.dirname(vim.fs.find({ 'composer.json', '.git' }, { upward = true })[1])
    }
  end
}

REQUIRE {
  ft = 'java',
  deps = {
    -- sudo apt install openjdk-17-jdk
    -- sudo update-alternatives --config java
    -- mkdir ~/.config/nvim/jdtls && cd $_ && curl -L https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz | tar xz
    'https://github.com/mfussenegger/nvim-jdtls'
    -- cd ~/.config/nvim && git clone --depth 1 https://github.com/microsoft/vscode-gradle && cd vscode-gradle && ./gradlew installDist
  },
  cb = function()
    require 'jdtls'.start_or_attach({
      cmd = { DEPS_DIR.bin .. '/jdtls/bin/jdtls' },
      root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1])
    })
  end
}

AUC('FileType', {
  pattern = 'python',
  once = true,
  callback = function()
    require 'lspconfig'.sourcery.setup {
      init_options = {
        token = 'user_MpPgD1Sf27NtUyZbBR3zwwc4qJ87f3a7JtWPjYoTZPKDXgAZWbk_m6QkJ6k',
        extension_version = 'vim.lsp',
        editor_version = 'vim',
      },
    }

    -- https://github.com/mtshiba/pylyzer
    -- pip install pylyzer
    require 'lspconfig'.pylyzer.setup {}

    -- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
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
    vim.cmd.edit()
  end
})

local extensions = { 'typescript', 'javascript', 'angular' }

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

local cwd, global_node_modules = vim.loop.cwd(), vim.fn.system 'which npm':gsub('/bin/npm\n', '/lib/node_modules')
local function found(module_specific_path)
  return util.search_ancestors(cwd,
    function(path) return vim.loop.fs_stat(vim.fs.joinpath(path, module_specific_path)) end)
end

REQUIRE {
  deps = {
    { type = 'npm', arg = 'typescript' },
    { type = 'npm', arg = 'ts-node' },
    {
      type = 'bin',
      arg =
      [[ VERSION=$(curl -s https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest | grep -Po '"tag_name": "\K[^"]*') && curl -fsSL https://github.com/microsoft/vscode-js-debug/releases/latest/download/js-debug-dap-${VERSION}.tar.gz | tar xz ]],
      executable = 'js-debug/src/dapDebugServer.js'
    }
  },
  cb = function(_, _, db)
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
}

REQUIRE {
  deps = {
    { type = 'npm', arg = '@angular/language-server@16.1.4', cache_key = '@angular/language-server' }, -- for typescript >=4.8. @latest requires >=5.
    { type = 'npm', arg = '@angular/cli' }
  },
  cb = function()
    if not found 'node_modules/@angular' then return end

    require 'lspconfig'.angularls.setup {
      on_new_config = function(new_config, new_root_dir)
        new_config.cmd = { "ngserver", "--stdio", "--tsProbeLocations", get_typescript_server_path(new_root_dir),
          "--ngProbeLocations", global_node_modules .. "/@angular/language-server/bin" }
      end,
    }

    local ng = require "ng";
    K("<leader>at", ng.goto_template_for_component)
    K("<leader>ac", ng.goto_component_with_template_file)
    K("<leader>aT", ng.get_template_tcb)
  end
}

REQUIRE {
  deps = { { type = 'npm', arg = 'vscode-langservers-extracted' } },
  cb = function()
    require 'lspconfig'.html.setup {
      capabilities = capabilities,
    }
    require 'lspconfig'.cssls.setup {
      capabilities = capabilities,
    }
  end
}
