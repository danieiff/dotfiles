--[[
git diff COMMIT_HASH_1 COMMIT_HASH_2 | grep "your_search_term"
Gedit git-obj:filepath
0Gclog
Gclog --name-only

new
r! git show branch:file
file filename
filetype detect
set buftype=nowrite

!git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all

git diff-tree --no-commit-id --name-only -r $1

if | | else | | endif
]]

K, HL, CMD, AUC, AUG = function(lhs, rhs, opts)
      opts = opts or {}
      local mode = opts.mode or 'n'
      opts.mode = nil
      vim.keymap.set(mode, lhs, rhs, opts)
    end,
    vim.api.nvim_set_hl,
    vim.api.nvim_create_user_command,
    vim.api.nvim_create_autocmd,
    vim.api.nvim_create_augroup

local uname = vim.loop.os_uname()
PLATFORM = {
  mac = uname.sysname == 'Darwin',
  linux = uname.sysname == 'Linux',
  windows = uname.sysname:find 'Windows',
  wsl = IS_LINUX and uname.release:lower():find 'microsoft'
}

---@ Dependencies Management

DEPS_DIR = {
  pack = vim.fn.stdpath 'config' .. '/pack/my/start',
  bin = vim.fn.stdpath 'config'
}
DEPS_CACHE = {
  pack = vim.split(vim.fn.system('ls ' .. DEPS_DIR.pack), '\n'),
  npm = vim.split(vim.fn.system('npm -gp list | grep -Po "node_modules/\\K.*"'), '\n'),
  bin = vim.split(vim.fn.system('ls ' .. DEPS_DIR.bin), '\n')
}

local packages = {
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/NvChad/nvim-colorizer.lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  'https://github.com/mbbill/undotree',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/lewis6991/gitsigns.nvim',

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
  -- 'https://github.com/jcdickinson/codeium.nvim',
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

required_filetypes = {}
CMD('LoadRequiredFileTypes', function()
  for _, ft in ipairs(required_filetypes) do vim.bo.ft = ft end
end, { desc = "Install deps for each filetypes loaded in 'REQUIRE'" })

function REQUIRE(opt)
  local function require_internal(_cb)
    local executables, results, has_missing, reload_pack_required = {}, {}, false, false

    for _, dep in ipairs(opt.deps) do
      if type(dep) == 'string' then dep = { type = 'pack', arg = dep } end

      local cache_key, cmd = dep.cache_key, nil
      if dep.type == 'pack' then
        local destination = DEPS_DIR.pack .. '/' .. vim.fn.fnamemodify(dep.arg, ':t')
        cache_key = cache_key or vim.fn.fnamemodify(dep.arg, ':t')
        cmd = dep.tag and
            ('git clone %s %s && cd %s && git checkout %s'):format(dep.arg, destination, destination, dep.tag)
            or ('git clone --depth 1 %s %s'):format(dep.arg, destination)

        reload_pack_required = true
      elseif dep.type == 'npm' then
        cache_key = cache_key or dep.arg
        cmd = ('npm i -g %s%s'):format(dep.arg, dep.tag and ('@' .. dep.tag) or '')

        table.insert(executables, dep.executable and DEPS_DIR[dep.type] .. '/' .. dep.executable or dep.arg)
      elseif dep.type == 'bin' then
        cache_key = cache_key or dep.executable:gsub('/.*', '')
        cmd = ('cd %s && %s'):format(DEPS_DIR.bin, dep.arg)

        table.insert(executables, dep.executable and DEPS_DIR[dep.type] .. '/' .. dep.executable or dep.arg)
      end

      if vim.tbl_contains(DEPS_CACHE[dep.type], cache_key) then
        table.insert(results, true)
      else
        has_missing = true
        vim.fn.jobstart(cmd, {
          on_exit = function(_, code)
            local success = code == 0
            if success then table.insert(DEPS_CACHE[dep.type], cache_key) end
            vim.print((success and 'Installed ' or 'Install Failed ') .. cache_key)
            table.insert(results, success)
          end
        })
      end
    end

    if not has_missing then return opt.skip_cb_if_not_missing or _cb(unpack(executables)) end
    local timer = vim.loop.new_timer()
    timer:start(1000, 500, function()
      if #opt.deps == #results then
        timer:stop()
        if not vim.tbl_contains(results, false) then
          vim.schedule(function()
            if reload_pack_required then
              vim.cmd('set runtimepath^=' .. vim.fn.stdpath 'config' .. ' | runtime! plugin/**/*.{vim,lua}')
              vim.cmd('helptags ALL')
            end
            _cb(unpack(executables))
          end)
        end
      end
    end)
  end

  if opt.ft then
    vim.list_extend(required_filetypes, type(opt.ft) == 'table' and opt.ft or { opt.ft })
    local aug_id = AUG(required_filetypes[#required_filetypes], {})
    AUC('FileType', {
      pattern = opt.ft,
      group = aug_id,
      callback = function()
        vim.api.nvim_del_augroup_by_id(aug_id)
        require_internal(function(...)
          local config = opt.cb(...)
          if opt.lsp_mode and config then
            AUC('FileType', { pattern = opt.ft, callback = function() vim.lsp.start(config) end })
            vim.lsp.start(config)
          else
            AUC('FileType', { pattern = opt.ft, callback = opt.cb })
          end
        end
        )
      end
    })
  else
    require_internal(opt.cb)
  end
end

REQUIRE { deps = packages, cb = function() vim.cmd 'source $MYVIMRC | silent! tabdo windo edit' end, skip_cb_if_not_missing = true }

---@ Editor Config

for k, v in pairs {
  autowriteall = true, undofile = true,
  shell = (os.getenv 'SHELL' or 'bash') .. ' -l',
  ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true,
  pumblend = 30, winblend = 30, fillchars = 'eob: ',
  laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number',
  foldenable = false, foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()', foldtext = 'v:lua.vim.treesitter.foldtext()' }
do vim.opt[k] = v end

vim.g.mapleader = ' '

K('<C-h>', '<C-w>h')
K('<C-j>', '<C-w>j')
K('<C-k>', '<C-w>k')
K('<C-l>', '<C-w>l')
K('<C-w>-', '<cmd>resize -10<cr>')
K('<C-w>+', '<cmd>resize +10<cr>')
K('<C-w><', '<cmd>vertical resize -10<cr>')
K('<C-w>>', '<cmd>vertical resize +10<cr>')
K('<C-e>', ('<C-e>'):rep(10))
K('<C-y>', ('<C-y>'):rep(10))
K('<C-Left>', '<cmd>tabprevious<cr>', { silent = true, mode = { 'n', 't' } })
K('<C-Right>', '<cmd>tabnext<cr>', { silent = true, mode = { 'n', 't' } })
K('<C-Down>', '<cmd>bprevious<cr>', { silent = true })
K('<C-Up>', '<cmd>bnext<cr>', { silent = true })
K('<leader>w', vim.cmd.write)
K('<Leader>z', '<cmd>qa<cr>')
K('<Leader>Z', '<cmd>noautocmd qa<cr>')
K('<Leader>,', '<cmd>tabnew $MYVIMRC<cr>')
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
K('[Q', '<cmd>cfirst<cr>')
K(']Q', '<cmd>clast<cr>')
K('[l', '<cmd>lprevious<cr>')
K(']l', '<cmd>lnext<cr>')
K('[L', '<cmd>lfirst<cr>')
K(']L', '<cmd>llast<cr>')

K('<leader>ou', function()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local urls = {}
  for url in text:gmatch('(%a+://[%w-_%.%?%.:/%+=&]+)') do table.insert(urls, url) end
  if #urls > 1 then
    vim.ui.select(urls, {}, function(url) if url then vim.fn.jobstart('open ' .. vim.fn.escape(url, '#')) end end)
  end
end)

if PLATFORM.wsl then
  vim.g.clipboard = {
    copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    }
  }
end

vim.fn.digraph_setlist {
  { 'j[', '「' }, { 'j]', '」' }, { 'j{', '『' }, { 'j}', '』' }, { 'j<', '【' }, { 'j>', '】' },
  { 'js', '　' }, { 'j,', '、' }, { 'j.', '。' }, { 'jj', 'j' },
  -- emoji
  --┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐                          ┌────────┬────────┬────────┬────────┬────────┬────────┬────────┐
  --│        │        │        │        │        │        │        │                          │        │        │        │        │        │        │        │
  --├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │ ✨  💥 │ 🚨  🎨 │ 💡  🔊 │ 📝     │ 🔀 (⏪️)│        │                          │        │ ✅  🧪 │ 🤡  ⚗  │  🏷 🦺 │        │        │        │
  --├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │ 🐛  🚑 │ 🩹  ♻  │ 🔥  🚚 │  🗑 👽 │        │        │                          │        │ 👔  💸 │ 🧱  🗃 │ ⚡  🧵 │ 🔒  🛂 │        │        │
  --├────────┼────────┼────────┼────────┼────────┼────────┼───────
  --    ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │ 🚧  👷 │ 🔧  🔨 │ ➕  ➖ │  ⬆  ⬇  │ 🚀  🔖 │        │                          │        │ 💄  💫 │ 🚸  ♿ │ 📱  🔍 │ 📈  🌐 │ 💬  🍱 │        │
  --├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │
  --└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  { 'eq', '✨' }, { 'eQ', '💥' }, { 'ew', '🚨' }, { 'eW', '🎨' }, { 'ee', '💡' }, { 'eE', '🔊' }, {
  'er',
  '📝' },
  { 'ea', '🐛' }, { 'eA', '🚑' }, { 'es', '🩹' }, { 'eS', '♻' }, { 'ed', '🔥' }, { 'eD', '🚚' }, {
  'ef',
  '🗑' }, {
  'eF', '👽' },
  { 'ez', '🚧' }, { 'eZ', '👷' }, { 'ex', '🔧' }, { 'eX', '🔨' }, { 'ec', '➕' }, { 'eC', '➖' }, { 'ev',
  '⬆' }, {
  'eV', '⬇' }, { 'eb', '🚀' }, { 'eB', '🔖' },

  { 'ey', '✅' }, { 'eY', '🧪' }, { 'eu', '🤡' }, { 'eU', '⚗' }, { 'ei', '🏷' }, { 'eI', '🦺' }, { 'eo',
  '💬' }, {
  'eO', '🍱' },
  { 'eh', '👔' }, { 'eH', '💸' }, { 'ek', '🧱' }, { 'eK', '🗃' }, { 'el', '⚡' }, { 'eL', '🧵' }, {
  'e;',
  '🔒' }, {
  'e:', '🛂' },
  { 'en', '💄' }, { 'eN', '💫' }, { 'em', '🚸' }, { 'eM', '♿' }, { 'e,', '📱' }, { 'e<', '🔍' }, {
  'e.',
  '📈' }, {
  'e>', '🌐' }, { 'e/', '🔀' } --{ 'e?', '⏪️' },
}
K('<C-k>e?', '⏪️', { mode = { 'i' } })

AUC('FileType', { pattern = { 'json', 'jsonc', 'yaml', 'python', 'c', 'c++', 'go' }, command = 'set tabstop=4' })

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

OPEN_FILES = {}
local n = 0
AUC('BufEnter', {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value('modifiable', { buf = bufnr })
          and vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == ''
          and not vim.api.nvim_get_option_value('readonly', { buf = bufnr })
          and vim.api.nvim_get_option_value('filetype', { buf = bufnr }) ~= ''
          and vim.api.nvim_buf_get_name(bufnr) ~= ''
          and OPEN_FILES[bufnr] == nil then
        n = n + 1
        OPEN_FILES[bufnr] = {
          n = n,
          bufname = vim.fn.pathshorten(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.'))
        }
        K(n .. 'g', function() vim.api.nvim_win_set_buf(0, bufnr) end)
        K(n .. 'd', function() vim.api.nvim_win_set_buf(0, bufnr) end)
      end
    end
  end
})

vim.cmd 'set sessionoptions-=curdir'
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
local function mksession(dir)
  vim.cmd('silent! tabdo NvimTreeClose | mksession! ' .. vim.fn.fnameescape(normalize_session_path(dir)))
end
AUC('VimEnter', {
  callback = function()
    local vim_argv = vim.fn.argv()
    if not vim.tbl_contains(vim.v.argv, '--server') then return end
    if #vim_argv > 0 and vim_argv[1]:find '.git/COMMIT_EDITMSG' then return end
    if load_session_if_exists(vim.fn.getcwd()) then for _, path in ipairs(vim_argv) do vim.cmd.tabedit(path) end end
  end
})
AUC('VimLeave', { callback = function() mksession(vim.fn.getcwd()) end })
AUC('DirChangedPre', {
  callback = function()
    mksession(vim.g.prev_cwd); vim.cmd '%bwipe! | clearjumps'
  end
})
AUC('DirChanged', { callback = function(ev) load_session_if_exists(ev.file) end })

---@ Terminal

K('<Leader>t', function()
  local cmd = vim.fn.input { prompt = 'Start term: ', default = ' ', completion = 'shellcmd', cancelreturn = '' }
  vim.cmd('tabnew | term ' .. cmd); vim.cmd 'setlocal nonumber | startinsert'
end)
K('<C-n>', '<C-\\><C-n>', { mode = 't' })
AUC('TermClose', { callback = function(ev) vim.cmd('silent! bwipe!' .. ev.buf) end })

local function start_interactive_shell_job(cmds_params)
  for i, params in pairs(cmds_params) do
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_call(buf, function() vim.fn.termopen(params.cmd) end)
    local win = vim.api.nvim_open_win(buf, true,
      { relative = 'editor', width = 80, height = 20, row = (i - 1) * 20, col = 0, border = 'single' })
    vim.defer_fn(function() vim.api.nvim_win_close(win, false) end, 5000)
  end
end
CMD('RNExpo', function() start_interactive_shell_job { { cmd = 'emu' }, { cmd = 'rn-expo --android' } } end, {})
--
CMD('NpmRun', function()
  start_interactive_shell_job { { cmd = [[yq -r '.scripts | keys | join("\n")' package.json | npm run `fzf`]] } }
end, {})

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

---@ Git

K('<leader>gC', require 'telescope.builtin'.git_commits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits_range, { mode = { 'x' } })
K('<leader>gb', require 'telescope.builtin'.git_branches)
K('<leader>gs', require 'telescope.builtin'.git_stash)

K('<C-g>', '<cmd>tabnew | term lazygit<cr><cmd>set nonumber<cr><cmd>startinsert<cr>')

require 'gitsigns'.setup {
  signcolumn = false,
  numhl = true,
  word_diff = true,
  on_attach = function()
    local gs = package.loaded.gitsigns

    K(']h', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(gs.next_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(gs.prev_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('<leader>hs', ':Gitsigns stage_hunk<cr>', { mode = { 'n', 'v' } })
    K('<leader>hr', ':Gitsigns reset_hunk<cr>', { mode = { 'n', 'v' } })
    K('<leader>hu', gs.undo_stage_hunk)
    K('<leader>hp', gs.preview_hunk)
    K('<leader>hb', function() gs.blame_line { full = true } end)
    K('<leader>hB', gs.toggle_current_line_blame)
    K('<leader>hd', gs.toggle_deleted)
    K('ih', '<cmd>Gitsigns select_hunk<cr>', { mode = { 'o', 'v' } })
  end
}

AUC('FileType', {
  pattern = 'gitcommit',
  callback = function(ev)
    if not os.getenv 'OPENAI_API_KEY' then return end
    local firstline = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1]
    if firstline == '' then
      local cmd          = ([[curl https://api.openai.com/v1/chat/completions \
                              -H "Content-Type: application/json" \
                              -H "Authorization: Bearer %s \
                              -d '{
                                "model": "gpt-3.5-turbo",
                                "messages": [{"role": "user", "content": "Write a git conventional commit message from this git diff: %s"}],
                                "temperature": 0.7
      }']]):format(os.getenv 'OPENAI_API_KEY', vim.fn.system 'git diff --cached')
      local result       = vim.fn.system(cmd)
      local ok, json_tbl = pcall(vim.fn.json_decode, result)
      if not ok then return end
      local resultMessage = json_tbl.choices[1].message.content
      vim.api.nvim_buf_set_lines(ev.buf, 0, 1, false, vim.fn.join(resultMessage, '\n'))
    end
  end
})

---@ TreeSitter

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'javascript', 'typescript', 'tsx', 'html', 'css', 'vue', 'svelte', 'astro',
    'python', 'php', 'ruby', 'lua', 'bash',
    'c', 'java', 'go', 'rust',
    'yaml', 'toml', 'json', 'jsonc', 'comment', 'markdown', 'markdown_inline',
    'gitcommit', 'git_config', 'git_rebase',
    'dockerfile', 'sql', 'prisma', 'graphql', 'regex'
  },
  highlight = { enable = true }
}

require 'ibl'.setup()
require 'treesitter-context'.setup()

require 'ts_context_commentstring'.setup { enable_autocmd = false }
require 'Comment'.setup { pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook() }

require 'nvim-surround'.setup()
require 'nvim-ts-autotag'.setup { enable_close_on_slash = false, }
require 'nvim-autopairs'.setup { disable_in_visualblock = true, fast_wrap = { map = '<C-]>' } } -- <C-h> to delete only '('

require 'treesj'.setup { use_default_keymaps = false }
K('L', require 'treesj'.toggle)

K("w", "<cmd>lua require 'spider' .motion 'w' <cr>", { mode = { "n", "o", "x" } })
K("e", "<cmd>lua require 'spider' .motion 'e' <cr>", { mode = { "n", "o", "x" } })
K("b", "<cmd>lua require 'spider' .motion 'b' <cr>", { mode = { "n", "o", "x" } })
K("ge", "<cmd>lua require 'spider' .motion 'ge' <cr>", { mode = { "n", "o", "x" } })

require 'flash'.setup { label = { uppercase = false }, modes = { search = { enabled = false } } }
K('f', require 'flash'.jump, { mode = { "n", "x", "o" } })
K('r', require 'flash'.remote, { mode = { "o" } })
K('v,', require 'flash'.treesitter, { mode = { "n", "x", "o" } })
K('v;', require 'flash'.treesitter_search, { mode = { "n", "x", "o" } })

require 'syntax-tree-surfer'.setup()
K("vV", '<cmd>STSSelectMasterNode<cr>')
K("vv", '<cmd>STSSelectCurrentNode<cr>')
K("J", '<cmd>STSSelectNextSiblingNode<cr>', { mode = 'x' })
K("K", '<cmd>STSSelectPrevSiblingNode<cr>', { mode = 'x' })
K("H", '<cmd>STSSelectParentNode<cr>', { mode = 'x' })
K("L", '<cmd>STSSelectChildNode<cr>', { mode = 'x' })

K("vS", "<cmd>STSSwapOrHold<cr>")
K("vS", "<cmd>STSSwapOrHoldVisual<cr>", { mode = { "x" } })
K("vu", function()
  vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vd", function()
  vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vn", '<cmd>STSSwapNextVisual<cr>', { mode = { "x" } })
K("vn", function()
  vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vp", '<cmd>STSSwapPrevVisual<cr>', { mode = { "x" } })
K("vp", function()
  vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"; return "g@l"
end, { expr = true, silent = true })

K('vI',
  function()
    require "syntax-tree-surfer".go_to_top_node_and_execute_commands(false,
      { "normal! O", "normal! O", "startinsert" })
  end
)

---@ Coding Support

require 'regexplainer'.setup()

require 'chatgpt'.setup {}

-- require 'codeium'.setup {}

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
        if vim.fn.pumvisible() == 0 then
          vim.api.nvim_feedkeys(require 'cmp.utils.keymap'.t('<C-z>'), 'in', true)
        else
          vim.api.nvim_feedkeys(require 'cmp.utils.keymap'.t('<C-n>'), 'in', true)
        end
      else
        if not cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace } then fallback() end
      end
    end, { 'i', 's', 'c' }),
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'rg',      keyword_length = 3 },
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
cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, { sources = cmp.config.sources { { name = 'vim-dadbod-completion' } } })

---@ LSP

-- vim.lsp.set_log_level 'DEBUG' -- :LspLog
CMD('LspRestart', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd.edit()', {})
CMD('LspConfigReference', function(ev)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    col = 0,
    row = 0,
    width = vim.o.columns,
    height = vim.o.lines,
  })
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false,
    vim.fn.systemlist(('curl -fsSL https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/server_configurations/%s.lua')
      :format(ev.args)))
  vim.bo[bufnr].filetype = 'lua'
  K('q', '<cmd>q!<cr>', { buffer = bufnr })
end, { nargs = '?' })
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
K("<Leader>ds", dap.continue)
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
  -- ["cppdbg"] = { "c", "cpp" },
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
    require 'neotest-vitest',
  }
}

K('<leader>tr', neotest.run.run)
K('<leadler>tf', function() neotest.run.run(vim.fn.expand("%")) end)
K('<leader>td', function() neotest.run.run { strategy = 'dap' } end)
K('<leader>ts', neotest.run.stop)
K('<leader>ta', neotest.run.attach)

require 'languages'
require 'typescript'

require 'ui'

-- :G merge origin/<branch> --no-ff --no-edit

local function toggleFugitiveGit()
  if vim.fn.buflisted(vim.fn.bufname('fugitive:///*/.git//$')) ~= 0 then
    vim.cmd [[ execute ':bdelete' bufname('fugitive:///*/.git//$') ]]
  else
    vim.cmd [[G]]
  end
end
vim.keymap.set('n', ';g', toggleFugitiveGit, {})
