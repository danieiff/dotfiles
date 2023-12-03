REQUIRE {
  deps = {
    -- https://github.com/fatih/gomodifytags
    -- https://github.com/yoheimuta/protolint
    -- https://github.com/rhysd/actionlint
    {
      type = 'bin',
      arg =
      [[ VERSION=$(curl -s https://api.github.com/repos/mattn/efm-langserver/releases/latest | grep -Po '"tag_name": "\K[^"]*') && curl -fsSL https://github.com/mattn/efm-langserver/releases/latest/download/efm-langserver_${VERSION}_linux_amd64.tar.gz | tar xz --strip-components=1 ]],
      executable = 'efm-langserver'
    },
    { type = 'npm', arg = '@fsouza/prettierd' },
    { type = 'npm', arg = 'cspell' },
  },
  cb = function(ls)
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
  ft = 'markdown',
  lsp_mode = true,
  deps = { { type = 'npm', arg = 'grammarly-languageserver' } },
  cb = function()
    local nvm_node_16 = ('%s/.nvm/versions/node/%s/bin/'):format(os.getenv 'HOME', 'v16.20.2')
    if vim.loop.fs_stat(nvm_node_16) then
      return {
        name = 'grammarly-languageserver',
        -- cmd = { 'n', 'exec', '16', 'grammarly-languageserver', '--stdio' },
        cmd = { nvm_node_16 .. 'node', nvm_node_16 .. 'grammarly-languageserver', '--stdio' },
        root_dir = vim.fn.getcwd(),
        handlers = { ['$/updateDocumentState'] = function() return '' end },
        init_options = { clientId = 'client_BaDkMgx4X19X9UxxYRCXZo' }, -- public clientId
      }
    end
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
  deps = { { type = 'npm', arg = 'yaml-language-server' } },
  cb = function()
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
  end
}

REQUIRE {
  ft = 'dockerfile',
  lsp_mode = true,
  deps = { { type = 'npm', arg = 'dockerfile-language-server-nodejs' } },
  cb = function()
    return {
      cmd = { 'docker-langserver', '--stdio' },
      root_dir = vim.fs.dirname(vim.fs.find('Dockerfile', { upward = true })[1])
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
  ft = { 'java', 'groovy' },
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
    vim.lsp.start {
      filetypes = { 'groovy' },
      root_dir = vim.fs.dirname(vim.fs.find({ 'settings.gradle', 'build.gradle' }, { upward = true })[1]),
      cmd = { DEPS_DIR.bin .. '/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server' },
      init_options = {
        settings = {
          gradleWrapperEnabled = true,
        }
      }
    }
  end
}

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

REQUIRE {
  ft = 'sh',
  lsp_mode = true,
  deps = { {
    type = 'bin',
    arg =
    'curl -fsSL https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.x86_64.tar.xz | tar xJv',
    executable = 'shellcheck-latest/shellcheck'
  }, {
    type = 'npm',
    arg = 'bash-language-server'
  }, {
    type = 'bin',
    arg =
    'curl -L https://github.com/rogalmic/vscode-bash-debug/releases/download/untagged-438733f35feb8659d939/bash-debug-0.3.9.vsix -o bash-debug.zip && unzip $_ -d bash-debug',
    executable = 'bash-debug/extension/out/bashDebug.js'
  } },
  cb = function(_, ls, db)
    local dap = require 'dap'

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
        pathBashdb = DEPS_DIR.bin .. '/bash-debug/extension/bashdb_dir/bashdb',
        pathBashdbLib = DEPS_DIR.bin .. '/bash-debug/extension/bashdb_dir',
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
    return { name = ls, cmd = { ls, 'start' } }
  end
}
