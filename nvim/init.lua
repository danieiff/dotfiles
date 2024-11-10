--[[
git diff COMMIT_HASH_1 COMMIT_HASH_2 | grep "your_search_term"
Gedit git-obj:filepath
0Gclog
Gclog --name-only
git update-index --skip-worktree
git update-index --no-skip-worktree

new
r! git show branch:file
file filename
filetype detect
set buftype=nowrite

G log --graph --abbrev-commit --format=format:'%C(bold blue)%h%C(reset)%C(red)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto) %C(bold green)(%ar)%C(reset)' --all

git diff-tree --no-commit-id --name-only -r $1

if | | else | | endif

Quit Vim with error code {N}

ulimit -n 10240

## ReactNative Android
# mkdir ~/Android && ln -s /mnt/c/Users/Hirohisa/AppData/Local/Android/Sdk ~/Android/sdk
# ln -s ~/Android/Sdk/platform-tools/adb.exe ~/Android/Sdk/platform-tools/adb
# ln -s ~/Android/Sdk/platform-tools/emulator/emulator.exe ~/Android/Sdk/emulator/emulator
ANDROID_HOME=~/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
alias emu='$ANDROID_HOME/emulator/emulator @Pixel_4_API_30'
alias emu-list='$ANDROID_HOME/emulator/emulator -list-avds'

# Foreach ( $port in 19000,19001,19002 ) { netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$($(wsl hostname -I).Trim()) }
# Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL Expo ports for LAN development' -Direction $dir -LocalPort 19000-19002 -Action Allow -Protocol TCP }
alias rn-expo='REACT_NATIVE_PACKAGER_HOSTNAME=$(/mnt/c/Windows/system32/ipconfig.exe | grep -m 1 "IPv4 Address" | sed "s/.*: //") npx expo start'

nvim --server \$NVIM --remote-silent"

dev-docker() {
  local docker_home=/home/me
  docker run -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.config/gh:$docker_home/.config/gh \
  -v ~/.cache/nvim/codeium:$docker_home/.cache/nvim/codeium \
  -v .:$docker_home/workspace \
  -e LOCAL_UID="$(id -u "$USER")" \
  -e LOCAL_GID="$(id -g "$USER")" \
  "$@"
}

dev-ssh() {
  ssh -L "${1:-3000}:localhost:${1:-3000} ${3:-user@host}"
}

# curl https://raw.githubusercontent.com/danieiff/dotfiles/setup | sh

cd ~
curl https://mise.run | sh
mise use -g zig@0.10 node zellij neovim yq ripgrep github-cli

[ -d dotfiles ] || git clone --depth 1 https://github.com/danieiff/dotfiles --recurse-submodules --shallow-submodules --jobs 100
ln -s ~/dotfiles/nvim ${XDG_CONFIG_HOME:-~/.config}

nvim --headless +'MasonInstall | qa'

# if [ -z "$REMOTE_CONTAINER" ]; then
# curl -fsSL https://get.docker.com | sh
# curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
# curl -Lo devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && install -c -m 0755 devpod /bin && rm -f devpod
# fi

if [ "$WSLENV" ]; then
  WslLocalAppData="$(wslpath "$(powershell.exe \$Env:LocalAppData)" | tr -d "\r")"
  cp "$DOTFILES_DIR/windows-terminal-settings.json" "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
  ln -fs "$WslLocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json" "$DOTFILES_DIR/_windows-terminal-settings.json"

  ## SSH https://futurismo.biz/archives/6862/#-nat-
  # sudo apt install -y openssh-server
  ### Run in Powershell as Admin
  # $wsl_ipaddress1 = (wsl hostname -I).split(" ", 2)[0]
  # netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=22
  # netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=$wsl_ipaddress1 connectport=22
  # netsh interface portproxy show v4tov4
  # Foreach ( $dir in "Inbound","Outbound" ) { New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort 22 -Action Allow -Protocol TCP }

  # vi /etc/ssh/sshd_config # Edit yes/no for PubkeyAuthentication, PasswordAuthentication
  # sudo chmod 600 ~/.ssh/authorized_keys

  # ssh-keygen && ssh-copy-id <user@host>
  # # Opt) Generate public domain e.g.) https://www.noip.com/
  # # Config Wifi router to open port or proxy to different port from default of ssh
  # dev() {
  #   ssh -L "${1:-3000}:localhost:${1:-3000}" <user@host>
  # }
  # sudo systemctl start sshd

  ## Chrome (google-chrome)
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  set +e
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  sudo apt install language-pack-ja fonts-ipafont fonts-ipaexfont
  set -e
  sudo apt install --fix-broken -y
  fc-cache -fv
fi

https://github.com/stevearc/quicker.nvim
]]

K = function(lhs, rhs, opts)
  opts = opts or {}
  local mode = opts.mode or 'n'
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end
HL = vim.api.nvim_set_hl
CMD = vim.api.nvim_create_user_command
AUC = vim.api.nvim_create_autocmd
AUG = vim.api.nvim_create_augroup

local uname = vim.loop.os_uname()
PLATFORM = {
  mac = uname.sysname == 'Darwin',
  linux = uname.sysname == 'Linux',
  windows = uname.sysname:find 'Windows',
  wsl = uname.sysname == 'Linux' and uname.release:lower():find 'microsoft'
}

---@ Dependencies Management

NVIM_DATA = vim.fn.stdpath 'data'

CMD('GitSubmoduleAddVimPlugin', function(arg)
  vim.system({ 'git', 'submodule', 'add', arg.args },
    { cwd = vim.fn.stdpath 'config' .. '/pack/my/start/' .. vim.fn.fnamemodify(arg.args, ':t') },
    function(res)
      if res.code ~= 0 then return vim.notify('git submodule add failed') end
      vim.cmd('set runtimepath^=' .. vim.fn.stdpath 'config' .. ' | runtime! plugin/**/*.{vim,lua} | helptags ALL')
    end)
end, {})

---@ Editor Config

for k, v in pairs {
  autowriteall = true, undofile = true,
  shellcmdflag = '-c', grepprg = 'rg --vimgrep -S ', grepformat = '%f:%l:%c:m',
  ignorecase = true, smartcase = true, tabstop = 2, shiftwidth = 0, expandtab = true,
  pumblend = 30, winblend = 30, termguicolors = true, list = true, laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number',
  foldenable = false, foldmethod = 'expr', foldexpr = 'v:lua.vim.nreesitter.foldexpr()' }
do vim.opt[k] = v end

vim.g.mapleader = ' '

K('<C-h>', '<C-w>h')
K('<C-j>', '<C-w>j')
K('<C-k>', '<C-w>k')
K('<C-l>', '<C-w>l')
K('<C-y>', '3<C-y>')
K('<C-e>', '3<C-e>')
K('<C-w>-', '<cmd>resize -10<cr>')
K('<C-w>+', '<cmd>resize +10<cr>')
K('<C-w><', '<cmd>vertical resize -10<cr>')
K('<C-w>>', '<cmd>vertical resize +10<cr>')
K('<S-Left>', '<cmd>tabprevious<cr>', { silent = true, mode = { 'n', 't' } })
K('<S-Right>', '<cmd>tabnext<cr>', { silent = true, mode = { 'n', 't' } })
K('<leader>w', vim.cmd.write)
K('<Leader>z', '<cmd>qa<cr>')
K('<Leader>Z', '<cmd>noautocmd qa<cr>')
K('<Leader>,', '<cmd>execute "tabe " . resolve($MYVIMRC)<cr>')
K('<Leader>.,', function()
  vim.cmd('set runtimepath^=' .. vim.fn.stdpath 'config' .. ' | runtime! plugin/**/*.{vim,lua}')
  vim.cmd 'source $MYVIMRC | helptags ALL'
end)
K('<Leader>s', ':%s///g' .. ('<Left>'):rep(3))
K('<Leader>s', ':s///g' .. ('<Left>'):rep(3), { mode = 'v' })
K('<leader>S', [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]])
K('Y', 'y$')
K('vp', '`[v`]')
K('+', '<C-a>', { mode = { 'n', 'v' } })
K('-', '<C-x>', { mode = { 'n', 'v' } })
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

K('[q', '<cmd>cprevious<cr>')
K(']q', '<cmd>cnext<cr>')
K('[[q', '<cmd>cfirst<cr>')
K(']]q', '<cmd>clast<cr>')
K('[Q', '<cmd>colder<cr>')
K(']Q', '<cmd>cnewer<cr>')
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

local function normalize_session_path(dir)
  return vim.fn.stdpath 'data' .. vim.fn.fnamemodify(dir, ':p:h'):gsub('/', '%%')
end
local function load_session_if_exists(dir)
  if vim.loop.fs_stat(normalize_session_path(dir)) then
    vim.cmd('silent! source ' .. vim.fn.fnameescape(normalize_session_path(dir)))
    vim.schedule(function() vim.cmd 'silent! tabdo windo edit' end)
    return true
  end
end
AUC('VimEnter', {
  callback = function()
    local vim_argv = vim.fn.argv()
    if #vim_argv > 0 and vim_argv[1]:find '.git/COMMIT_EDITMSG' then return end
    if load_session_if_exists(vim.fn.getcwd()) then for _, path in ipairs(vim_argv) do vim.cmd.tabedit(path) end end
  end
})
local function mksession()
  vim.cmd('silent! tabdo NvimTreeClose | mksession! ' .. vim.fn.fnameescape(normalize_session_path(vim.fn.getcwd())))
end
AUC('VimLeave', { callback = mksession })

---@ Terminal

K('<Leader>t', function()
  local cmd = vim.fn.input { prompt = 'Start term: ', default = ' ', completion = 'shellcmd', cancelreturn = '' }
  vim.cmd('tabnew | term ' .. cmd); vim.cmd 'setlocal nonumber | startinsert'
end)
K('<C-n>', '<C-\\><C-n>', { mode = 't' })
AUC('TermClose', { callback = function(ev) vim.cmd('silent! bwipe!' .. ev.buf) end })

local overseer = require 'overseer'
overseer.setup {}

require 'ui'

require "nvim-tree".setup {
  view = { width = 60, side = 'right' },
  on_attach = function(bufnr)
    local api = require 'nvim-tree.api'
    api.config.mappings.default_on_attach(bufnr)
    K('t', function()
      local node = api.tree.get_node_under_cursor()
      vim.cmd 'wincmd h'
      api.node.open.tab(node)
    end, { buffer = bufnr })
  end }
K("<C-q>", function() require 'nvim-tree.api'.tree.toggle({ find_file = true }) end)

K('<leader>u', '<cmd>UndotreeToggle<cr>')

require 'telescope'.setup {}
K('<leader> ', require 'telescope.builtin'.resume)

K('<leader>f', require 'telescope.builtin'.find_files)
K('<leader>F', require 'telescope.builtin'.oldfiles) -- :oldfiles :browse oldfiles
K('<leader>b', require 'telescope.builtin'.buffers)

K('<leader>r', require 'telescope.builtin'.registers)
K('<leader>m', require 'telescope.builtin'.marks)
K('<leader>j', require 'telescope.builtin'.jumplist)
K('<leader>c', require 'telescope.builtin'.commands)
K('<leader>C', require 'telescope.builtin'.command_history)
K('<leader>k', require 'telescope.builtin'.keymaps)
K('<Leader>h', require 'telescope.builtin'.help_tags)
K('<leader>M', require 'telescope.builtin'.man_pages)

K('<leader>q', require 'telescope.builtin'.quickfix)
K('<leader>Q', require 'telescope.builtin'.quickfixhistory)
K('<leader>l', require 'telescope.builtin'.loclist)

K('<leader>g', require 'telescope.builtin'.live_grep)
K('<leader>/', require 'telescope.builtin'.grep_string)
K('<leader>?', require 'telescope.builtin'.search_history)

K('<leader>e', require 'telescope.builtin'.diagnostics)
K('<leader>ld', require 'telescope.builtin'.lsp_definitions)

---@ TreeSitter

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'javascript', 'typescript', 'tsx', 'html', 'css', 'vue', 'svelte', 'astro',
    'python', 'php', 'ruby', 'lua', 'bash',
    'java', 'c_sharp',
    'c', 'go', 'rust',
    'yaml', 'toml', 'json', 'jsonc', 'markdown', 'markdown_inline',
    'gitcommit', 'git_rebase',
    'dockerfile', 'sql', 'prisma', 'graphql', 'http'
  },
  highlight = { enable = true }
}

require 'ibl'.setup()
require 'treesitter-context'.setup()

local _get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
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
  local language_commentstring = comment_config[language_tree:lang()]
  if not language_commentstring then return end

  local function check_node(node)
    return node and (language_commentstring[node:type()] or check_node(node:parent()))
  end

  return check_node(language_tree:named_node_for_range { row, col, row, col }) or comment_config[filetype] or
      _get_option(filetype, option)
end

require 'nvim-surround'.setup()
require 'nvim-ts-autotag'.setup { enable_close_on_slash = false, }
require 'nvim-autopairs'.setup { disable_in_visualblock = true, fast_wrap = { map = '<C-]>' } } -- <C-h> to delete only '('

K("w", "<cmd>lua require 'spider' .motion 'w' <cr>", { mode = { "n", "o", "x" } })
K("e", "<cmd>lua require 'spider' .motion 'e' <cr>", { mode = { "n", "o", "x" } })
K("b", "<cmd>lua require 'spider' .motion 'b' <cr>", { mode = { "n", "o", "x" } })
K("ge", "<cmd>lua require 'spider' .motion 'ge' <cr>", { mode = { "n", "o", "x" } })

require 'flash'.setup { label = { uppercase = false }, modes = { search = { enabled = false } } }
K('f', require 'flash'.jump, { mode = { "n", "x", "o" } })
K('r', require 'flash'.remote, { mode = { "o" } })
K('v,', require 'flash'.treesitter, { mode = { "n", "x", "o" } })
K('v;', require 'flash'.treesitter_search, { mode = { "n", "x", "o" } })

---@ Coding Support

require 'chatgpt'.setup {
  openai_params = { model = 'gpt-4o-mini' }
}

require 'avante_lib'.load()
require 'avante'.setup {
  provider = 'openai', openai = { model = 'gpt-4o-mini' }
}

local neocodeium = require 'neocodeium'
neocodeium.setup()
K("<A-y>", neocodeium.accept, { mode = { "i" } })
K("<A-w>", neocodeium.accept_word, { mode = { "i" } })
K("<A-Y>", neocodeium.accept_line, { mode = { "i" } })
K("<A-n>", neocodeium.cycle_or_complete, { mode = { "i" } })
K("<A-p>", function() neocodeium.cycle_or_complete(-1) end, { mode = { "i" } })
K("<A-c>", neocodeium.clear, { mode = { "i" } })

-- TODO: AI code doc comment writing
require 'neogen'.setup { snippet_engine = "luasnip" }
K('<leader>doc', ':Neogen ', { desc = 'arg: func|class|type' })

local luasnip = require 'luasnip'
require 'luasnip.loaders.from_vscode'.lazy_load()
for _, dir in ipairs(vim.fn.split(vim.fn.globpath('.', '*.code-snippets'), '\n')) do
  require "luasnip.loaders.from_vscode".load_standalone({ path = dir:gsub('^%./', '') })
end
for k, v in pairs { ['typescriptreact'] = { 'javascript' }, ['typescript'] = { 'javascript' } } do
  luasnip.filetype_extend(k, v)
end

local cmp = require 'cmp'
cmp.setup {
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<C-u>'] = cmp.mapping.scroll_docs(-1),
    ['<C-d>'] = cmp.mapping.scroll_docs(1),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      elseif luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      elseif luasnip.expand_or_jumpable() then
        PREPARING_LUASNIP_JUMP = true
        luasnip.expand_or_jump()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        PREPARING_LUASNIP_JUMP = true
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      PREPARING_LUASNIP_JUMP = true
      if vim.fn.mode() == 'c' then
        vim.api.nvim_feedkeys(require 'cmp.utils.keymap'.t(vim.fn.pumvisible() == 0 and '<C-z>' or '<C-n>'), 'in', true)
      else
        if not cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace } then fallback() end
      end
    end, { 'i', 's', 'c' }),
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'codeium' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function() return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins()) end,
        indexing_interval = 1500
      }
    }
  },
}

cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
cmp.event:on('confirm_done', require 'nvim-autopairs.completion.cmp'.on_confirm_done())
cmp.setup.filetype({ 'sql' }, { sources = cmp.config.sources { { name = 'cmp-dbee' } } })

require 'dbee'.setup {
  sources = {
    require 'dbee.sources'.FileSource:new(vim.fn.stdpath 'cache' .. '/dbee/persistence.json'),
  }
}

require 'lint'.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' }
}

AUC({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

---@ LSP

-- vim.lsp.set_log_level 'DEBUG' -- :LspLog
CMD('LspRestart', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd.edit()', {})

CMD('LspConfigReference', function()
  local ft = vim.fn.input { prompt = 'Search lsp config for filetype: ', default = vim.bo.ft }
  if ft == '' then return vim.notify 'no input' end

  vim.system(
    { 'curl', '-fsSL', 'https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/doc/configs.txt' },
    { text = true },
    function(res)
      if res.code ~= 0 then return vim.notify(res.stderr) end

      local server_configs_txt = res.stdout:gsub('\n##', '¬')
      local pattern = ('lua%%s+require\'lspconfig\'%%.([%%a_-]+)%%.setup[^¬]+%%- `filetypes` :%%s+```lua%%s+%%{[%%a", ]*"%s"[%%a", ]*%%}')
          :format(ft)

      local founds = server_configs_txt:gmatch(pattern)
      for ls in founds do
        local fname = ls .. '.lua'
        vim.system(
          { 'curl', '-fsSL', ('https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/server_configurations/' .. fname) },
          {}, function(curl_lsconfig_res)
            if curl_lsconfig_res.code ~= 0 then return vim.notify(curl_lsconfig_res.stderr) end
            vim.schedule(function()
              vim.cmd 'tabe'
              vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(curl_lsconfig_res.stdout, '\n'))
              vim.api.nvim_buf_set_name(0, fname)
              vim.bo.ft = 'lua'
            end)
          end)
      end
    end
  )
end, {})

CMD('LspCapa', function()
  local clients = vim.lsp.get_clients()
  vim.ui.select(vim.tbl_map(function(item) return item.name end, clients), {},
    function(_, idx)
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_win(bufnr, true, {
        relative = 'editor',
        col = 0,
        row = 0,
        width = vim.o.columns,
        height = vim.o.lines,
      })
      vim.api.nvim_buf_set_lines(bufnr, 0, 1, false,
        vim.split(
          '# config.capabilities: Config passed to vim.lsp.start_client()' ..
          '\n' .. vim.inspect(clients[idx].config.capabilities) .. '\n\n' ..
          '# server_capabilities:' .. '\n' .. vim.inspect(clients[idx].server_capabilities),
          "\n"))
      K('q', '<cmd>q!<cr>', { buffer = bufnr })
    end)
end, {})

require 'lsp_signature'.setup {}
require 'lsp-lens'.setup {}
require 'symbols-outline'.setup {}
K('<C-S>', '<cmd>SymbolsOutline<CR>')

local augroup_lsp = AUG('UserLspAUG', {})
AUC('LspAttach', {
  group = AUG('UserLspConfigAUG', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { group = augroup_lsp, buffer = ev.buf }
      AUC('BufWritePre', {
        group = augroup_lsp,
        buffer = ev.buf,
        callback = function()
          if not PREPARING_LUASNIP_JUMP then vim.lsp.buf.format { bufnr = ev.buf } end
          PREPARING_LUASNIP_JUMP = false
        end
      })
    end

    --[[
      Use CTRL-w ] to split the current window and jump to the definition of the symbol under the cursor in the upper window.
      Use CTRL-w } to open a preview window with the definition of the symbol under the cursor.
      Use :tselect <name> to list all tags matching the name
      Use :tjump <name>, like :tselect, but jump to it if there is only one match.
      gq (format)

      vim.lsp.codelens.refresh()

      vim.lsp.start { cmd = vim.lsp.rpc.connect('127.0.0.1', 6008), ... } -- builtin TCP support with neovim 0.8+
    ]]
    K('[d', vim.diagnostic.goto_prev)
    K(']d', vim.diagnostic.goto_next)
    K('[D', function() vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } } end)
    K(']D', function() vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } } end)
    K('<leader>d', vim.diagnostic.open_float)
    K('<leader>D', vim.diagnostic.setloclist)
    K('<leader>dq', vim.diagnostic.setqflist)

    K('gd', vim.lsp.buf.definition)
    K('gt', vim.lsp.buf.type_definition)
    K('gl', vim.lsp.buf.declaration)
    K('gr', vim.lsp.buf.references)
    K('gi', vim.lsp.buf.implementation)
    K('<leader>sh', vim.lsp.buf.signature_help)
    K('<Leader>ci', vim.lsp.buf.incoming_calls)
    K('<Leader>co', vim.lsp.buf.outgoing_calls)
    K('gk', vim.lsp.buf.hover)
    K('cv', function()
      vim.lsp.buf.rename(nil, {
        filter = function(client)
          local deprioritised = { 'typescript-tools' }
          return not vim.tbl_contains(deprioritised, client.name) or
              #vim.lsp.get_clients { method = 'textDocument/rename' } < 1
        end
      })
    end)
    K('<space>rf', vim.lsp.util.rename)
    K('<space>ca', vim.lsp.buf.code_action)
    K('<space>pa', vim.lsp.buf.add_workspace_folder)
    K('<space>pr', vim.lsp.buf.remove_workspace_folder)
    K('<space>pl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end)
  end
})

---@ DAP

local dap, dapui, dap_widgets = require 'dap', require 'dapui', require 'dap.ui.widgets'
-- :help dap-adapter dap-configuration dap.txt dap-mapping dap-api dap-widgets
K("<Leader>di", dap.toggle_breakpoint)
K("<Leader>dI", function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end)
K("<Leader>dp", function() dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end)
K("<Leader>ds", function()
    if vim.bo.filetype == "ruby" then
      vim.fn.setenv("RUBYOPT", "-rdebug/open")
      if vim.api.nvim_buf_get_name(0):find 'spec' then
        require("dap").run({
          type = "ruby",
          name = "debug rspec file",
          request = "attach",
          command = "rspec",
          script = "${file}",
          port = 38698,
          server = "127.0.0.1",
          localfs = true,      -- required to be able to set breakpoints locally
          stopOnEntry = false, -- This has no effect
        })
        return
      end
      vim.fn.setenv("RUBYOPT", "-rdebug/open")
      require("dap").continue()
      require("dap").continue()
    else
    end
    require("dap").continue()
  end,
  { desc = "Start/Continue" })
K("<Leader>dl", dap.run_to_cursor)
K("<Leader>dS", dap.disconnect)
K("<Leader>dn", dap.step_over)
K("<Leader>dN", dap.step_into)
K("<Leader>do", dap.step_out)
K("<Leader>dww", function() dap.toggle() end)
K("<Leader>dw[", function() dap.toggle(1) end)
K("<Leader>dw]", function() dap.toggle(2) end)
K('<Leader>dr', dap.repl.open)
K('<Leader>dl', dap.run_last)
K('<Leader>dh', dap_widgets.hover, { mode = { 'n', 'v' } })
K('<Leader>dH', dap_widgets.preview, { mode = { 'n', 'v' } })
K('<Leader>dm', function() dap_widgets.centered_float(dap_widgets.frames) end)
K('<Leader>dM', function() dap_widgets.centered_float(dap_widgets.scopes) end)
K('<leader>dk', require 'dap.ui.widgets'.hover, { silent = true })

CMD("DapRunWithArgs", function(t)
  local args = vim.split(vim.fn.expand(t.args), '\n')
  if vim.fn.confirm(("Will try to run:\n%s %s %s\n? "):format(vim.bo.filetype, vim.fn.expand '%', t.args)) == 1 then
    dap.run({
      type = vim.bo.filetype == 'javascript' and 'pwa-node' or vim.bo.filetype == 'typescript' and 'pwa-node',
      request = 'launch',
      name = 'Launch file with custom arguments (adhoc)',
      program = '${file}',
      args = args,
    })
  end
end, { nargs = '*' })

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

require 'nvim-dap-virtual-text'.setup {}

AUC('FileType', {
  pattern = 'dap-repl',
  callback = function()
    cmp.setup.buffer { enabled = false }; require "dap.ext.autocompl".attach()
  end
})

require 'dap.ext.vscode'.load_launchjs(nil, {
  ["pwa-node"] = { "javascript", "typescript" },
  ["node"] = { "javascript", "typescript" },
  ["pwa-chrome"] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
  ["chrome"] = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' },
  -- ["python"] = { "python" },
  -- ["dlv"] = { "go" },
})

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = "jest --watch ",
      jestConfigFile = function() -- monorepo
        local file = vim.fn.expand('%:p')
        if file:find "/packages/" then
          return file:match "(.-/[^/]+/)src" .. "jest.config.ts"
        end
        return vim.fn.getcwd() .. "/jest.config.ts"
      end, cwd = function() -- monorepo
      local file = vim.fn.expand '%:p'
      if file:find "/packages/" then return file:match "(.-/[^/]+/)src" end
      return vim.fn.getcwd()
    end,
      env = { CI = true }
    },
    -- require 'neotest-vitest',
  }
}

K('<leader>tr', neotest.run.run)
K('<leadler>tf', function() neotest.run.run(vim.fn.expand '%') end)
K('<leader>td', function() neotest.run.run { strategy = 'dap' } end)
K('<leader>ts', neotest.run.stop)
K('<leader>ta', neotest.run.attach)

require 'languages'
-- require 'typescript'
