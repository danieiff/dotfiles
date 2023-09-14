local dap = require 'dap'

if not vim.fn.executable 'efm-langserver' then vim.fn.startjob('go install github.com/mattn/efm-langserver@latest') end
local languages = {
  gitcommit = {
    {
      lintCommand = 'gitlint --contrib contrib-title-conventional-commits',
      lintStdin = true,
      lintFormats = { '%l: %m: "%r"', '%l: %m', }
    }
  }
}
local prettier = {
  formatCanRange = true,
  formatCommand =
  'prettierd ${INPUT} ${--tab-width:tabWidth} ${--use-tabs:insertSpaces} ${--range-start=charStart} ${--range-start=charEnd}',
  -- './node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT} ${--range-start:charStart} ${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}',

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
local exts_js = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte', 'astro' }
for _, ext in ipairs(exts_js) do languages[ext] = { prettier, eslint } end
local exts_prettier = { 'html', 'json', 'jsonc', 'yaml', 'markdown' }
for _, ext in ipairs(exts_prettier) do languages[ext] = { prettier } end



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
}

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

    ---@ Lsp

    function lua_lsp_start()
      vim.lsp.start({
        name = "lua-language-server",
        cmd = { "lua-language-server" },
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

    dap.adapters["local-lua"] = {
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

