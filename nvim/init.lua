--[[
<C-w>T
:.!ls
:h complex-change
:{range}![!]{filter} [!][arg]
ls is the {filter} program. The filter program accepts the text of the current line at standard input.
If there is no intention to send anything to the command, it would be better to run this on an empty line.
!!{filter} is a quick way of entering the same sequence.

:let @a = system("ls -ltr")

ulimit -n 10240

curl https://mise.run | sh
mise use -g zig@0.10 node zellij neovim yq ripgrep github-cli

[ -d ~/dotfiles ] || git clone --depth 1 https://github.com/danieiff/dotfiles ~ --recurse-submodules --shallow-submodules --jobs 100
ln -s ~/dotfiles/nvim ${XDG_CONFIG_HOME:-~/.config}

nvim --headless +'MasonInstall | qa'

TSInstall lua vimdoc markdown markdown_inline http json jsonc bash sql gitcommit git_rebase python
javascript typescript tsx html css vue svelte astro
php ruby
java c_sharp go rust c
yaml toml
dockerfile prisma graphql

@("git.git", "zig.zig", "Neovim.Neovim.Nightly", "BurntSushi.ripgrep.MSVC") | ForEach-Object { winget install $_ }
git clone --depth 1 https://github.com/danieiff/dotfiles -b windows --recurse-submodules --shallow-submodules --jobs 100
New-Item -Path $ENV:LOCALAPPDATA/nvim -ItemType SymbolicLink -Value dotfiles/nvim

]]

K = function(lhs, rhs, opts)
  opts = opts or {}
  local mode = opts.mode or 'n'
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end
HL = vim.api.nvim_set_hl
CMD = vim.api.nvim_create_user_command

local default_group = vim.api.nvim_create_augroup('default', { clear = true })
function AUC(ev, opts)
  if not opts.group then opts.group = default_group end
  vim.api.nvim_create_autocmd(ev, opts)
end

local uname = vim.uv.os_uname()
PLATFORM = {
  mac = uname.sysname == 'Darwin',
  linux = uname.sysname == 'Linux',
  windows = uname.sysname:find 'Windows',
  wsl = uname.sysname == 'Linux' and uname.release:lower():find 'microsoft'
}
NVIM_DATA = vim.fn.stdpath 'data'
if type(NVIM_DATA) == 'table' then NVIM_DATA = NVIM_DATA[1] end
NVIM_CONF = vim.fn.stdpath 'config'
NVIM_CONF = assert(vim.uv.fs_realpath(type(NVIM_CONF) == 'string' and NVIM_CONF or NVIM_CONF[1]),
  'should find nvim config')

if PLATFORM.windows then vim.uv.os_setenv('PATH', os.getenv 'PATH' .. [[;\Program Files\Git\usr\bin;]]) end

CHECK_FILE_MODIFIABLE = function(bufnr, nowait_ft_detect)
  return vim.api.nvim_get_option_value('modifiable', { buf = bufnr })
      and vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == ''
      and not vim.api.nvim_get_option_value('readonly', { buf = bufnr })
      and (nowait_ft_detect or vim.api.nvim_get_option_value('filetype', { buf = bufnr }) ~= '')
      and vim.api.nvim_buf_get_name(bufnr) ~= ''
end

for k, v in pairs {
  autowriteall = true, undofile = true,
  grepprg = 'rg --vimgrep', ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true,
  fixendofline = false, scrolloff = 2,
  foldenable = false, foldmethod = 'expr', foldexpr = 'v:lua.vim.treesitter.foldexpr()', foldtext = ''
} do vim.o[k] = v end -- Reset :set option&

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

K('<C-w><C-w>', '<cmd>windo set scrollbind!<cr>')

K('<leader>w', function() vim.cmd 'silent write' end)
K('jk', '<c-\\><c-n>', { mode = { 'i', 'c', 't' } })
AUC('InsertLeave', {
  callback = function(ev) if CHECK_FILE_MODIFIABLE(ev.buf) then vim.cmd 'silent write' end end,
  nested = true
})
K("<esc>", "<cmd>nohl<cr>")
K('<leader>z', '<cmd>qa<cr>')

K('Y', 'y$')
K('<leader>y', function() vim.fn.setreg("+", vim.fn.expand '%') end)
K('<leader>r', require 'fzf-lua'.registers)

K('<leader> ', require 'fzf-lua'.resume)
K('<leader>c', require 'fzf-lua'.commands)
K('<leader>C', require 'fzf-lua'.command_history)
K('<leader>?', require 'fzf-lua'.search_history)
K('<leader>k', require 'fzf-lua'.keymaps)

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

K('<Leader>t', function()
  local cmd = vim.fn.input { prompt = ':tab term ', completion = 'shellcmd', cancelreturn = 0 }
  if cmd ~= 0 then
    vim.cmd('tab term ' .. cmd); vim.cmd 'setlocal nonumber | startinsert'
  end
end)

local overseer = require 'overseer'
overseer.setup {}
require 'overseer'.register_template({
  name = "Git checkout",
  params = function()
    local stdout = vim.system({ "git", "branch", "--format=%(refname:short)", "-r" }):wait().stdout
    local branches = vim.split(stdout, "\n", { trimempty = true })
    return {
      branch = {
        desc = "Branch to checkout",
        type = "enum",
        choices = branches,
      },
    }
  end,
  builder = function(params)
    return {
      cmd = { "git", "log", params.branch },
    }
  end,
})

require 'grug-far'.setup { resultsHighlight = false }
K('<leader>S', function() require 'grug-far'.toggle_instance { instanceName = 'grug-far' } end)
K('<leader>s', ':%s///g' .. ('<Left>'):rep(3))
K('<Leader>s', ':s///g' .. ('<Left>'):rep(3), { mode = 'v' })

vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SetFocusWhenToggle = 1
K('<leader>u', '<cmd>UndotreeToggle<cr>')

K('<leader>6', ('<cmd>!rm -rf %s/swap %s/shada<cr>'):format(NVIM_DATA, NVIM_DATA))
K('<leader>7', function()
  local urlpath, querystring = unpack(vim.split(vim.api.nvim_get_current_line(), '?'))
  if urlpath and querystring then
    local lines = { urlpath }
    local queryparams = vim.fn.sort(vim.split(querystring, '&'))
    for idx, queryparam in ipairs(queryparams) do
      table.insert(lines, (idx == 1 and '?' or '&') .. queryparam)
    end
    vim.api.nvim_buf_set_lines(0, vim.api.nvim_win_get_cursor(0)[1] - 1, -1, false, lines)
  else
    vim.cmd [['{,'}s/\n\@<!//g]]
  end
end)

local base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

CMD('Base64Encode', function(arg)
  local data = arg.args
  local encoded = (data:gsub('.', function(x)
    local r, b = '', x:byte()
    for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
    return r;
  end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c = 0
    for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
    return base64:sub(c + 1, c + 1)
  end) .. ({ '', '==', '=' })[#data % 3 + 1]
  vim.print(encoded)
end, { nargs = 1 })

CMD('Base64Decode', function(arg)
  local data = arg.args:gsub('[^' .. base64 .. '=]', '')
  local decoded = (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r, f = '', (base64:find(x) - 1)
    for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c = 0
    for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
    return string.char(c)
  end))

  vim.print(decoded)
end, { nargs = 1 })

CMD('UrlEncode', function(arg)
  local url = arg.args
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", function(c) return ('%%%02X'):format(c:byte()) end)
  url = url:gsub(" ", "+")
  vim.print(url)
end, { nargs = 1 })

CMD('UrlDecode', function(arg)
  local url = arg.args
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", function(x) return tonumber(x, 16) end)
  vim.print(url)
end, { nargs = 1 })

-- git submodule deinit -f .
-- git submodule update --init
CMD('GitSubmoduleAddVimPlugin', function(arg)
  vim.system(
    { 'git', 'submodule', 'add', arg.args, 'nvim/pack/required/start/' .. vim.fn.fnamemodify(arg.args, ':t') },
    { cwd = vim.fn.fnamemodify(NVIM_CONF, ':h') },
    function(data)
      assert(data.code == 0, 'git submodule add ' .. arg.args .. ' failed: ' .. data.stderr)
      vim.schedule(function() vim.cmd('set runtimepath& | runtime! plugin/**/*.{vim,lua} | helptags ALL') end)
    end)
end, { nargs = 1 })

CMD('GetLatestAwsmNvim', function()
  local awsm_nvim_diff_file = vim.fs.find(function(name)
    return name:find '%w+%.%.%w+%.diff' and true or false
  end, { path = NVIM_DATA, type = 'file' })[1]

  local stat = vim.uv.fs_stat(awsm_nvim_diff_file)
  local date = vim.fn.strftime('%Y-%m-%d', stat and stat.mtime.sec or os.time())

  vim.system({ 'curl', '-sS', 'https://api.github.com/repos/rockerBOO/awesome-neovim/commits?since=' .. date }, {},
    function(data)
      local json_ok, json = pcall(vim.json.decode, data.stdout)
      assert(data.code == 0 and json_ok, 'get commit id with specific date ' .. (data.stderr or data.stdout))
      if #json == 0 then vim.schedule(function() vim.notify 'awesome-neovim has no diff' end) end

      local tail_fname = ('%s..%s.diff'):format((awsm_nvim_diff_file):match('%.%.(%w+)%.') or json[#json].sha,
        json[1].sha)

      vim.system(
        { 'curl', '-LO', 'http://github.com/rockerBOO/awesome-neovim/compare/' .. tail_fname },
        { cwd = NVIM_DATA },
        function(diff_data)
          assert(diff_data.code == 0, 'awesome-neovim diff failed')
          vim.schedule(function() vim.cmd.tabe(NVIM_DATA .. tail_fname) end)
        end)
    end)
end, {})

CMD('Dotfyle', function()
  vim.system({ 'curl', 'https://dotfyle.com/this-week-in-neovim/rss.xml' }, {}, function(data)
    local rss_items = assert(vim.tbl_get(require 'xml2lua'.parse(data.stdout) or {}, 'rss', 'channel', 'item'),
      'failed to parse dotfyle rss.xml: ' .. data.stderr)
    vim.schedule(function()
      local items = vim.tbl_filter(function(item)
        return os.difftime(
          vim.fn.strptime('%d %b %Y %T', ('Tue, 23 Jul 2024 19:51:25 GMT'):match(', (.*) GMT')), -- last time
          vim.fn.strptime('%d %b %Y %T', item.pubDate:match(', (.*) GMT'))
        ) > 0
      end, rss_items)

      local file = assert(io.open('a.css', 'a'), 'should open file to write')
      file:write(vim.json.encode(items))
      file:close()
    end)
  end)
end, {})

require 'language'
require 'git'
require 'code_assist'
require 'session'
require 'navigation'
require 'ui'
