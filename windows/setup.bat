REM winget install --id Git.Git -e --source winget

REM curl https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -O nvim-win64.zip
REM Expand-Archive .\nvim-win64.zip

REM git clone --depth 1 https://github.com/danieiff/dotfiles \
REM New-Item -Path $ENV:LOCALAPPDATA/nvim -ItemType SymbolicLink -Value dotfiles/nvim

{
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/NvChad/nvim-colorizer.lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  'https://github.com/mbbill/undotree',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua',

  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/pwntester/octo.nvim',

  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/RRethy/vim-illuminate',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/danieiff/nvim-ts-autotag',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/Wansmer/treesj',
  'https://github.com/ziontee113/syntax-tree-surfer',
  'https://github.com/folke/flash.nvim',
  'https://github.com/chrisgrieser/nvim-spider',

  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/lukas-reineke/cmp-rg',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/danieiff/friendly-snippets',
  'https://github.com/jackMort/ChatGPT.nvim',
  'https://github.com/danymat/neogen',

  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/ray-x/lsp_signature.nvim',
  'https://github.com/danieiff/lsp-lens.nvim',
  'https://github.com/simrat39/symbols-outline.nvim',

  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/nvim-neotest/neotest',

  'https://github.com/bennypowers/nvim-regexplainer',
  'https://github.com/pmizio/typescript-tools.nvim',
  'https://github.com/joeveiga/ng.nvim',
  'https://github.com/nvim-neotest/neotest-jest',
  'https://github.com/marilari88/neotest-vitest',

  'https://github.com/b0o/SchemaStore.nvim',
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
}

REM npm install -g tree-sitter-cli

REM curl https://github.com/jesseduffield/lazygit/releases/download/v0.40.2/lazygit_0.40.2_Windows_x86_64.zip -O lazygit.zip
REM Expand-Archive .\lazygit.zip

REM curl https://github.com/BurntSushi/ripgrep/releases/download/14.0.3/ripgrep-14.0.3-x86_64-pc-windows-gnu.zip -O ripgrep.zip
REM Expand-Archive .\ripgrep.zip
