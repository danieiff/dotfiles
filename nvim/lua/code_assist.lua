K('<cr>', '<cmd>call append(expand("."), "")<cr>j')
K('<bs>', '<cmd>call append(line(".")-1, "")<cr>k')

K('<leader>tt', function()
  local cword = vim.fn.expand '<cword>'
  for a, b in pairs { ['true'] = 'false', ['enabled'] = 'disabled' } do
    local change = cword == a and b or cword == b and a
    if change then return vim.cmd('normal ciw' .. change) end
  end
  local sub_pair = cword:find('_') and
      { [[\v_(.)]], [[\u\1]] } or
      { [[\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)]], [[\l\1_\l\2]] }
  vim.cmd('normal ciw' .. vim.fn.substitute(cword, sub_pair[1], sub_pair[2], 'g'))
end)

local _get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option) ---@diagnostic disable-line: duplicate-set-field
  if option ~= "commentstring" then return _get_option(filetype, option) end

  local comment_config = {
    javascript = '/* %s */',
    javascriptreact = '/* %s */',
    typescript = '/* %s */',
    typescriptreact = '/* %s */',
    tsx = {
      jsx_element = '{/* %s */}',
      jsx_fragment = '{/* %s */}',
      jsx_expression = '/* %s */'
    },
  }

  local row, col = vim.api.nvim_win_get_cursor(0)[1] - 1, vim.fn.match(vim.fn.getline '.', '\\S')
  if vim.fn.mode():lower() == 'v' then
    row, col = vim.fn.getpos("'<")[2] - 1, vim.fn.match(vim.fn.getline '.', '\\S')
  end

  local language_tree = vim.treesitter.get_parser()
  if not language_tree then return _get_option(filetype, option) end
  local language_commentstring = comment_config[language_tree:lang()]
  if not language_commentstring then return _get_option(filetype, option) end

  local function check_node(node)
    return node and (language_commentstring[node:type()] or check_node(node:parent()))
  end

  return check_node(language_tree:named_node_for_range { row, col, row, col }) or
      comment_config[filetype] or _get_option(filetype, option)
end

-- TODO: AI code doc comment writing
require 'neogen'.setup {}
K('<leader>doc', ':Neogen ', { desc = 'arg: func|class|type' })

require 'timber'.setup {}

require 'nvim-surround'.setup { keymaps = { visual = '<C-s>' } }
require 'nvim-ts-autotag'.setup { enable_close_on_slash = false, }
require 'nvim-autopairs'.setup { disable_in_visualblock = true, fast_wrap = { map = '<C-]>' } } -- <C-h> deletes '(' only

require 'blink.cmp'.setup {
  keymap = { preset = 'super-tab' }, -- TODO: <Tab> doesn't accept completion on snippet placeholder
  sources = {
    providers = {
      snippets = { opts = { search_paths = { '.vscode/' } } }, -- TODO: recognize .vscode/{language}.code-snippets
    },
  },
  appearance = {
    -- Sets the fallback highlight groups to nvim-cmp's highlight groups
    -- Useful for when your theme doesn't support blink.cmp
    use_nvim_cmp_as_default = true,
  },
  completion = {
    documentation = { auto_show = true }
  },
  signature = { enabled = true }
}

local neocodeium = require 'neocodeium'
neocodeium.setup()
K("<c-y>", neocodeium.accept, { mode = { "i" } })
K("<c-u>", neocodeium.accept_word, { mode = { "i" } })
K("<c-i>", neocodeium.accept_line, { mode = { "i" } })
K("<c-j>", neocodeium.cycle_or_complete, { mode = { "i" } })
K("<c-k>", function() neocodeium.cycle_or_complete(-1) end, { mode = { "i" } })
K("<c-q>", neocodeium.clear, { mode = { "i" } })

require 'avante_lib'.load()
require 'avante'.setup {
  provider = 'openai', openai = { model = 'gpt-4o-mini' }
}
