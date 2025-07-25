vim.loader.enable()

-- git clone --depth 1 https://github.com/danieiff/dotfiles --recurse-submodules --shallow-submodules --jobs 50

-- curl https://mise.run | sh
-- mise use -g zig node neovim@nightly yq ripgrep github-cli fzf
-- ln -s ~/dotfiles/nvim ${XDG_CONFIG_HOME:-~/.config}

if vim.uv.os_uname().sysname:find 'Windows' then
  -- winget install git.git jdx.mise
  -- mise use -g zig node neovim@nightly yq ripgrep github-cli fzf
  -- New-Item -Path $ENV:LOCALAPPDATA/nvim -ItemType SymbolicLink -Value dotfiles/nvim
  vim.fn.setenv('LANG', 'en_US.UTF-8')
  vim.env.PATH = vim.env.PATH .. [[;\Program Files\Git\usr\bin;]]
end

K = function(lhs, rhs, opts)
  opts = opts or {}
  local mode = opts.mode or 'n'
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end
CMD = vim.api.nvim_create_user_command
local default_group = vim.api.nvim_create_augroup('default', { clear = true })
AUC = function(ev, opts)
  opts.group = opts.group or default_group
  return vim.api.nvim_create_autocmd(ev, opts)
end
CHECK_FILE_MODIFIABLE = function(bufnr, nowait_ft_detect)
  return vim.api.nvim_get_option_value('modifiable', { buf = bufnr })
      and vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == ''
      and not vim.api.nvim_get_option_value('readonly', { buf = bufnr })
      and (nowait_ft_detect or vim.api.nvim_get_option_value('filetype', { buf = bufnr }) ~= '')
      and vim.api.nvim_buf_get_name(bufnr) ~= ''
end

vim.o.autowriteall = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.expandtab = true
vim.o.fixendofline = false
vim.o.foldenable = false
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
-- Reset :set option&

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

if vim.uv.os_uname().sysname:find 'Linux' and
    vim.uv.os_uname().release:find 'WSL' then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'iconv -t sjis | clip.exe',
      ['*'] = 'iconv -t sjis | clip.exe',
    },
    paste = {
      ['+'] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0
  }
end

K('<C-w><C-w>', '<cmd>windo set scrollbind!<cr>')

K('<leader>w', function() vim.cmd 'silent write' end)
K('jk', '<c-\\><c-n>', { mode = { 'i', 'c', 't' } })

K("<esc>", "<cmd>nohl<cr>")
K('<leader><esc>', '<cmd>qa<cr>')
K('<bs><esc>', ('<cmd>!rm -rf %s/swap %s/shada<cr>'):format(vim.fn.stdpath 'state', vim.fn.stdpath 'state'))

K('y%', '<cmd>let @+=@%<cr>')
K('yY', require 'fzf-lua'.registers)

K('<leader> ', require 'fzf-lua'.resume)
K('<leader>c', require 'fzf-lua'.commands)
K('<leader>C', require 'fzf-lua'.command_history)
K('<leader>?', require 'fzf-lua'.search_history)
K('<leader>k', require 'fzf-lua'.keymaps)

AUC('InsertLeave', {
  callback = function(ev) if CHECK_FILE_MODIFIABLE(ev.buf) then vim.cmd 'silent write' end end,
  nested = true
})

AUC("BufReadPre", {
  desc = 'Improve performance for larger files',
  nested = true,
  callback = function(ev)
    if vim.fn.getfsize(ev.file) > 1024 * 1024 * 2 then
      vim.bo[ev.buf].eventignore:append 'FileType'
      vim.bo[ev.buf].undolevels = -1
    end
  end
})

-- git submodule deinit -f
-- git submodule update --init
CMD('GitSubmoduleAddVimPlugin', function(arg)
  vim.system(
    { 'git', 'submodule', 'add', arg.fargs[1], ('pack/%s/start/%s'):format(arg.fargs[2] or 'required',
      vim.fn.fnamemodify(arg.fargs[1], ':t')) },
    { cwd = vim.fn.fnamemodify(vim.fn.stdpath 'config', ':h') .. '/nvim' },
    function(data)
      assert(data.code == 0, 'Failed: ' .. data.stderr)
      vim.schedule(function() vim.cmd('set runtimepath& | runtime! PACK plugin/**/*.{vim,lua} | helptags ALL') end)
    end)
end, { nargs = '*' })

require 'news'
require 'language'
require 'git'
require 'code_assist'
require 'session'
require 'navigation'
require 'ui'
require 'tasks'
