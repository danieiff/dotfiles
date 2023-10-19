-- https://github.com/fatih/gomodifytags
-- https://github.com/yoheimuta/protolint
-- https://github.com/rhysd/actionlint

local efm_ls_dir = vim.fn.getenv 'HOME' .. '/.config/efm-langserver'
local efm_ls = efm_ls_dir .. '/efm-langserver'
if vim.fn.executable(efm_ls) == 0 then
  vim.schedule(function()
    vim.cmd(
      'tabnew | term mkdir -p ' ..
      efm_ls_dir ..
      [[ && cd $_ &&  curl "https://api.github.com/repos/mattn/efm-langserver/releases/latest" | grep -Po "(?<=browser_download_url\": \")https://[^\"]*" | fzf --reverse --bind "enter:execute( curl -L {} | tar xvz --strip-components=1 )+abort" ]]
    )
  end)
end
local languages = {
  go = {
    {
      prefix = 'golangci-lint',
      lintCommand = 'golangci-lint run --color never --out-format tab ${INPUT}',
      lintStdin = false,
      lintFormats = { '%.%#:%l:%c %m' },
      rootMarkers = {},
    }
  },
  gitcommit = {
    {
      lintCommand = 'gitlint --contrib contrib-title-conventional-commits',
      lintStdin = true,
      lintFormats = { '%l: %m: "%r"', '%l: %m', }
    }
  },
  php = {
    {
      -- https://github.com/phpstan/phpstan https://github.com/nunomaduro/larastan
      prefix = 'phpstan',
      lintSource = 'phpstan',
      lintCommand = './vendor/bin/phpstan analyse --no-progress --no-ansi --error-format=raw "${INPUT}"',
      lintStdin = false,
      lintFormats = { '%.%#:%l:%m' },
      rootMarkers = { 'phpstan.neon', 'phpstan.neon.dist', 'composer.json' },
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
    '.eslintrc.json',
    '.eslintrc.yaml',
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
  filetypes = vim.tbl_keys(languages)
}

AUC('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { 'grammarly-languageserver' }
    require 'lspconfig'.grammarly.setup { cmd = { "n", "run", "16", "/usr/local/bin/grammarly-languageserver", "--stdio" }, }
    vim.schedule(vim.cmd.edit)
  end
})

local lua_ls_dir = vim.fn.getenv 'HOME' .. "/.config/lua-language-server"
local lua_ls = lua_ls_dir .. "/bin/lua-language-server"
AUC('FileType', {
  pattern = 'lua',
  once = true,
  callback = function()
    require 'util'.ensure_pack_installed {
      {
        url = "https://github.com/folke/neodev.nvim",
        callback = function() require 'neodev'.setup() end
      }
    }

    if vim.fn.executable(lua_ls) == 0 then
      vim.schedule(function()
        vim.cmd('tabnew | term mkdir -p ' .. lua_ls_dir .. ' && cd "$_" && ghinstall LuaLS/lua-language-server')
      end)
    end

    ---@ Lsp

    function lua_lsp_start()
      vim.lsp.start({
        name = "lua-language-server",
        cmd = { lua_ls },
        before_init = require 'neodev.lsp'.before_init,
        root_dir = vim.fn.getcwd(),
        settings = { Lua = {} },
      })
    end

    AUC('FileType', { pattern = 'lua', callback = lua_lsp_start })
    lua_lsp_start()

    --[[ ---@ Dap
install local-lua-debugger-vscode, either via:

Your package manager
From source:
git clone https://github.com/tomblind/local-lua-debugger-vscode
cd local-lua-debugger-vscode
npm install
npm run build

 require 'dap'.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        "/absolute/path/to/local-lua-debugger-vscode/extension/debugAdapter.js"
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = "/absolute/path/to/local-lua-debugger-vscode/"
          on_config(c)
        else
          on_config(config)
        end
      end,
    }
    ]]
  end

})

local json_yaml_au = vim.api.nvim_create_augroup('JsonYamlAUG', {})
AUC('FileType', {
  pattern = { 'json', 'jsonc', 'yaml' },
  group = json_yaml_au,
  callback = function()
    vim.api.nvim_clear_autocmds({ group = json_yaml_au })

    -- require 'util'.ensure_pack_installed { { url = "https://github.com/b0o/SchemaStore.nvim" } }

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

    local yaml_ls = 'yaml-language-server'
    require 'util'.ensure_npm_deps { yaml_ls }
    require 'lspconfig'.yamlls.setup {
      on_attach = function()
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
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

    vim.cmd.edit()
  end
})

AUC('FileType', {
  pattern = 'dockerfile',
  once = true,
  callback = function()
    -- https://github.com/rcjsuen/dockerfile-language-server-nodejs
    require 'util'.ensure_npm_deps { 'dockerfile-language-server-nodejs' }
    require 'lspconfig'.dockerls.setup {}
    vim.schedule(vim.cmd.edit)
  end
})

AUC('FileType', {
  pattern = 'graphsql',
  once = true,
  callback = function()
    -- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli rquire 'util'.ensure_npm_deps { 'graphql-language-service-cli' }
    require 'lspconfig'.graphql.setup {}
  end
})

AUC('FileType', {
  pattern = { 'sql', 'mysql' },
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { 'sql-language-server' }
    require 'lspconfig'.sqlls.setup {}
    vim.schedule(vim.cmd.edit)
  end
})

AUC('FileType', {
  pattern = 'java',
  once = true,
  callback = function()
    require 'util'.ensure_pack_installed { { url = 'https://github.com/mfussenegger/nvim-jdtls' } }
    require 'nvim-jdtls'.setup {}

    -- git clone -- depth 1 https://github.com/microsoft/vscode-gradle
    --`./gradlew installDist` and point `cmd` to the `gradle-language-server`
    require 'lspconfig'.gradle_ls.setup { cmd = 'gradle-language-server' }
  end
})

AUC('FileType', {
  pattern = 'kotlin',
  once = true,
  callback = function()
    -- https://github.com/fwcd/kotlin-language-server
    require 'lspconfig'.kotlin_language_server.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      capabilities = capabilities,
    }
  end
})

AUC('FileType', {
  pattern = 'cs',
  once = true,
  callback = function()
    -- Install netcoredbg, either via:
    -- Your package manager
    -- Downloading it from the release page and extracting it to a folder
    -- Building from source by following the instructions in the netcoredbg repo.
    --  require 'dap'.adapters.coreclr = {
    --   type = 'executable',
    --   command = '/path/to/dotnet/netcoredbg/netcoredbg',
    --   args = {'--interpreter=vscode'}
    -- }
    -- require'dap'.configurations.cs = {
    --   {
    --     type = "coreclr",
    --     name = "launch - netcoredbg",
    --     request = "launch",
    --     program = function()
    --         return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    --     end,
    --   },
    -- }

    -- https://github.com/razzmatazz/csharp-language-server
    -- https://dotnet.microsoft.com/download
    -- require'lspconfig'.csharp_ls.setup{}

    -- unity

    -- Install vscode-unity-debug
    -- Install mono dependency if doesn't exist
    --
    -- require 'dap'.adapters.unity = {
    --   type = 'executable',
    --   command = '<path-to-mono-directory>/Commands/mono',
    --   args = {'<path-to-unity-debug-directory>/unity.unity-debug-x.x.x/bin/UnityDebug.exe'}
    -- }
    -- require 'dap'.configurations.cs = {
    --   {
    --   type = 'unity',
    --   request = 'attach',
    --   name = 'Unity Editor',
    --   }
    -- }

    -- https://github.com/Domeee/com.cloudedmountain.ide.neovim
    -- https://spaceandtim.es/code/nvim_unity_setup/
    -- https://dzfrias.dev/blog/neovim-unity-setup
    -- https://github.com/walcht/neovim-unity
  end
})

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

AUC('FileType', {
  pattern = 'dart',
  once = true,
  callback = function()
    -- https://www.reddit.com/r/neovim/comments/14c5e6o/how_to_set_up_dartflutter_with_neovim/
    -- require'lspconfig'.dartls.setup{}
    -- https://github.com/akinsho/flutter-tools.nvim

    -- See https://github.com/puremourning/vimspector/issues/4 for reference.
    --
    -- This installation might change over time as the debugger doesn't officially support being used as a standalone, but the maintainer is trying to be accomodating however the path to the executable or the variables might change in the future
    --
    -- ensure you have node installed
    --
    -- git clone Dart-Code (the debug adapter is not avaliable as a standalone)
    -- cd into the Dart-Code directory and run npx webpack --mode production
    -- this will create out/dist/debug.js which is the executable file
    -- NOTE: your flutterSdkPath might not be in ~/ this can vary depending on your installation method e.g. snap
    --
    --   require 'dap'.adapters.dart = {
    --     type = "executable",
    --     command = "node",
    --     args = {"<path-to-Dart-Code>/out/dist/debug.js", "flutter"}
    --   }
    --   require 'dap'.configurations.dart = {
    --     {
    --       type = "dart",
    --       request = "launch",
    --       name = "Launch flutter",
    --       dartSdkPath = os.getenv('HOME').."/flutter/bin/cache/dart-sdk/",
    --       flutterSdkPath = os.getenv('HOME').."/flutter",
    --       program = "${workspaceFolder}/lib/main.dart",
    --       cwd = "${workspaceFolder}",
    --     }
    --   }
  end
})

local c_aug = vim.api.nvim_create_augroup('CLspAUG', {})
AUC('FileType', {
  pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cmake' },
  group = c_aug,
  callback = function()
    vim.api.nvim_clear_autocmds { group = c_aug }

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
  pattern = 'php',
  once = true,
  callback = function()
    require 'util'.ensure_npm_deps { 'intelephense' }
    require 'lspconfig'.intelephense.setup {}

    -- git clone https://github.com/xdebug/vscode-php-debug.git
    -- cd vscode-php-debug
    -- npm install && npm run build
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

    vim.schedule(vim.cmd.edit)
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
    require 'util'.ensure_npm_deps { '@ignored/solidity-language-server' }
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
