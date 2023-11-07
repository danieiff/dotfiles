---@ Package management

local packages = {
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/NvChad/nvim-colorizer.lua",
  "https://github.com/nvim-lualine/lualine.nvim",

  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/simrat39/symbols-outline.nvim",
  'https://github.com/RRethy/vim-illuminate',

  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/numToStr/Comment.nvim",
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/danieiff/nvim-ts-autotag",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/ggandor/leap.nvim",
  "https://github.com/mbbill/undotree",

  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/lukas-reineke/cmp-rg",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/danieiff/friendly-snippets",
  "https://github.com/jcdickinson/codeium.nvim",
  "https://github.com/jackMort/ChatGPT.nvim",

  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/pwntester/octo.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",

  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/glepnir/lspsaga.nvim",
  "https://github.com/ray-x/lsp_signature.nvim",
  "https://github.com/VidocqH/lsp-lens.nvim",
  "https://github.com/lvimuser/lsp-inlayhints.nvim",

  "https://github.com/danieiff/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-neotest/neotest-jest",
}
vim.g.packdir = vim.fn.stdpath 'config' .. '/pack/tett/start'

if vim.tbl_get(vim.loop.fs_stat(vim.g.packdir) or {}, 'type') ~= 'directory' then
  os.execute('mkdir -p ' .. vim.g.packdir)
end

vim.fn.jobstart({ 'ls' },
  {
    cwd = vim.g.packdir,
    stdout_buffered = true,
    on_stdout = function(_, data)
      vim.g.packages = data
      local packages_not_downloaded = vim.tbl_filter(
        function(p) return not vim.tbl_contains(data, vim.fn.fnamemodify(p, ':t')) end,
        packages)
      if #packages_not_downloaded == 0 then return end
      local package_download_jobs = {}
      for _, url in ipairs(packages_not_downloaded) do
        local jobid = vim.fn.jobstart('git clone --depth 1 ' .. url, {
          cwd = vim.g.packdir,
          stderr_buffered = true,
          on_stderr = function(_, log) if #log > 2 then vim.print(log) end end
        })
        table.insert(package_download_jobs, jobid)
      end
      local allSuccess = true
      for i, status in ipairs(vim.fn.jobwait(package_download_jobs)) do
        if status == 0 then
          vim.print('Downloaded ' .. packages_not_downloaded[i])
        else
          allSuccess = false
          vim.print(('Failed to download %s, status: %s'):format(
            packages_not_downloaded[i], status))
        end
      end
      if allSuccess then vim.cmd 'source $MYVIMRC' end
    end,
    on_stderr = function(_, e) if #e ~= 1 or e[1] ~= '' then vim.print(e) end end
  })

vim.g.npm_list = vim.fn.system('npm -g list -p')

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

---@ Misc Options, Keymap

for k, v in pairs {
  autowriteall = true, undofile = true,
  shell = (os.getenv 'SHELL' or 'bash') .. ' -l',
  virtualedit = 'block',
  ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true,
  pumblend = 30, winblend = 30, fillchars = 'eob: ',
  laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number',
  foldmethod = 'expr', foldexpr = vim.treesitter.foldexpr(), foldenable = false }
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
K('<C-Left>', '<cmd>tabprevious<cr>', { silent = true })
K('<C-Right>', '<cmd>tabnext<cr>', { silent = true })
K('<C-Down>', '<cmd>bprevious<cr>', { silent = true })
K('<C-Up>', '<cmd>bnext<cr>', { silent = true })
K('<leader>w', vim.cmd.write)
K('<leader>W', '<cmd>noautocmd w<cr>')
K('<Leader>q', '<cmd>q<cr>')
K('<Leader>Q', '<cmd>q!<cr>')
K('<Leader>z', '<cmd>qa<cr>')
K('<Leader>Z', '<cmd>qa!<cr>')
K('<Leader>,', '<cmd>tabnew $MYVIMRC<cr>')
K('<Leader>.,', '<cmd>write<cr><cmd>source $MYVIMRC<cr><cmd>helptags ALL<cr>')
K('<Leader>s', ':%s///g' .. ('<Left>'):rep(3))
K('<Leader>s', ':s///g' .. ('<Left>'):rep(3), { mode = 'v' })
K('Y', 'y$')
K('vp', '`[v`]')
K('+', '<C-a>', { mode = { 'n', 'v' } })
K('-', '<C-x>', { mode = { 'n', 'v' } })
K('<cr>', '<cmd>call append(expand("."), "")<cr>j')
K('<bs>', '<cmd>call append(line(".")-1, "")<cr>k')
K('<leader>bl', function()
  local bool = { 'true', 'false' }
  vim.cmd('normal ciw' .. bool[2 - vim.fn.index(bool, vim.fn.expand '<cword>')])
end)
K('[q', ':cprevious<cr>')
K(']q', ':cnext<cr>')
K('[Q', ':<C-u>cfirst<cr>')
K(']Q', ':<C-u>clast<cr>')

K('<leader>ou', function()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local urls = {}
  for url in text:gmatch('(%a+://[%w-_%.%?%.:/%+=&]+)') do table.insert(urls, url) end
  if #urls > 1 then
    vim.ui.select(urls, {}, function(url)
      vim.fn.jobstart('open ' .. vim.fn.escape(url, '#'))
    end)
  end
end)

if vim.fn.executable 'wslpath' ~= '' then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 1,
  }
end

vim.fn.digraph_setlist {
  { 'j[', '「' }, { 'j]', '」' }, { 'j{', '『' }, { 'j}', '』' }, { 'j<', '【' }, { 'j>', '】' },
  { 'js', '　' }, { 'j,', '、' }, { 'j.', '。' }, { 'jj', 'j' },
  { 'j1', '１' }, { 'j2', '２' }, { 'j3', '３' }, { 'j4', '４' }, { 'j5', '５' },
  { 'j6', '６' }, { 'j7', '７' }, { 'j8', '８' }, { 'j9', '９' }, { 'j0', '０' },
  -- "e"moji
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

AUC('FileType', { pattern = { 'json', 'jsonc', 'yaml', 'python' }, command = 'set tabstop=4' })


---@ Terminal

local fzf_lua_img_previewer = { 'viu' }

K('<Leader>t', function()
  local cmd = vim.fn.input { prompt = 'Command: ', completion = 'shellcmd', cancelreturn = '' }
  if cmd ~= '' then
    vim.cmd('tabnew | term ' .. cmd); vim.cmd 'startinsert'
  end
end)
K('<C-n>', '<C-\\><C-n>', { mode = 't' })
K('<C-o>', '<C-\\><C-n><C-o>', { mode = 't' })
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
CMD('NpmRun',
  function()
    start_interactive_shell_job { {
      cmd = [[yq -r '.scripts | keys | join('\n')' package.json | npm run `fzf`]] } }
  end
  , {})

---@ General Tools, Plugins

require 'telescope'.setup {}

local fzf_lua = require 'fzf-lua'
local fzf_lua_previewer_builtin = require 'fzf-lua.previewer.builtin'
fzf_lua.setup {
  keymap = {
    builtin = {
      ["<F1>"]     = "toggle-help",
      ["<F2>"]     = "toggle-fullscreen",
      ["<F3>"]     = "toggle-preview-wrap",
      ['<C-down>'] = 'preview-page-down',
      ['<C-up>']   = 'preview-page-up',
      ['<C-left>'] = 'preview-page-reset',
    },
  },
  previewers = {
    builtin = {
      extensions = {
        ['png'] = fzf_lua_img_previewer,
        ['jpg'] = fzf_lua_img_previewer,
        ['jpeg'] = fzf_lua_img_previewer,
        ['gif'] = fzf_lua_img_previewer,
      }
    }
  }
}

K('<leader> ', fzf_lua.resume)
K('<leader>f', fzf_lua.files)
K('<leader>b', fzf_lua.buffers)
K('<leader>j', fzf_lua.jumps)
K('<leader>m', fzf_lua.marks)
K('<Leader>h', fzf_lua.help_tags)
K('<leader>M', fzf_lua.man_pages)
K('<leader>c', fzf_lua.commands)
K('<leader>C', fzf_lua.command_history)
K('<leader>fa', fzf_lua.autocmds)
K('<leader>r', fzf_lua.registers)

K('<leader>lq', fzf_lua.quickfix)
K('<leader>lQ', fzf_lua.quickfix_stack)
K('<leader>ll', fzf_lua.loclist)
K('<leader>lL', fzf_lua.loclist_stack)

-- search
K('<leader>/', fzf_lua.lgrep_curbuf)
K('<leader>)', fzf_lua.live_grep_native)
K('<leader>(', fzf_lua.live_grep_resume)
K('<leader>[', fzf_lua.grep_cword)
K('<leader>{', fzf_lua.grep_cWORD)
K('<leader>]', fzf_lua.grep_project)
-- grep_curbuf	search current buffer lines
-- lgrep_curbuf	live grep current buffer
-- live_grep	live grep current project
-- live_grep_resume	live grep continue last search
-- live_grep_glob	live_grep with rg --glob support
-- live_grep_native	performant version of live_grep
K('<leader>?', fzf_lua.search_history)
-- dap
-- lsp
K('<leader>lf', fzf_lua.lsp_finder)
K('<leader>fd', function() fzf_lua.lsp_definitions({ jump_to_single_result = true }) end)
-- git
K('<leader>gf', function()
  local opts = {}
  local git_root = fzf_lua.path.git_root(opts)
  local relative = fzf_lua.path.relative(vim.loop.cwd(), git_root)
  opts.fzf_opts = { ['--query'] = git_root ~= relative and relative or nil }
  return fzf_lua.git_files(opts)
end)
K('<leader>gS', fzf_lua.git_stash)
K('<leader>gc', fzf_lua.git_commits)
K('<leader>gC', fzf_lua.git_bcommits)
K('<leader>gb', fzf_lua.git_branches)

K('<C-q>', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.regex('^term://.*:lazygit$'):match_str(vim.api.nvim_buf_get_name(buf)) then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          return vim.api.nvim_win_close(win, true)
        end
      end
      return vim.cmd('tabnew | b' .. buf)
    end
  end
  return vim.cmd 'tabnew | term lazygit'
end, { mode = { 'n', 't' } })

require 'octo'.setup {}

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
    K('<leader>hS', gs.stage_buffer)
    K('<leader>hu', gs.undo_stage_hunk)
    K('<leader>hR', gs.reset_buffer)
    K('<leader>hp', gs.preview_hunk)
    K('<leader>hb', function() gs.blame_line { full = true } end)
    K('<leader>tb', gs.toggle_current_line_blame)
    K('<leader>hd', gs.diffthis)
    K('<leader>hD', function() gs.diffthis '~' end)
    K('<leader>td', gs.toggle_deleted)

    K('ih', '<cmd>Gitsigns select_hunk<cr>', { mode = { 'o', 'x' } })
  end
}

require 'diffview'.setup {}
-- :DiffviewOpen origin/HEAD...HEAD --imply-local
--  man git-rev-parse(1)
-- If you're reviewing a big PR composed of many commits, you might prefer to review the changes introduced in each of those commits individually. To do this, you can use :DiffviewFileHistory:
-- :DiffviewFileHistory --range=origin/HEAD...HEAD --right-only --no-merges

-- symmetric_diff_revs is different between git-log and git-diff
-- Whereas in git-diff it compares against the merge-base, here it will select only the commits that are reachable from either origin/HEAD or HEAD, but not from both (in other words, it's actually performing a symmetric difference here).
-- We then use the cherry-pick option --right-only to limit the commits to only those on the right side of the symmetric difference. Finally --no-merges filters out merge commits. We are left with a list of all the non-merge commits from the PR branch.

-- default_args = { DiffviewOpen = { "--imply-local" }, }

-- Hide untracked files: DiffviewOpen -uno
-- Exclude certain paths: DiffviewOpen -- :!exclude/this :!and/this
-- Run as if git was started in a specific directory: DiffviewOpen -C/foo/bar/baz
-- Diff the index against a git rev: DiffviewOpen HEAD~2 --cached
-- Defaults to HEAD if no rev is given.
-- :h jumpto-diffs diffview-merge-tool diffview-config-view.x.layout copy-diffs

AUC('FileType', {
  pattern = 'gitcommit',
  callback = function(ev)
    if not os.getenv 'OPENAI_API_KEY' then return end
    local firstline = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1]
    if firstline == '' then
      local cmd           = ([[curl https://api.openai.com/v1/chat/completions \
                              -H "Content-Type: application/json" \
                              -H "Authorization: Bearer %s \
                              -d '{
                                "model": "gpt-3.5-turbo",
                                "messages": [{"role": "user", "content": "Write a git conventional commit message from this git diff: %s"}],
                                "temperature": 0.7
      }']]):format(os.getenv 'OPENAI_API_KEY', vim.fn.system 'git diff --cached')
      local result        = vim.fn.system(cmd)
      local resultMessage = vim.json_decode(result).choices[1].message.content
      vim.api.nvim_buf_set_lines(ev.buf, 0, 1, false, vim.fn.join(resultMessage, '\n'))
    end
  end
})

require "nvim-tree".setup()
K('<C-t>', '<cmd>NvimTreeFocus<cr>')

require 'symbols-outline'.setup {}

AUC('InsertLeave', {
  callback = function(ev)
    if vim.api.nvim_buf_get_option(ev.buf, 'modifiable')
        and vim.api.nvim_buf_get_option(ev.buf, 'buftype') == ''
        and not vim.api.nvim_buf_get_option(ev.buf, 'readonly')
        and vim.api.nvim_buf_get_option(ev.buf, 'filetype') ~= ''
        and vim.api.nvim_buf_get_name(ev.buf) ~= '' then
      vim.cmd.write()
    end
  end,
  nested = true
})


require 'leap'.add_default_mappings()

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { 'bash', 'lua', 'python', 'javascript', 'typescript', 'html', 'css', 'vue', 'svelte',
    'astro',
    'yaml', 'toml', 'json', 'jsonc', 'comment', 'sql', 'prisma', 'ruby', 'php',
    'gitcommit', 'git_config', 'git_rebase',
    'go', 'java', 'c', 'cmake', 'c_sharp', 'java', 'kotlin',
    'rust', 'jsonc', 'graphql', 'dockerfile', 'vim', 'tsx', 'markdown', 'markdown_inline' },
  highlight = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  },
  autotag = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn', -- set to `false` to disable one of the mappings
      node_incremental = 'gnN',
      scope_incremental = 'gns',
      node_decremental = 'gnd',
    }
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']c'] = { query = '@class.outer', desc = 'Next class start' },
        [']l'] = '@loop.*',                                                         -- regex pattern
        [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' }, -- query_group from `queries/<lang>/<query_group>.scm`
        [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
      goto_next = {
        [']i'] = '@conditional.outer',
      },
      goto_previous = {
        ['[i'] = '@conditional.outer',
      }
    }
  }
}

require 'ibl'.setup()

require 'Comment'.setup {
  pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
  toggler = { line = 'gcc', block = 'gbc' }, --LHS of toggle mappings in NORMAL mode
  opleader = { line = 'gc', block = 'gb' },  --LHS of operator-pending mappings in NORMAL and VISUAL mode
}
require 'nvim-surround'.setup()
require 'nvim-autopairs'.setup()

require 'codeium'.setup {}

local luasnip = require 'luasnip'

require 'luasnip.loaders.from_vscode'.lazy_load()
for k, v in pairs({ ['typescriptreact'] = { 'javascript' }, ['typescript'] = { 'javascript' } }) do
  luasnip.filetype_extend(k, v)
end
-- TODO: glob '*.code-snippets' and pass if exists
if vim.loop.fs_stat '.code-snippets' then require "luasnip.loaders.from_vscode".load_standalone({ path = ".code-snippets" }) end

K("<C-L>", function() luasnip.jump(1) end, { silent = true, mode = { "i", "s" } })
K("<C-J>", function() luasnip.jump(-1) end, { silent = true, mode = { "i", "s" } })
K("<C-E>", function() if luasnip.choice_active() then luasnip.change_choice(1) end end,
  { silent = true, mode = { "i", "s" } })
K("<C-j>", luasnip.expand, { silent = true, mode = { 'i', 's' } })
K("<C-l>", function() if luasnip.choice_active() then luasnip.change_choice(1) end end,
  { silent = true, mode = { 'i', 's' } })

local cmp = require 'cmp'
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-space>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.select_next_item({ behavior = require 'cmp.types'.cmp.SelectBehavior.Insert })
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        cmp.mapping.complete()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.expand_or_locally_jumpable() and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({ { name = 'nvim_lsp' } --[[, { name = 'luasnip' } ]],
    { name = 'rg',      keyword_length = 3 },
    { name = 'codeium' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.tbl_map(vim.api.nvim_win_get_buf,
            vim.api.nvim_list_wins())
        end,
        indexing_interval = 1500
      }
    }
  }),
  sorting = {
    comparators = {
      function(...) return require 'cmp_buffer':compare_locality(...) end,
    }
  },
  view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', ({
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
        Codeium = "",
      })[vim_item.kind], vim_item.kind)
      vim_item.menu = ({ buffer = "[Buffer]", nvim_lsp = "[LSP]", luasnip = "[LuaSnip]", nvim_lua =
          "[Lua]", rg =
          "[rg]", codeium = "[Codeium]" })
          [entry.source.name]
      return vim_item
    end
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
})

cmp.setup.filetype('gitcommit',
  {
    sources = cmp.config.sources({ { name = 'luasnip' }, { name = 'codeium' } },
      { { name = 'buffer', option = { indexing_interval = 1500 } } })
  })
cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
cmp.event:on('confirm_done', require 'nvim-autopairs.completion.cmp'.on_confirm_done())

---@ Lsp

local function will_rename_callback(data)
  local Path = require 'plenary.path'

  local function validatePath(_path)
    local path = Path:new(_path)
    local absolute_path = path:absolute()
    if (path:is_dir() and absolute_path:match('/$')) then absolute_path = path .. '/' end
    return absolute_path
  end

  local function validatePathWithFilter(_oldPath, filters)
    local path = validatePath(_oldPath)
    local is_dir = Path:new(path):is_dir()

    for _, filter in ipairs(filters) do
      local pattern = filter.pattern
      local match_type = pattern.matches
      local matched
      if not match_type or
          (match_type == 'folder' and is_dir) or
          (match_type == 'file' and not is_dir)
      then
        local regex = vim.fn.glob2regpat(pattern.glob)
        if pattern.options and pattern.options.ignorecase then regex = '\\c' .. regex end
        local previous_ignorecase = vim.o.ignorecase
        vim.o.ignorecase = false
        matched = vim.fn.match(path, regex) ~= -1
        vim.o.ignorecase = previous_ignorecase
      end
      if (matched) then return end
    end
  end

  for _, client in pairs(vim.lsp.get_active_clients()) do
    local success, will_rename = pcall(function()
      return client.server_capabilities.workspace.fileOperations
          .willRename
    end)
    if (success and will_rename ~= nil) then
      local will_rename_params = {
        files = {
          {
            oldUri = validatePathWithFilter(
              data and data.old_name or vim.fn.expand('%'), will_rename
              .filters),
            newUri = validatePath(data and data.new_name or
              vim.uri_from_fname(vim.fn.expand('%:p:h') ..
                '/' .. vim.fn.input('New name: ')))
          }
        }
      }
      local resp = client.request_sync('workspace/willRenameFiles', will_rename_params, 1000)
      print(vim.inspect(resp))
      local edit = resp.result
      if (edit ~= nil) then vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding) end
    end
  end
end

CMD('RenameFile', will_rename_callback, { bar = true })

-- vim.lsp.set_log_level'debug' -- :LspLog
CMD('LspRestart', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()) | edit', {})
CMD('LspCapa', function()
  local clients = vim.lsp.buf_get_clients()
  vim.ui.select(vim.tbl_map(function(item) return item.name end, clients), {},
    function(choice, idx)
      if choice == nil then return end
      local popup = require 'nui.popup' ({
        enter = true,
        focusable = true,
        position = "50%",
        size = { width = "80%", height = "60%", },
      })
      popup:mount()
      popup:on(require 'nui.utils.autocmd'.event.BufLeave, function() popup:unmount() end)
      vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false,
        vim.split(vim.inspect(clients[idx].server_capabilities), "\n"))
    end)
end, {})

require 'lsp-lens'.setup {}
require 'lsp-inlayhints'.setup {}
require 'lsp_signature'.setup {}
K('<leader>gG', function()
  local sig_client
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.server_capabilities.signatureHelpProvider then
      sig_client = client; break
    end
  end
  if not sig_client then return vim.notify '<leader>gG no sig clients' end

  local trigger_chars = vim.list_extend(
    vim.tbl_get(sig_client, 'server_capabilities', 'signatureHelpProvider', 'triggerCharacters') or {},
    vim.tbl_get(sig_client, 'server_capabilities', 'signatureHelpProvider', 'retriggerCharacters') or {}
  )

  local line_after_cursor = vim.api.nvim_get_current_line():sub(vim.fn.getcursorcharpos(0)[3])
  vim.notify(line_after_cursor)
  local trigger_char = nil
  for _, c in ipairs(trigger_chars) do
    local s, e = line_after_cursor:find('(' .. vim.pesc(c) .. ').*$')
    if s and e then
      trigger_char = line_after_cursor:sub(s, s); break
    end
  end

  sig_client.request('textDocument/signatureHelp',
    vim.tbl_extend('force', vim.lsp.util.make_position_params(0, sig_client.offset_encoding),
      {
        context = {
          triggerKind = 2,
          triggerCharacter = trigger_char,
          isRetrigger = false,
          activeSignatureHelp = nil
        }
      }),
    function(_, signature_help) vim.print(signature_help) end)

  -- vim.lsp.buf_request(0,
  --   'textDocument/signatureHelp',
  --   vim.lsp.util.make_position_params(),
  --   vim.lsp.with(function(res) vim.print(res) end, {
  --     -- trigger_from_cursor_hold = true,
  --     -- border = _LSP_SIG_CFG.handler_opts.border,
  --     -- line_to_cursor = line_to_cursor:sub(1, trigger_position),
  --     -- triggered_chars = trigger_chars,
  --   })
  -- )
end)

local augroup_lsp = AUG('UserLspAUG', {})

AUC('LspAttach', {
  group = AUG('UserLspConfigAUG', {}),
  callback = function(ev)
    K('[e', vim.diagnostic.goto_prev)
    K(']e', vim.diagnostic.goto_next)
    K('[E', function() vim.diagnostic.goto_prev { severity = 1 } end)
    K(']E', function() vim.diagnostic.goto_next { severity = 1 } end)
    K('<leader>d', vim.diagnostic.open_float)
    K('<leader>D', vim.diagnostic.setloclist)
    K('<leader>dq', vim.diagnostic.setqflist)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client.server_capabilities.inlayHintProvider then
      require 'lsp-inlayhints'.on_attach(client, ev.buf)
    end

    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { group = augroup_lsp, buffer = ev.buf }

      AUC('BufWritePre', {
        group = augroup_lsp,
        buffer = ev.buf,
        callback = function() vim.lsp.buf.format { bufnr = ev.buf } end
      })
    end

    -- if client.server_capabilities.documentSymbolProvider then
    --   require('neo-tree.command').execute({ action = 'show', source = 'document_symbols', position = 'right', })
    -- end

    -- AUC({ 'CursorHold', 'CursorHoldI' }, { callback = vim.diagnostic.open_float })
    -- AUC({ 'CursorHold', 'CursorHoldI' }, { callback = function() vim.diagnostic.open_float(nil, { float = false }) end })

    -- if client.supports_method 'textDocument/codeAction' then
    --   local function code_action_listener()
    --     local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    --     local params = vim.lsp.util.make_range_params()
    --     params.context = context
    --     vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx, config)
    --       -- do something with result - e.g. check if empty and show some indication such as a sign
    --     end)
    --   end
    --
    --   AUC({ 'CursorHold', 'CursorHoldI' }, { callback = code_action_listener })
    -- end

    K('gd', vim.lsp.buf.definition)
    K('gt', vim.lsp.buf.type_definition)
    K('gr', vim.lsp.buf.references)
    K('gi', vim.lsp.buf.implementation)
    K('gl', vim.lsp.buf.declaration)
    K('K', vim.lsp.buf.hover)
    K('<leader>sh', vim.lsp.buf.signature_help)
    K('<space>wa', vim.lsp.buf.add_workspace_folder)
    K('<space>wr', vim.lsp.buf.remove_workspace_folder)
    K('<space>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end)
    K('<space>rn', vim.lsp.buf.rename)
    K('<space>ca', vim.lsp.buf.code_action)
    K('<Leader>ci', vim.lsp.buf.incoming_calls)
    K('<Leader>co', vim.lsp.buf.outgoing_calls)

    require 'lspsaga'.setup({ symbol_in_winbar = { enable = true } })
    K('gp', '<cmd>Lspsaga peek_definition<cr>') -- supports definition_action_keys tagstack. Use <C-t> to jump back
    K('gP', '<cmd>Lspsaga peek_definition<cr>')
    K('<leader>sb', '<cmd>Lspsaga show_buf_diagnostics<cr>')
    K('<leader>sw', '<cmd>Lspsaga show_workspace_diagnostics<cr>')
    K('<leader>sc', '<cmd>Lspsaga show_cursor_diagnostics<cr>')
    K('[e', '<cmd>Lspsaga diagnostic_jump_prev<cr>')
    K(']e', '<cmd>Lspsaga diagnostic_jump_next<cr>')
    K('gk', '<cmd>Lspsaga hover_doc ++keep<cr>') -- press twice to close
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

CMD("RunScriptWithArgs", function(t)
  local args = vim.split(vim.fn.expand(t.args), '\n')
  if vim.fn.confirm(("Will try to run:\n    %s %s %s\n\nDo you approve? "):format(vim.bo.filetype, vim.fn.expand '%', t.args),
        "&Yes\n&No", 1) == 1 then
    dap.run({
      type = 'pwa-chrome', --vim.bo.filetype,
      request = 'launch',
      name = 'Launch file with custom arguments (adhoc)',
      program = '${file}',
      args = args,
    })
  end
end, { complete = 'file', nargs = '*' })

-- dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
--   local notif_data = get_notif_data("dap", body.progressId)
--
--   local message = format_message(body.message, body.percentage)
--   notif_data.notification = vim.notify(message, "info", {
--     title = format_title(body.title, session.config.type),
--     icon = spinner_frames[1],
--     timeout = false,
--     hide_from_history = false,
--   })
--
--   notif_data.notification.spinner = 1,
--       update_spinner("dap", body.progressId)
-- end
--
-- dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
--   local notif_data = get_notif_data("dap", body.progressId)
--   notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
--     replace = notif_data.notification,
--     hide_from_history = false,
--   })
-- end
--
-- dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
--   local notif_data = client_notifs["dap"][body.progressId]
--   notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
--     icon = "",
--     replace = notif_data.notification,
--     timeout = 3000
--   })
--   notif_data.spinner = nil
-- end

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "<leader>dk" then
        table.insert(keymap_restore, keymap)
        vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
      end
    end
  end
  K('<leader>dk', require 'dap.ui.widgets'.hover, { silent = true })
end
dap.listeners.after['event_terminated']['me'] = function()
  for _, keymap in pairs(keymap_restore) do
    vim.api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs,
      { silent = not not keymap.silent })
  end
  keymap_restore = {}
end

require 'nvim-dap-virtual-text'.setup {}

AUC('FileType', {
  pattern = 'dap-repl',
  callback = function()
    cmp.setup.buffer { enabled = false }
    require "dap.ext.autocompl".attach()
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

---@ Test

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = "jest --watch ",
      jestConfigFile = "custom.jest.config.ts",
      -- jestConfigFile = function() -- monorepo
      --   local file = vim.fn.expand('%:p')
      --   if file:find "/packages/" then
      --     return file:match "(.-/[^/]+/)src" .. "jest.config.ts"
      --   end
      --   return vim.fn.getcwd() .. "/jest.config.ts"
      -- end,
      env = { CI = true },
      -- cwd = function() -- monorepo
      --   local file = vim.fn.expand '%:p'
      --   if file:find "/packages/" then
      --     return file:match "(.-/[^/]+/)src"
      --   end
      --   return vim.fn.getcwd()
      -- end,
      cwd = function(path) return vim.fn.getcwd() end,
    },
  }
}
K("<leader>tw", function() neotest.run.run({ jestCommand = 'jest --watch ' }) end)

require 'typescript'
require 'bash'
require 'misc_lang'

---@ UI

require 'nightfox'.setup { options = { transparent = true, inverse = { search = true } } }
vim.cmd 'colorscheme nordfox'

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

local function status_line()
  local default_status_colors = { saved = '#228B22', modified = '#C70039' }
  -- vim.bo.modified
  -- local tail_space = vim.fn.search([[\s\+$]], 'nwc')

  local statusline = vim.fn.join(vim.tbl_filter(function(item) return item ~= nil end, {
    vim.g.gitsigns_head,
    '%F',
  }), ' ')

  vim.opt.statusline = statusline
end
-- AUC('CursorMoved', { callback = status_line })

require 'lualine'.setup {
  extensions = { 'quickfix', 'nvim-dap-ui' },
  sections = {
    lualine_a = { { 'b:gitsigns_head' } },
    lualine_b = { {
      'diff',
      source = function()
        return vim.tbl_deep_extend('force', vim.b.gitsigns_status_dict or {},
          { mode = vim.tbl_get(vim.b, 'gitsigns_status_dict', 'changed') })
      end
    }, 'diagnostics', 'searchcount' },
    lualine_c = { 'buffers' },
    lualine_x = { 'windows' },
    lualine_y = { { function() return vim.fn['codeium#GetStatusString']() end } },
    lualine_z = { 'progress' }
  }
}

local progress_token_to_title = {}
local progress_title_to_order = {}
local clients_title_progress = {}
local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷", index = 1 }

local function update_progress_notif(win, buf)
  spinner_frames.index = spinner_frames.index % #spinner_frames + 1

  local lines = {}
  for client_id, title_prog_tbl in pairs(clients_title_progress) do
    local spinner = (next(clients_title_progress[client_id]) and spinner_frames[spinner_frames.index] or '󰄬') ..
        ' '
    local client_name = vim.tbl_get(vim.lsp.get_client_by_id(client_id) or {}, 'name')
    if not client_name then return vim.api.nvim_win_close(win, false) end
    table.insert(lines, spinner .. client_name)

    local t = vim.tbl_values(title_prog_tbl)
    table.sort(t, function(a, b) return a.order - b.order > 0 end)
    for _, prog_msg in ipairs(t) do vim.list_extend(lines, vim.split(' ' .. prog_msg.progress_info, '\n')) end
  end

  if not next(progress_token_to_title) and #lines == 0 then return vim.api.nvim_win_close(win, false) end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_height(win, #lines)

  vim.defer_fn(function() update_progress_notif(win, buf) end, 100)
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local token = result.token
  local val = result.value
  local title = val.title or vim.tbl_get(progress_token_to_title, client_id, token, 'title')
  local message_maybe_prev = val.message or vim.tbl_get(clients_title_progress, client_id, title, 'message') or ''
  local percentage = val.percentage and val.percentage .. '%' or ''

  if val.kind == "begin" then
    -- initialize
    progress_token_to_title[client_id] = vim.tbl_deep_extend('error',
      progress_token_to_title[client_id] or {},
      { [token] = { title = val.title } })

    progress_title_to_order[client_id] = vim.tbl_deep_extend('keep', progress_title_to_order[client_id] or {},
      { [val.title] = #vim.tbl_keys(progress_title_to_order[client_id] or {}) + 1 })

    if not next(clients_title_progress) then
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, false, {
        relative = 'win',
        anchor = 'NE',
        width = 45,
        height = 1,
        row = 0,
        col = vim.fn.winwidth(0),
        style = 'minimal'
      })
      update_progress_notif(win, buf)
    end

    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
      {
        [val.title] = {
          progress_info = ('%s %s %s'):format(val.title, message_maybe_prev, percentage), message =
            message_maybe_prev, completed = false, title =
            val.title, order = progress_title_to_order[client_id][val.title]
        }
      })
  elseif val.kind == "report" and vim.tbl_get(progress_token_to_title, client_id, token) then
    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
      {
        [title] = {
          progress_info = ('%s %s %s'):format(title, message_maybe_prev, percentage), message =
            message_maybe_prev, completed = false, title =
            title, order = progress_title_to_order[client_id][title]
        }
      })
  elseif val.kind == "end" and vim.tbl_get(progress_token_to_title, client_id, token) then
    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
      {
        [title] = {
          progress_info = ('%s %s %s'):format(title, message_maybe_prev, 'Complete'), message =
            message_maybe_prev, completed = true, title =
            title, order = progress_title_to_order[client_id][title]
        }
      })
    -- cleanup
    vim.defer_fn(function()
      if not vim.tbl_get(clients_title_progress, client_id, title, 'completed') then return end
      clients_title_progress[client_id][title] = nil
      vim.defer_fn(function()
        if next(vim.tbl_get(clients_title_progress, client_id) or {}) then return end
        clients_title_progress[client_id] = nil
      end, 500)
    end, 1000)

    progress_token_to_title[client_id][token] = nil
    if not next(progress_token_to_title[client_id]) then progress_token_to_title[client_id] = nil end
  end
end

---@ Session

for _, v in ipairs { 'curdir' } do vim.opt.sessionoptions:remove(v) end
local session_aug = AUG('UserSessionAUG', {})

local sessions_dir = vim.fn.stdpath 'data' .. '/sessions/'
local function normalize_session_path(dir) return sessions_dir .. vim.fn.fnamemodify(dir, ':p:h'):gsub('/', '%%') end

local function load_session_if_exists(dir)
  if vim.loop.fs_stat(normalize_session_path(dir)) then
    vim.cmd.source(vim.fn.fnameescape(normalize_session_path(dir)))
    vim.schedule(function() vim.cmd 'silent! tabdo windo edit' end)
    return true
  end
  return false
end

local function mksession(dir)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == 'gitcommit' then vim.cmd('bw!' .. buf) end
  end
  vim.cmd 'NvimTreeClose'
  vim.cmd.mksession { args = { vim.fn.fnameescape(normalize_session_path(dir)) }, bang = true }
end
AUC('VimEnter', {
  group = session_aug,
  callback = function()
    local vim_argv = vim.fn.argv()
    load_session_if_exists(vim.fn.getcwd())
    for _, path in ipairs(vim_argv) do vim.cmd.tabedit(path) end
  end
})

AUC('VimLeave', { group = session_aug, callback = function() mksession(vim.fn.getcwd()) end })
AUC('DirChangedPre', {
  group = session_aug,
  callback = function()
    mksession(vim.g.prev_cwd); vim.cmd '%bwipe! | clearjumps'
  end
})
AUC('DirChanged', { group = session_aug, callback = function(ev) load_session_if_exists(ev.file) end })

local function delete_selected(selected) os.remove(normalize_session_path(selected[1])) end
fzf_lua.config.set_action_helpstr(delete_selected, "delete-session")

local function session_files(file)
  local cwd_pat = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:~')
  local bufs, buf_pat = {}, "^badd%s*%+%d+%s*"
  for line in io.lines(file) do
    if line:find(buf_pat) then bufs[#bufs + 1] = line:gsub(buf_pat, ''):gsub(cwd_pat, ''):gsub('^%./', '') end
  end
  return bufs
end

local FzfLuaSessionPreviewer = fzf_lua_previewer_builtin.base:extend()
function FzfLuaSessionPreviewer:new(o, opts, fzf_win)
  FzfLuaSessionPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, FzfLuaSessionPreviewer)
  return self
end

function FzfLuaSessionPreviewer:gen_winopts()
  return vim.tbl_extend('force', self.winopts, { wrap = false, number = false })
end

function FzfLuaSessionPreviewer:populate_preview_buf(entry_str)
  local tmpbuf = self:get_tmp_buffer()
  vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, session_files(normalize_session_path(entry_str)))
  self:set_preview_buf(tmpbuf)
  self.win:update_scrollbar()
end

CMD('Sessions', function()
  fzf_lua.fzf_exec(
    function(fzf_cb)
      for _, s in ipairs(vim.fn.readdir(sessions_dir)) do
        fzf_cb(vim.fn.fnamemodify(s:gsub('%%', '/'),
          ':p:~:h'))
      end
      fzf_cb()
    end,
    {
      prompt = 'Session> ',
      actions = {
        ['default'] = function(selected) vim.cmd.cd(selected[1]) end,
        ['ctrl-x'] = { fn = delete_selected, reload = true }
      },
      previewer = FzfLuaSessionPreviewer
    })
end, {})

-- Inherit from the "buffer_or_file" previewer
local MyPreviewer = fzf_lua_previewer_builtin.buffer_or_file:extend()

function MyPreviewer:new(o, opts, fzf_win)
  MyPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, MyPreviewer)
  return self
end

function MyPreviewer:parse_entry(entry_str)
  -- Assume an arbitrary entry in the format of 'file:line'
  local path, line = entry_str:match("([^:]+):?(.*)")
  return { path = path, line = tonumber(line) or 1, col = 1 }
end

CMD('AA', function() fzf_lua.fzf_exec("rg --files", { previewer = MyPreviewer, prompt = "Select file> ", }) end, {})
CMD('AB', function() fzf_lua.fzf_live("rg --column --color=always", { previewer = "builtin" }) end, {})
CMD('AC', function() fzf_lua.fzf_exec("rg --files", { previewer = "builtin" }) end, {})
CMD('AD', function()
  fzf_lua.fzf_exec("rg --files", {
    fzf_opts = {
      ['--preview'] = vim.fn.shellescape("bat {}"), -- escape is necessary in fzf_opts not in (fzf_lua's) opts
      ['--preview-window'] = 'nohidden,down,50%',
    },
    -- preview = 'bat {}' -- instead of "['--preview']" opt in 'fzf_opts'
  })
end, {})
CMD('AF', function()
  fzf_lua.fzf_exec("rg --files", {
    fzf_opts = {
      ['--preview-window'] = 'nohidden,down,50%',
      ['--preview'] = require 'fzf-lua'.shell.preview_action_cmd(function(items)
        local ext = vim.fn.fnamemodify(items[1], ':e')
        if vim.tbl_contains({ "png", "jpg", "jpeg" }, ext) then
          return "viu -b " .. items[1]
        end
        return string.format("bat --style=default --color=always %s", items[1])
      end)
    },
  })
end, {})
CMD('AG', function()
  fzf_lua.fzf_exec("rg --files", {
    fzf_opts = {
      ['--preview-window'] = 'nohidden,down,50%',
      ['--preview'] = require 'fzf-lua'.shell.action(function(items)
        return vim.tbl_map(function(x) return "selected item: " .. x end, items)
      end)
    },
  })
end, {})
CMD('AH', function()
  fzf_lua.fzf_live("git rev-list --all | xargs git grep --line-number --column --color=always <query>",
    {
      fzf_opts = {
        ['--delimiter'] = ':',
        ['--preview-window'] = 'nohidden,down,60%,border-top,+{3}+3/3,~3',
      },
      preview =
      "git show {1}:{2} | bat --style=default --color=always --file-name={2} --highlight-line={3}",
    })
end, {})
CMD('AI', function()
  local opts = {}
  opts.prompt = "rg> "
  opts.git_icons = true
  opts.file_icons = true
  opts.color_icons = true
  -- setup default actions for edit, quickfix, etc
  opts.actions = fzf_lua.defaults.actions.files
  -- see preview overview for more info on previewers
  opts.previewer = "builtin"
  opts.fn_transform = function(x) return fzf_lua.make_entry.file(x, opts) end
  -- we only need 'fn_preprocess' in order to display 'git_icons'
  -- it runs once before the actual command to get modified files
  -- 'make_entry.file' uses 'opts.diff_files' to detect modified files
  -- will probaly make this more straight forward in the future
  opts.fn_preprocess = function(o)
    opts.diff_files = fzf_lua.make_entry.preprocess(o).diff_files
    return opts
  end
  -- opts.cwd = ' <specify directory>'
  fzf_lua.fzf_live(function(q) return "rg --column --color=always -- " .. vim.fn.shellescape(q or '') end, opts)
end, {})
CMD('AE', function()
  fzf_lua.fzf_live(
    function(q) return "rg --column --color=always -- " .. vim.fn.shellescape(q or '') end,
    { fn_transform = function(x) return fzf_lua.make_entry.file(x, { file_icons = true, color_icons = true }) end }
  )
end, {})

require 'nvim-web-devicons'.setup {}
