K('(', '<cmd>exe "tabp" . v:count1<cr>')
K(')', function()
  if vim.v.count == 0 then
    vim.cmd 'tabn'
  else
    local tabpages = vim.api.nvim_list_tabpages()
    vim.api.nvim_set_current_tabpage(tabpages[(vim.v.count - 1) % #tabpages + 1])
  end
end)
K('<leader><tab>', require 'fzf-lua'.tabs)

require 'leap'.create_default_mappings()
K('s', '<Plug>(leap)')
K('gS', require 'leap.remote'.action, { mode = { 'n', 'o' } })
K('S', require 'leap.treesitter'.select, { mode = { 'n', 'x', 'o' } })

require 'navigate-note'.setup {}


require 'fzf-lua'.setup {
  keymap = {
    builtin = { true,
      ['<C-h>'] = 'toggle-help',
    }
  }
}
K('<leader>f', function() require 'fzf-lua'.files { cwd = vim.fs.root(0, '.git') } end)
K('<leader>F', require 'fzf-lua'.oldfiles)
K('<leader>b', require 'fzf-lua'.buffers)
K('<leader>m', require 'fzf-lua'.marks)
K('<leader>j', require 'fzf-lua'.jumps)

K('<leader>h', require 'fzf-lua'.helptags)
K('<leader>M', require 'fzf-lua'.manpages)

K('<leader>g', require 'fzf-lua'.live_grep)
K('<leader>G', require 'fzf-lua'.live_grep_native)
K('<leader>;', require 'fzf-lua'.live_grep_resume)
K('<leader>:', require 'fzf-lua'.live_grep_glob)
K('<leader>/', require 'fzf-lua'.grep)

K('<C-g>', require 'fzf-lua'.grep_last)
K('<C-g>', require 'fzf-lua'.grep_cword)
K('<C-g>', require 'fzf-lua'.grep_cWORD)
K('<C-g>', require 'fzf-lua'.grep_visual)
K('<C-g>', require 'fzf-lua'.grep_project)
K('<C-g>', require 'fzf-lua'.grep_curbuf)
K('<C-g>', require 'fzf-lua'.grep_quickfix)
K('<C-g>', require 'fzf-lua'.grep_loclist)
K('<C-g>', require 'fzf-lua'.lgrep_curbuf)
K('<C-g>', require 'fzf-lua'.lgrep_quickfix)
K('<C-g>', require 'fzf-lua'.lgrep_loclist)

K('<leader>q', require 'fzf-lua'.quickfix)
K('<leader>Q', require 'fzf-lua'.quickfix_stack)
K('<leader>l', require 'fzf-lua'.loclist)
K('<leader>L', require 'fzf-lua'.loclist_stack)
K('[[q', '<cmd>cfirst<cr>')
K(']]q', '<cmd>clast<cr>')
K('[Q', '<cmd>colder<cr>')
K(']Q', '<cmd>cnewer<cr>')
K('<c-q>', '<cmd>if empty(filter(getwininfo(), "v:val.quickfix")) | silent cw | else | cclose | endif<cr>')
K('[[l', '<cmd>lfirst<cr>')
K(']]l', '<cmd>llast<cr>')
K('[L', '<cmd>lolder<cr>')
K(']L', '<cmd>lnewer<cr>')

AUC('BufWinEnter', {
  nested   = true,
  callback = function(ev)
    local root_dir = vim.fs.root(ev.buf, '.git')
    if vim.bo[ev.buf].modifiable and vim.bo[ev.buf].ft and root_dir and root_dir ~= vim.fn.getcwd() then
      vim.cmd.lcd(root_dir)
    end
  end
})

require 'nvim-tree'.setup {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = {
      enable = true
    }
  },
  renderer = { indent_width = 1 },
  actions = {
    expand_all = { exclude = { '.git' } }
  }
}
K('<C-t>', require 'nvim-tree.api'.tree.toggle, { silent = true })
K('<leader>,', function()
  vim.cmd.tabe(vim.fs.root(vim.fn.expand '$MYVIMRC', '.git'))
  require 'nvim-tree.api'.tree.expand_all()
end)

K('g^', function() require 'treesitter-context'.go_to_context(vim.v.count1) end)

require 'trouble'.setup {}
require 'bqf'.setup {}

require 'aerial'.setup {
  filter_kind = false,
  auto_jump = true
}
K('<C-s>', require 'aerial'.open)
