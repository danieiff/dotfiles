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

cd ~
curl https://mise.run | sh
mise use -g zig@0.10 node zellij neovim yq ripgrep github-cli

[ -d ~/dotfiles ] || git clone --depth 1 https://github.com/danieiff/dotfiles --recurse-submodules --shallow-submodules --jobs 100
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

local default_group = vim.api.nvim_create_augroup('default', {})
function AUC(ev, opts)
  if not opts.group then opts.group = default_group end
  vim.api.nvim_create_autocmd(ev, opts)
end

local uname = vim.loop.os_uname()
PLATFORM = {
  mac = uname.sysname == 'Darwin',
  linux = uname.sysname == 'Linux',
  windows = uname.sysname:find 'Windows',
  wsl = uname.sysname == 'Linux' and uname.release:lower():find 'microsoft'
}
HOME = vim.loop.os_homedir()
NVIM_DATA = vim.fn.stdpath 'data'
if type(NVIM_DATA) == 'table' then NVIM_DATA = NVIM_DATA[1] end

vim.uv.os_setenv('LANG', 'en')
vim.uv.os_setenv('PATH', vim.env.HOME .. '/.local/share/mise/shims:' .. vim.env.PATH)
if PLATFORM.windows then
  vim.uv.os_setenv('PATH', os.getenv 'PATH' .. [[;\Program Files\Git\usr\bin;]])
end

CMD('GitSubmoduleAddVimPlugin', function(arg)
  vim.system(
    { 'git', 'submodule', 'add', arg.args, 'nvim/pack/my/start/' .. vim.fn.fnamemodify(arg.args, ':t') },
    { cwd = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath 'config'), ':h') },
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

---@ Editor Config

function Foldexpr(...)
  local ok, ret = pcall(vim.lsp.foldexpr, ...)
  return ok and ret ~= 0 and ret or vim.treesitter.foldexpr(...)
end

for k, v in pairs {
  autowriteall = true, undofile = true,
  shellcmdflag = '-c', grepprg = 'rg --vimgrep',
  ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true,
  pumblend = 30, winblend = 30, termguicolors = true,
  laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number', cursorline = true, cursorlineopt = 'line',
  list = true, listchars = { tab = "⇥ " }, fixendofline = false, scrolloff = 2,
  foldenable = false, foldmethod = 'expr', foldexpr = 'v:lua.Foldexpr()', foldtext = ''
  --, foldlevel = 99, foldenable = true, foldlevelstart = -1
} do vim.opt[k] = v end -- Reset :set option&

vim.opt.iskeyword:append '-'
vim.g.mapleader = ' '

K('<C-h>', '<C-w>h')
K('<C-j>', '<C-w>j')
K('<C-k>', '<C-w>k')
K('<C-l>', '<C-w>l')
K('<C-w>-', '<cmd>resize -10<cr>')
K('<C-w>+', '<cmd>resize +10<cr>')
K('<C-w><', '<cmd>vertical resize -10<cr>')
K('<C-w>>', '<cmd>vertical resize +10<cr>')
K('<C-w><C-w>', '<cmd>windo set scrollbind!<cr>')
K('<tab>', '<cmd>tabnext<cr>')
K('<s-tab>', '<cmd>tabprevious<cr>')
K('<leader>w', vim.cmd.write)
K('<leader>z', '<cmd>qa<cr>')
K('<leader>,', '<cmd>tabe $MYVIMRC<cr>')
K('<leader>.,', function()
  vim.cmd 'set runtimepath& | runtime! plugin/**/*.{vim,lua}'
  vim.cmd 'source $MYVIMRC | helptags ALL'
end)

K('jk', '<c-\\><c-n>', { mode = { 'i', 'c', 't' } })
K("<esc>", "<cmd>nohl<cr><cmd>echo<cr>")
K('<leader>s', ':%s///g' .. ('<Left>'):rep(3))
K('<Leader>s', ':s///g' .. ('<Left>'):rep(3), { mode = 'v' })
K('<leader>S', [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
K('Y', 'y$')
K('vp', '`[v`]')
K('+', '<cmd>call append(expand("."), "")<cr>j')
K('-', '<cmd>call append(line(".")-1, "")<cr>k')
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
K('<leader>y', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end)

K('[q', '<cmd>cprevious<cr>')
K(']q', '<cmd>cnext<cr>')
K('[[q', '<cmd>cfirst<cr>')
K(']]q', '<cmd>clast<cr>')
K('[Q', '<cmd>colder<cr>')
K(']Q', '<cmd>cnewer<cr>')
K('qq',
  '<cmd>if empty(filter(range(1, winnr("$")), \'getwinvar(v:val, "&ft") == "qf"\')) | cwindow | else | cclose | endif<cr>')
K('[l', '<cmd>lprevious<cr>')
K(']l', '<cmd>lnext<cr>')
K('[[l', '<cmd>lfirst<cr>')
K(']]l', '<cmd>llast<cr>')
K('[L', '<cmd>lolder<cr>')
K(']L', '<cmd>lnewer<cr>')

K('<leader>ou', function()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local urls = {}
  for url in text:gmatch('(%a+://[%w-_%.%?%.:/%+=&]+)') do table.insert(urls, url) end
  if #urls > 1 then
    vim.ui.select(urls, {}, function(url) if url then vim.fn.jobstart('open ' .. vim.fn.escape(url, '#')) end end)
  end
end)

local copy, paste = vim.tbl_get(vim, 'g', 'clipboard', 'copy', '+'), vim.tbl_get(vim, 'g', 'clipboard', 'paste', '+')
if PLATFORM.wsl then
  copy, paste = 'clip.exe',
      'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
elseif PLATFORM.linux then
  copy, paste = 'wl-copy', 'wl-paste'
end
vim.g.clipboard = { copy = { ['+'] = copy, ['*'] = copy }, paste = { ['+'] = paste, ['*'] = paste } }

AUC('FileType', { pattern = { 'json', 'jsonc', 'yaml', 'python', 'c', 'cpp', 'java', 'go' }, command = 'set tabstop=4' })

AUC('InsertLeave', {
  callback = function(ev)
    if vim.api.nvim_get_option_value('modifiable', { buf = ev.buf })
        and vim.api.nvim_get_option_value('buftype', { buf = ev.buf }) == ''
        and not vim.api.nvim_get_option_value('readonly', { buf = ev.buf })
        and vim.api.nvim_get_option_value('filetype', { buf = ev.buf }) ~= ''
        and vim.api.nvim_buf_get_name(ev.buf) ~= '' then
      vim.cmd.write()
    end
  end,
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
