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

