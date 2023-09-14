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

