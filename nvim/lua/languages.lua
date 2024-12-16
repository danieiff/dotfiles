local dap = require 'dap'
require 'mason'.setup {}

AUC('FileType', { pattern = { 'json', 'jsonc', 'yaml', 'python', 'c', 'cpp', 'java', 'go' }, command = 'set tabstop=4' })

-- https://github.com/fatih/gomodifytags
-- https://github.com/yoheimuta/protolint
-- https://github.com/rhysd/actionlint

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

require 'lspconfig'.yamlls.setup {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = require 'schemastore'.yaml.schemas(),
      -- To use a schema for validation, there are two options:
      -- 1. Add a modeline to the file. A modeline is a comment of the form:
      -- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
      -- or add here:
      -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
      -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      --   ["../path/relative/to/file.yml"] = "/.github/workflows/*",
      --   ["/path/from/root/of/project"] = "/.github/workflows/*",

    },
  },
}

-- {
--   cmd = { 'docker-langserver', '--stdio' },
--   root_dir = vim.fs.dirname(vim.fs.find('Dockerfile', { upward = true })[1])
-- }
--
-- {
--   cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
--   root_dir = vim.fs.dirname(vim.fs.find('.sqllsrc.json', { upward = true })[1])
-- }

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

-- https://github.com/scalameta/nvim-metals

AUC('FileType', {
  pattern = { 'c', 'cmake' },
  once = true,
  callback = function()
    require 'lspconfig'.ccls.setup {
      init_options = {
        -- https://github.com/MaskRay/ccls/wiki/Customization#initialization-options
        compilationDatabaseDirectory = ".",
        index = {
          threads = 0,
        },
        clang = {
          excludeArgs = { "-frounding-math" },
        },
      }
    }

    if vim.fn.executable 'neocmakelsp' == 0 then
      vim.fn.jobstart 'cargo install neocmakelsp'
    end
    require 'lspconfig'.neocmake.setup {}

    vim.cmd.edit()
  end
})

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

    -- https://github.com/alexpasmantier/pymple.nvim

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

AUC('FileType', {
  pattern = 'solidity',
  once = true,
  callback = function()
    -- https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md
    --require 'util'.ensure_npm_deps { '@ignored/solidity-language-server' }
    require 'lspconfig'.solidity_ls_nomicfoundation.setup {}
    vim.cmd.edit()
  end
})

--[[
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

-- rust/c/c++
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
-- https://github.com/Microsoft/vscode-cpptools
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-symbols-in-various-languages-and-build-systems


-- Godot GDScript

require 'dap'.adapters.godot = {
  type = "server",
  host = '127.0.0.1',
  port = 6006,
}
-- The port must match the Godot setting. Go to Editor -> Editor Settings, then find Debug Adapter under Network:
dap.configurations.gdscript = {
  {
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = "${workspaceFolder}",
    launch_scene = true,
  }
}
]]

dap.adapters.bashdb = {
  type = 'executable',
  name = 'bashdb',
  command = 'node',
  args = { db }
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
require("dap-ruby").setup() -- gem install rdbg rspec


--[[
https://github.com/akinsho/flutter-tools.nvim
require 'flutter-tools'.setup {
  debugger = {
    enabled = true,
    register_configurations = function(_)
      if vim.loop.fs_stat(vim.fn.getcwd() .. '/.vscode/launch.json') then
        require("dap").configurations.dart = {}
        require("dap.ext.vscode").load_launchjs()
      end
    end,
  },
}
require("telescope").load_extension("flutter")
]]

local function get_root_dir(mark)
  return vim.fs.dirname(vim.fs.find(mark, {
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    upward = true
  })[1])
end

local exts_js = { 'javascript', 'typescript' }

local capabilities = require 'blink.cmp'.get_lsp_capabilities()

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
}

AUC('FileType', {
  pattern = 'lua',
  callback = function()
    vim.lsp.start {
      root_dir = vim.fs.root(0, '.git'),
      name = 'lua-language-server',
      cmd = { 'lua-language-server' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
          }
        },
        capabilities = capabilities
      },
    }
  end
})

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
AUC('FileType', {
  pattern = 'php',
  callback = function()
    local root = assert(get_root_dir { 'composer.json', '.git' }, 'No root for php')
    vim.lsp.start {
      name = 'intelephense',
      root_dir = root,
      cmd = { 'node', 'bmewburn.vscode-intelephense-client-1.10.4/node_modules/intelephense/lib/intelephense.js', '--stdio' },
      settings = {
        intelephense = {
          environment = {
            includePaths = {
              '/ZendFramework-1.12.5',
              '/Smarty',
            }
          }
        }
      }
    }
  end
})

AUC('FileType', {
  pattern = 'python',
  callback = function()
    -- https:\\github.com\mtshiba\pylyzer
    -- pip install pylyzer
    require 'lspconfig'.pylyzer.setup {}

    -- https:\\github.com\python-lsp\python-lsp-server\blob\develop\CONFIGURATION.md
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
  end
})

-- AUC('FileType', {
--   pattern = exts_js,
--   callback = function()
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
--   end
-- })

-- curl -sL "https://github.com/microsoft/vscode-js-debug/releases/download/v1.93.0/js-debug-dap-v1.93.0.tar.gz" | tar xvzf - -C NVIM_DATA
-- for /f "tokens=5" %a in ('netstat -ano ^| findstr "LISTENING" ^| findstr ":8123"') do @taskkill /F /PID %a
dap.adapters['pwa-node'] = {
  type = "server",
  host = "127.0.0.1",
  port = 8123,
  executable = { command = "node", args = { NVIM_DATA .. '/js-debug/src/dapDebugServer.js' } }
  -- port = "${port}",
  -- executable = { command = "node", args = { NVIM_DATA .. '/js-debug/src/dapDebugServer.js', '${port}' } }
}

dap.adapters['pwa-chrome'] = {
  type = 'server',
  port = '${port}',
  executable = { command = "node", args = { NVIM_DATA .. '/js-debug/src/dapDebugServer.js', '${port}' } }
}
-- git clone --depth 1 https://github.com/Microsoft/vscode-chrome-debug && npm i && npm run build
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { NVIM_DATA .. "/vscode-chrome-debug/out/src/chromeDebug.js" }
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
    local angular_root_dir = get_root_dir 'angular.json'
    if angular_root_dir then
      local cliend_id = vim.lsp.start {
        name = 'ng-ls',
        root_dir = get_root_dir 'angular.json',
        --cmd = { 'node',  [[angular.ng-template-14.0.0\server\index.js]], "--stdio", "--tsProbeLocations", 'node_modules', '--ngProbeLocations', 'node_modules' },
        cmd = { 'node', [[\Users\sugimoto-hi\AppData\Roaming\nvm\v16.20.2\node_modules\@angular\language-server\index.js]], '--stdio', '--tsProbeLocations', 'node_modules', '--ngProbeLocations', 'node_modules' },
      }

      local client = assert(vim.lsp.get_client_by_id(cliend_id), 'Not found lsp client for angular')

      K("<leader>aa", function()
        local command = vim.bo.ft == 'html' and 'angular/getComponentsWithTemplateFile' or
            vim.bo.ft == 'typescript' and 'angular/getTemplateLocationForComponent' or ''
        client.request(command, vim.lsp.util.make_position_params(0),
          function(_, result) vim.lsp.util.jump_to_location(#result and result[1] or result, 'utf-8') end, 0)
      end)

      local buffer, _uri, ns
      K("<leader>aT", function()
        client.request('angular/getTcb', vim.lsp.util.make_position_params(0), function(_, result)
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


vim.uv.os_setenv('JAVA_HOME', [[\pleiades-v4.5\java\8]])
vim.uv.os_setenv('CATALINA_HOME', [[\tomcat\apache-tomcat-8.5.28]])
vim.uv.os_setenv('TOMCAT_HOME', [[\tomcat\apache-tomcat-8.5.28]])

AUC('FileType', {
  pattern = { 'java' },
  callback = function(ev)
    local java_root_dir = get_root_dir { '.git', 'mvnw', 'gradlew' } -- Neovim 0.10: vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
    local config = {                                                 -- https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      cmd = {
        [[\Program Files\Java\jdk-17\bin\java]],                     -- winget install --id=Oracle.JDK.17 -e
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx2g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', [[\jdtls\plugins\org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar]],

        '-configuration', [[\jdtls\config_win]],
        '-data', NVIM_DATA .. '/jdtls-data/java_root_dir' -- MUST NOT be in workspace itself
      },
      root_dir = java_root_dir,

      -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      settings = {
        java = {
          project = {
            referencedLibraries = {
            },
          },
          configuration = {
            runtimes = {
              {
                name = 'JavaSE-1.8',
                path = [[\pleiades-v4.5\java\8\jre]],
                default = true
              }
            }
          }
        }
      },

      -- Language server `initializationOptions`
      -- You need to extend the `bundles` with paths to jar files if you want to use additional eclipse.jdt.ls plugins.
      -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
      -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
      init_options = {
        bundles = {},
      },
    }
    require 'jdtls'.start_or_attach(config)
  end
})

AUC('FileType', {
  pattern = { 'sql', 'mysql' },
  callback = function()
    -- https://github.com/nanotee/sqls.nvim/
    -- curl -L "https://github.com/sqls-server/sqls/releases/download/v0.2.27/sqls-windows-0.2.27.zip" -o temp-sqls.zip && unzip temp-sqls.zip -d NVIM_DATA && rm temp-sqls.zip
    -- https://github.com/sqls-server/sqls
    vim.lsp.start {
      cmd = { NVIM_DATA .. '/sqls' },
      filetypes = { 'sql', 'mysql' },
      root_dir = get_root_dir 'config.yml',
      settings = {},
    }
  end
})
