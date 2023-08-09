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

---@ CONFIG INIT START

---@ Misc Options, Keymaps

for k, v in pairs {
  autowriteall = true, undofile = true,
  shell = os.getenv 'SHELL' .. ' -l',
  virtualedit = 'block',
  ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true,
  pumblend = 30, winblend = 30,
  laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number',
  foldmethod = 'expr', foldexpr = vim.treesitter.foldexpr(), foldenable = false, }
do vim.opt[k] = v end

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
  --├────────┼────────┼────────┼────────┼────────┼────────┼────────┤                          ├────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │ 🚧  👷 │ 🔧  🔨 │ ➕  ➖ │  ⬆  ⬇  │ 🚀  🔖 │        │                          │        │ 💄  💫 │ 🚸  ♿ │ 📱  🔍 │ 📈  🌐 │ 💬  🍱 │        │
  --├────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┐        ┌────────┼────────┼────────┼────────┼────────┼────────┼────────┼────────┤
  --│        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │        │
  --└────────┴────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┘        └────────┴────────┴────────┴────────┘
  { 'eq', '✨' }, { 'eQ', '💥' }, { 'ew', '🚨' }, { 'eW', '🎨' }, { 'ee', '💡' }, { 'eE', '🔊' }, { 'er', '📝' },
  { 'ea', '🐛' }, { 'eA', '🚑' }, { 'es', '🩹' }, { 'eS', '♻' }, { 'ed', '🔥' }, { 'eD', '🚚' }, { 'ef', '🗑' }, {
  'eF', '👽' },
  { 'ez', '🚧' }, { 'eZ', '👷' }, { 'ex', '🔧' }, { 'eX', '🔨' }, { 'ec', '➕' }, { 'eC', '➖' }, { 'ev', '⬆' }, {
  'eV', '⬇' }, { 'eb', '🚀' }, { 'eB', '🔖' },

  { 'ey', '✅' }, { 'eY', '🧪' }, { 'eu', '🤡' }, { 'eU', '⚗' }, { 'ei', '🏷' }, { 'eI', '🦺' }, { 'eo', '💬' }, {
  'eO', '🍱' },
  { 'eh', '👔' }, { 'eH', '💸' }, { 'ek', '🧱' }, { 'eK', '🗃' }, { 'el', '⚡' }, { 'eL', '🧵' }, { 'e;', '🔒' }, {
  'e:', '🛂' },
  { 'en', '💄' }, { 'eN', '💫' }, { 'em', '🚸' }, { 'eM', '♿' }, { 'e,', '📱' }, { 'e<', '🔍' }, { 'e.', '📈' }, {
  'e>', '🌐' }, { 'e/', '🔀' }, --{ 'e?', '⏪️' },
}
K('<C-k>e?', '⏪️', { mode = { 'i' } })
K('fj', 'f<C-k>j')
K('Fj', 'F<C-k>j')
K('tj', 't<C-k>j')
K('Tj', 'T<C-k>j')

local keymaps_opts = { noremap = true, } -- silent = true }
vim.g.mapleader = " "
-- Move between windows
K("n", "<C-h>", "<C-w>h", keymaps_opts)
K("n", "<C-j>", "<C-w>j", keymaps_opts)
K("n", "<C-k>", "<C-w>k", keymaps_opts)
K("n", "<C-l>", "<C-w>l", keymaps_opts)
-- Move between tabs
K("n", "<C-Left>", ":tabprevious<CR>", keymaps_opts)
K("n", "<C-Right>", ":tabnext<CR>", keymaps_opts)
-- Move between buffers
K("n", "<C-Down>", ":bprevious<CR>", keymaps_opts)
K("n", "<C-Up>", ":bnext<CR>", keymaps_opts)
-- Move between splits
K("n", "<C-S-Left>", ":vertical resize -5<CR>", keymaps_opts)
K("n", "<C-S-Right>", ":vertical resize +5<CR>", keymaps_opts)
K("n", "<C-S-Up>", ":resize -5<CR>", keymaps_opts)
K("n", "<C-S-Down>", ":resize +5<CR>", keymaps_opts)
-- Move between splits
K("n", "<Leader>h", ":<C-u>help<Space>", keymaps_opts)
K("n", "<Leader>,", ":<C-u>tabnew $MYVIMRC<CR>", keymaps_opts)
K("n", "<Leader>.,", ":<C-u>luafile $MYVIMRC<CR>", keymaps_opts) -- ':helptags ALL'
K("n", "<Leader>m", ":<C-u>marks<CR>", keymaps_opts)
K("n", "<Leader>r", ":<C-u>registers<CR>", keymaps_opts)
K("n", "<Leader>l", ":<C-u>ls<CR>:b", keymaps_opts)
K("n", "<Leader>b", ":<C-u>buffers<CR>", keymaps_opts)
--
K("n", "Y", "y$", keymaps_opts)
K({'n','v'}, ';',':' , keymaps_opts)
K({'n','v'}, ':',';' , keymaps_opts)
-- nnoremap +  <C-a>
-- nnoremap -  <C-x>

K("n", "<Leader>s", ":<C-u>%s///g<Left><Left><Left>", keymaps_opts)
K("n", "<Leader>tt", ':<C-u>bo sp | term  && sleep 3 && exit' .. string.rep('<left>', 19), keymaps_opts)
K('n', '<Leader>t', function()
  local cmd = vim.fn.input { prompt = 'Command: ', default = vim.fn.expand('<cword>'), completion = 'shellcmd', cancelreturn = '' }
  if cmd == '' then return end
  vim.cmd 'botright sp +enew'
  vim.fn.termopen(cmd , { on_exit = function() vim.api.nvim_buf_delete(0, { force = true } ) end })
end)
K('t', '<C-o>', '<C-\\><C-n><C-o>', keymaps_opts)
AU('TermOpen', { pattern = '*', callback = function() vim.cmd('setlocal nonumber norelativenumber signcolumn=no showtabline=1 | startinsert') end })
--AU('TermClose', { pattern = '*', callback = function() vim.cmd('bw!') end })

local function startInteractiveShellJobs(cmds_params)
  for i, params in pairs(cmds_params) do
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_call(buf, function() vim.fn.termopen(params.cmd) end)
    local win = vim.api.nvim_open_win(buf, true, { relative = 'editor', width = 80, height = 20, row = (i-1) * 20, col = 0, border = 'single' } )
    vim.defer_fn(function() vim.api.nvim_win_close(win, false) end, 5000)
  end
end

CMD('RNExpo', function() startInteractiveShellJobs{ { cmd = 'emu' }, { cmd = 'rn-expo --android' } } end, {})

-- yy:@"
K("v", "<Leader>s", ":s///g<Left><Left><Left>", keymaps_opts)
K("v", "z/", "<ESC>/\\%V", keymaps_opts)
K("v", "z?", "<ESC>?\\%V", keymaps_opts)
K("n", "<CR>", ":call append(expand('.'), '')<CR>j", keymaps_opts)
K("n", "<S-CR>", ":call append(line('.')-1, '')<Cr>k", keymaps_opts)
K("n", "<BS>", ":call append(line('.')-1, '')<Cr>k", keymaps_opts)
K("n", "<Leader>q", ":<C-u>q<CR>", keymaps_opts)
K("n", "<Leader>Q", ":<C-u>qa!<CR>", keymaps_opts)
K("n", "<Leader>z", ":<C-u>wa<CR>", keymaps_opts)
K("n", "<Leader>ZZ", ":<C-u>wqa<CR>", keymaps_opts)
K("c", "<expr>/", "getcmdtype() == '/' ? '\\/' : '/'", {})
K("i", "jk", function() vim.cmd'stopinsert'; if vim.bo.modifiable and vim.fn.bufname() ~= '' then vim.cmd'w' end end , keymaps_opts)
K("n", "<leader>w", "<cmd>w<CR>", keymaps_opts)
K("n", "L", "J", keymaps_opts)
K("n", "J", "gt", keymaps_opts)
K("n", "K", "gT", keymaps_opts)
K("n", "(", ":bn<CR>", keymaps_opts)
K("n", ")", ":bN<CR>", keymaps_opts)
K("n", "0", "^", keymaps_opts)
K("n", "^", "0", keymaps_opts)
K( 'n', 'vp', '`[v`]', keymaps_opts )

-- nnoremap <C-t>  <Nop>
-- nnoremap <c-t>  <nop>
-- nnoremap <c-t>n  :<c-u>tabnew<cr>
-- nnoremap <c-t>c  :<c-u>tabclose<cr>
-- nnoremap <c-t>o  :<c-u>tabonly<cr>
-- nnoremap <c-t>j  :<c-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<cr>
-- nnoremap <c-t>k  gt'')))''
-- nnoremap <C-t>n  :<C-u>tabnew<CR>
-- nnoremap <C-t>c  :<C-u>tabclose<CR>
-- nnoremap <C-t>o  :<C-u>tabonly<CR>
-- nnoremap <C-t>j  :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
-- nnoremap <C-t>k  gT'')))''
--
-- nnoremap t  <Nop>
-- nnoremap tt  <C-]>           "jump
-- nnoremap tj  :<C-u>tag<CR>   "go forward
-- nnoremap tk  :<C-u>pop<CR>   "go backward
-- nnoremap tl  :<C-u>tags<CR>  "history list
-- :-tabmove       " タブページを左に移動
-- :+tabmove       " タブページを右に移動
-- :0tabmove       " タブページを左端に移動
-- :tabmove 0      " 同上
-- :tabmove        " タブページを右端に移動
-- :$tabmove       " 同上
-- :tabmove $      " 同上
-- ( 'n', '<Leader>e', vim.diagnostic.open_float, keymaps_opts ),
-- { 'n', '[d', vim.diagnostic.goto_prev, keymaps_opts },
-- { 'n', ']d', vim.diagnostic.goto_next, keymaps_opts },
-- { 'n', '<space>q', vim.diagnostic.setloclist, keymaps_opts },
--["<A-t>"] = {
--    function() require("bufferline").go_to_buffer(vim.fn.input "Buf number: ", true) end,
--    desc = "Go to buffer by absolute number",
--    noremap = true,
--    silent = true,
--  },
-- mapping idea
--  <C-n> + t tabnext , b bufnext, q quick-fix next
--  <C-p> + t tabprev , b bufprev, q quick-fix prev
--CTRL-W w	次のウィンドウにフォーカスを当てる
--CTRL-W N	ターミナルノーマルモードに移行
--CTRL-W .	端末にCTRL-Wを送る
--CTRL-W :	コマンドラインモードに移行
--CTRL-W " {reg}	レジスタの中身を貼り付ける
--:vert term git log && exit
--:term git blame %  -- lazygit, REPL etx... && exit

-- :vim {pattern} % (:h wildcards path...relative :pwd)
-- nnoremap [q :cprevious<CR>
--nnoremap ]q :cnext<CR>
--nnoremap [Q :<C-u>cfirst<CR>
--nnoremap ]Q :<C-u>clast<CR>
--:ar path/to/search/dir/**
--:vim foo ##
--:vim bar ##
--:cn :cN
--" インデックスされている全てのファイルを対象にする :vim {pattern} `git ls-files`
--" appディレクトリ内でインデックスされているファイルを対象にする :vim {pattern} `git ls-files app`
--" appディレクトリ内でインデックスされている.htmlファイルを対象にする :vim {pattern} `git ls-files app/**/*.html`
-- :bufdo vimgrepa {pattern} % -- (reset) :cex ""
-- :vim {pattern} {file} | cw -- autocmd QuickFixCmdPost *grep* cwindow
-- helps: quickfix.txt :vimgrep :cwindow :args cmdline-special pattern-overview wildcards

}

require 'telescope'.setup()
require 'telescope'.load_extension("undo")
require 'fzf-lua'

function will_rename_callback(data)

  local Path = require('plenary.path')

  local function validatePath(_path)
    local path = Path:new(_path)
    local absolute_path = path:absolute()
    if (path:is_dir() and absolute_path:match("/$")) then absolute_path = path .. '/' end
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
        (match_type == "folder" and is_dir) or
        (match_type == "file" and not is_dir)
      then
        local regex = vim.fn.glob2regpat(pattern.glob)
        if pattern.options and pattern.options.ignorecase then regex = "\\c" .. regex end
        local previous_ignorecase = vim.o.ignorecase
        vim.o.ignorecase = false
        matched = vim.fn.match(path, regex) ~= -1
        vim.o.ignorecase = previous_ignorecase
      end
      if (matched) then return end
    end
  end

  for _, client in pairs(vim.lsp.get_active_clients()) do
    local success, will_rename = pcall(function() return client.server_capabilities.workspace.fileOperations.willRename end)
    if (success and will_rename ~= nil) then
      local will_rename_params = {
        files = {
          {
            oldUri = validatePathWithFilter(data and data.old_name or vim.fn.expand('%'), will_rename.filters),
            newUri = validatePath(data and data.new_name or
              vim.uri_from_fname(vim.fn.expand('%:p:h') .. '/' .. vim.fn.input('New name: ')))
          }
        }
      }
      local resp = client.request_sync("workspace/willRenameFiles", will_rename_params, 1000)
      print(vim.inspect(resp))
      local edit = resp.result
      if (edit ~= nil) then vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding) end
    end
  end

end

vim.cmd('command! Rename lua will_rename_callback()')

local tree_api = require 'nvim-tree.api'
require 'nvim-tree'.setup({ diagnostics = { enable = true }, on_attach = function(bufnr)
  tree_api.events.subscribe(tree_api.events.Event.WillRenameNode, will_rename_callback)
  tree_api.config.mappings.default_on_attach(bufnr)
end })
K('n', '<C-y>',  tree_api.tree.toggle )
AU({ "VimEnter" }, { callback = function(data) if (vim.fn.isdirectory(data.file) == 1 or data.file == '') then tree_api.tree.open() end end })

require 'leap'.add_default_mappings()

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "lua", "python", "javascript", "typescript", "html", "css", "json", "yaml", "toml", "go",
    "rust", "jsonc", "graphql", "dockerfile", "vim", "tsx", "markdown", "markdown_inline" },
  highlight = { enable = true },
  indent = { enable = true }, -- type '=' operator to fix indentation
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  },
  autotag = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grs",
      node_decremental = "grm",
    }
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },
  },
}

require 'indent_blankline'.setup { show_current_context = true, show_current_context_start = true, use_treesitter = true }
require 'Comment'.setup {
  pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
  toggler = { line = 'gcc', block = 'gbc' }, --LHS of toggle mappings in NORMAL mode
  opleader = { line = 'gc', block = 'gb' }, --LHS of operator-pending mappings in NORMAL and VISUAL mode
  extra = { above = 'gc0', below = 'gco', eol = 'gcA' },
}
require 'nvim-surround'.setup()
require 'nvim-autopairs'.setup()

--K('n', '[[', '<cmd>AerialPrev<CR>', { buffer = bufnr })
--K('n', ']]', '<cmd>AerialNext<CR>', { buffer = bufnr })
--K('n', '<leader>a', '<cmd>AerialToggle<CR>')

vim.cmd("sign define LspDiagnosticsSignWarning texthl=LspDiagnosticsSignWarning numhl=LspDiagnosticsLineNrWarning")
local luasnip = require 'luasnip'
require 'luasnip.loaders.from_vscode'.lazy_load()
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require 'cmp'
cmp.setup({
  snippet = { -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    --['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehaviour.Replace }), -- Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- :LspInfo TODO: nvim-lspconfig source code
--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--  update_in_insert = false,
--virtual_text = {
--	format = function(diagnostic)
--		return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
--	end,
--},
--})

Hl(0, 'LspDiagnosticsLineNrWarning', { fg = '#E5C07B', bg = '#4E4942', --[[gui = 'bold']] })
-- vim.lsp.set_log_level("debug") --:LspLog
CMD('LspRestart2', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()) | edit', { bar = true })
CMD('LspCapa', 'lua =vim.lsp.get_active_clients()[1].server_capabilities', {})

K('n', '<space>e', vim.diagnostic.open_float)
K('n', '<leader>D', vim.diagnostic.goto_prev)
K('n', '<leader>d', vim.diagnostic.goto_next)
K('n', '<space>q', vim.diagnostic.setloclist)

local augroup_fmt = AUG('LspFormatting', {})

AUC('LspAttach', {
  group = AUG('UserLspConfig', {}),
  callback = function(ev)
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc' --<c-x><c-o> --'nvim-cmp' is used instead.

    local opts = { buffer = ev.buf } --:help vim.lsp.*
    K('n', 'gD', vim.lsp.buf.declaration, opts)
    K('n', 'gd', vim.lsp.buf.definition, opts)
    K('n', '<leader>k', vim.lsp.buf.hover, opts)
    K('n', 'gi', vim.lsp.buf.implementation, opts)
    K('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    K('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    K('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    K('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    K('n', '<space>D', vim.lsp.buf.type_definition, opts)
    K('n', '<space>rn', vim.lsp.buf.rename, opts)
    K('n', '<space>ca', vim.lsp.buf.code_action, opts)
    K('n', 'gr', vim.lsp.buf.references, opts)

    --AUC({'CursorHold', 'CursorHoldI'}, { callback = vim.diagnostic.open_float})
    --vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup_fmt, buffer = ev.buf }
      AUC('BufWritePre', { group = augroup_fmt, buffer = ev.buf, callback = function()
        vim.lsp.buf.format { filter = function(c) return c.name ~= 'tsserver' end, bufnr = ev.buf }
      end })
    end

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

    require 'lspsaga'.setup {}
    K("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
    K({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
    K("n", "gr", "<cmd>Lspsaga rename<CR>")
    K("n", "gR", "<cmd>Lspsaga rename ++project<CR>")
    K("n", "gp", "<cmd>Lspsaga peek_definition<CR>") -- supports definition_action_keys tagstack. Use <C-t> to jump back
    K("n", "gd", "<cmd>Lspsaga goto_definition<CR>")
    K("n", "gtp", "<cmd>Lspsaga peek_type_definition<CR>") -- supports definition_action_keys tagstack. Use <C-t> to jump back
    K("n", "gtg", "<cmd>Lspsaga goto_type_definition<CR>")
    K("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>") -- supports ++unfocus
    K("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
    K("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
    K("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
    K("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    K("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    K("n", "[E", function() require "lspsaga.diagnostic":goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
    K("n", "]E", function() require "lspsaga.diagnostic":goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
    K("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
    K("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    K("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")
    -- ++quiet hides 'no hover doc' notification. Pressing the key twice will enter the hover window
    -- ++keep if you want to keep the hover window in the top right hand corner
    -- Note that if you use hover with ++keep, pressing this key again will
    -- close the hover window. If you want to jump to the hover window
    -- you should use the wincmd command "<C-w>w"
    K("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    K("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
    K({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
  end
})

require 'trouble'.setup {}
require 'lsp_signature'.setup {}
require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', }, --> in Neovim
      diagnostics = {
        globals = { 'vim', 'require', 'print' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
      },
      telemetry = { enable = false }, -- Do not send telemetry data containing a randomized but unique identifier
    },
  },
  capabilities
}

require 'lspconfig'.bashls.setup { capabilities }
local jsonls_capabilities = vim.lsp.protocol.make_client_capabilities()
jsonls_capabilities.textDocument.completion.completionItem.snippetSupport = true
-- print(vim.inspect(jsonls_capabilities.textDocument.completion))
-- print(vim.inspect(capabilities))
-- print(vim.tbl_deep_extend('error',jsonls_capabilities, capabilities))
require 'lspconfig'.jsonls.setup {
  capabilities = jsonls_capabilities, --vim.tbl_deep_extend('error',jsonls_capabilities, capabilities),
  settings = {
    json = {
      schemas = require 'schemastore'.json.schemas(),
      validate = { enable = true }
    }
  }
}

require 'lspconfig'.yamlls.setup {
  settings = {
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
    },
  },
  capabilities
}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.tailwindcss.setup {
  on_attach = function(_, bufnr) require("tailwindcss-colors").buf_attach(bufnr) end,
  --:TailwindColorsAttach
  --:TailwindColorsDetach
  --:TailwindColorsRefresh
  --:TailwindColorsToggle
  handlers = {
    ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
      -- tailwindcss lang server wai swap = {
      vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
    end
  },
  capabilities

}

local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  capabilities
})

require 'lspconfig'.gopls.setup { capabilities }

--require'lspconfig'.textlsp.setup {}

--vim.cmd( [[nnoremap <silent> gp :let save_cursor_pos = getpos(".")<CR>:if executable('npx')<Bar>silent %!npx prettier --stdin-filepath % --loglevel silent<Bar>endif<CR>:call setpos('.', save_cursor_pos)<CR>]])
--vim.cmd([[
--  nnoremap <silent> gp :let save_cursor_pos = getpos(".")<CR>
--  :let cmd_exists = system('npx prettier -v >/dev/null 2>&1 && echo 1 || echo 0')
--  \| if cmd_exists == 1<Bar>silent %!npx prettier --stdin-filepath % --loglevel silent<Bar>endif<CR>
--  :call setpos('.', save_cursor_pos)<CR>
--]])
-- Define the command to run Prettier
local prettier_command = { 'npx', 'prettier', '--stdin-filepath', vim.fn.expand('%') }

-- Define a function to run Prettier synchronously
local function run_prettier_sync()
  local output = vim.fn.systemlist(prettier_command)
  if vim.v.shell_error ~= 0 then
    -- Handle error
    print('Prettier encountered an error:')
    print(table.concat(output, '\n'))
  else
    -- Handle success
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  end
end

-- Define a function to run Prettier asynchronously
local function run_prettier_async()
  local job_id = vim.fn.jobstart(prettier_command, {
    on_stdout = function(_, data)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(data, '\n'))
    end,
    on_stderr = function(_, data)
      print('Prettier encountered an error:')
      print(vim.inspect(data))
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  vim.fn.chansend(job_id, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  vim.fn.chanclose(job_id, 'stdin')
end

-- Set up a mapping to run Prettier synchronously
K('n', '<leader>p', run_prettier_sync) --, { silent = true })

-- Set up a mapping to run Prettier asynchronously
K('n', '<leader>P', run_prettier_async)
--npx onchange "**/*" -- npx prettier --write --ignore-unknown {{changed}}

local null_ls = require 'null-ls'
null_ls.setup {
  -- diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier.with { prefer_local = 'node_modules/.bin' },
    null_ls.builtins.diagnostics.stylelint.with { prefer_local = 'node_modules/.bin' },
    null_ls.builtins.diagnostics.actionlint,
    --null_ls.builtins.formatting.prismaFmt,
    --null_ls.builtins.formatting.deno_fmt,
    --null_ls.builtins.formatting.deno_lint,

    --null_ls.builtins.formatting.stylua,
    --null_ls.builtins.code_actions.gomodifytags -- requires Go tree-sitter parser
    --null_ls.builtins.formatting.golines,
    --null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.rustfmt,
    --null_ls.builtins.code_actions.ltrs
    --null_ls.builtins.diagnostics.cfn_lint

    --null_ls.builtins.completion.luasnip, -- If use instead of nvim-cmp, uncomment this, and set up keymap in luasnip config.
    --null_ls.builtins.diagnostics.protolint
    --null_ls.builtins.formatting.protolint
    --null_ls.builtins.diagnostics.buf
    --null_ls.builtins.formatting.buf
    --null_ls.builtins.completion.buf

    null_ls.builtins.code_actions.gitrebase, -- builtin. filetype 'gitrebase'
    null_ls.builtins.diagnostics.commitlint.with { extra_args = { '--extends', '@commitlint/config-conventional' } },
    null_ls.builtins.code_actions.gitsigns, --.with({
    --   config = {
    --     filter_actions = function(title)
    --       return title:lower():match("blame") == nil -- filter out blame actions
    --     end,
    --   },
    -- })
  },
}

require 'octo'.setup {}
--local prettier_command = {'node', './format.js'}
--
---- Define a function to start the Prettier job
--local start_prettier_job = function ()
--  -- Start the job
--  local job_id = vim.fn.jobstart(prettier_command, {
--    on_stdout = function(job_id, data)
--      print('out' .. vim.inspect(data))
--    end,
--    on_stderr = function(job_id, data)
--      print('err:' .. vim.inspect(data))
--    end,
--    on_exit = function(job_id, exit_code)
--   if exit_code ~= 0 then
--      print(string.format('Prettier job exited with code %d and event type %s', exit_code, event_type))
--    end
--    end,
--    stdout_buffered = true,
--    stderr_buffered = true,
--    detach = true,
--  })
--  -- Print the job ID for debugging purposes
--  print('Prettier job started with ID ' .. job_id)
--end
--
---- Define a function to debounce the Prettier job
----local debounce_prettier = vim.fn.timer_start(250, 0, function()
----  start_prettier_job()
----end)
--
---- Set up an autocommand to run Prettier when a file is saved
--vim.api.nvim_create_autocmd("FileType", {
--  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
--  callback = function() print('hi');start_prettier_job() end
--})

vim.diagnostic.setqflist({ open = false })

require 'symbols-outline'.setup()
require 'gitsigns'.setup {
  signcolumn = false,
  numhl = true,
  word_diff = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(gs.next_hunk)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(gs.prev_hunk)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line { full = true } end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

  end
}
vim.cmd "set statusline=%{get(b:,'gitsigns_status','')}"

-- " Status Line
-- set statusline=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}
-- set rulerformat=%15(%c%V\ %p%%%)
-- "set rulerformat=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}
--
-- function! FileTime()
--   let ext=tolower(expand("%:e"))
--   let fname=tolower(expand('%<'))
--   let filename=fname . '.' . ext
--   let msg=""
--   let msg=msg." ".strftime("(Modified %b,%d %y %H:%M:%S)",getftime(filename))
--   return msg
-- endfunction
--
-- function! CurTime()
--   let ftime=""
--   let ftime=ftime." ".strftime("%x %b,%d %y %H:%M:%S")
--   return ftime
-- endfunction

-- into vanilla statusbar
--local current_treesitter_context = function()
--  local f = require'nvim-treesitter'.statusline({
--    indicator_size = 300,
--    type_patterns = {"class", "function", "method", "interface", "type_spec", "table", "if_statement", "for_statement", "for_in_statement"}
--  })
--  if f == nil then f = "*" end
--  return string.format("%s", f) -- convert to string, it may be a empty ts node
--end
--function status_line()
--    return table.concat {
--        "%#StatusLeft#",
--        "%f",
--        " %h%w%m%r",
--  current_treesitter_context(),
--        "%=%-14.",
--  "(%l,%c%V%)",
--        "%P"
--    }
--end
--vim.o.statusline = "%!luaeval('status_line()')"


require 'nightfox'.setup { options = { transparent = true, inverse = { search = true } } }
vim.cmd 'colorscheme nordfox'
Hl(0, '@variable', { fg = 'NONE' })
Hl(0, 'WinSeparator', { bg = 'None' })

--Hl( 0, 'Normal', { bg = 'NONE' } )
--Hl( 0, 'NonText', { bg = 'NONE' } )
--Hl( 0, 'LineNr', { fg = '#767676', bg = 'NONE' } )
--Hl( 0, 'Folded', { bg = 'NONE' } )
--Hl( 0, 'EndOfBuffer', { bg = 'NONE' } )
--Hl( 0, 'TabLineFill', { bg = 'NONE' } )
--Hl( 0, 'TabLine', { bg = 'NONE' } )
--Hl( 0, 'TabLineSel', { bg = '#545454' } )

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

require 'nvim-web-devicons'.setup { {color_icons = true }}

local progress_token_to_title = {}
local progress_title_to_order = {}
local clients_title_progress = {}
local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷", index = 1 }

local function update_token_progress_notif(win, buf)
  spinner_frames.index = (spinner_frames.index) % #spinner_frames + 1
  local lines = {}
  for client_id, title_tbl in pairs(clients_title_progress) do
    local t = vim.tbl_values(title_tbl)
    table.sort(t, function(a, b) return a.order - b.order > 0 end)
    local spinner = (next(clients_title_progress[client_id]) and spinner_frames[spinner_frames.index] or '󰄬') .. ' '
    table.insert(lines, spinner .. vim.lsp.get_client_by_id(client_id).name)
    for _, prog_msg in ipairs(t) do table.insert(lines, ' ' .. prog_msg.progress_info) end
  end
  if not next(progress_token_to_title) and #lines == 0 then return vim.api.nvim_win_close(win, false) end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_win_set_height(win, #lines)

  vim.defer_fn(function() update_token_progress_notif(win, buf) end, 100)
end

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local token = result.token
  local val = result.value
  local title = vim.tbl_get(progress_token_to_title, client_id, token, 'title')
  local message_maybe_prev = val.message or
      vim.tbl_get(table.pack(table.unpack(clients_title_progress)), client_id, title, 'message') or ''
  local percentage = val.percentage and val.percentage .. '%' or ''

  if result.value.kind == "begin" then
    -- initialize
    progress_token_to_title[client_id] = vim.tbl_deep_extend('error', progress_token_to_title[client_id] or {},
      { [token] = { title = val.title } })

    progress_title_to_order[client_id] = vim.tbl_deep_extend('keep', progress_title_to_order[client_id] or {},
      { [val.title] = #vim.tbl_keys(progress_title_to_order[client_id] or {}) + 1 })

    if not next(clients_title_progress) then
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, false, {
        relative = 'win', anchor = 'NE', width = 45, height = 1, row = 0, col = vim.fn.winwidth(0), style = 'minimal'
      })
      update_token_progress_notif(win, buf)
    end

    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {}, {
      [val.title] = {
        progress_info = ('%s %s %s'):format(val.title, message_maybe_prev, percentage), message = message_maybe_prev, completed = false, title =
          val.title, order = progress_title_to_order[client_id][val.title]
      }
    })
  elseif result.value.kind == "report" and vim.tbl_get(progress_token_to_title, client_id, token) then
    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id], {
      [title] = {
        progress_info = ('%s %s %s'):format(title, message_maybe_prev, percentage), message = message_maybe_prev, completed = false, title =
          title, order = progress_title_to_order[client_id][title]
      }
    })
  elseif result.value.kind == "end" and vim.tbl_get(progress_token_to_title, client_id, token) then
    clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id], {
      [title] = {
        progress_info = ('%s %s %s'):format(title, message_maybe_prev, 'Complete'), message = message_maybe_prev, completed = true, title =
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

for _, v in ipairs { 'curdir', 'blank' } do vim.opt.sessionoptions:remove(v) end
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
    -- if vim.bo[buf].filetype == 'gitcommit' then vim.cmd.bd(buf) end
  end
  vim.cmd 'Neotree close'
  vim.cmd.mksession { args = { vim.fn.fnameescape(normalize_session_path(dir)) }, bang = true }
end

AUC('VimEnter', {
  group = session_aug,
  callback = function()
    -- Prevent restoring session in nested nvim instance (in ':term lazygit' for example)
    if vim.bo.filetype == 'gitcommit' then return vim.api.nvim_clear_autocmds({ group = session_aug }) end

-- local luasnip = require 'luasnip' --?
--
--  cmp.setup({
--    snippet = {
--      -- REQUIRED - you must specify a snippet engine
--      expand = function(args)
--        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--      end,
--    },
--    window = {
--      -- completion = cmp.config.window.bordered(),
--      -- documentation = cmp.config.window.bordered(),
--    },
--    mapping = cmp.mapping.preset.insert({
--      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--      ['<C-d>'] = cmp.mapping.scroll_docs(4),
--      -- C-b (back) C-f (forward) for snippet placeholder navigation.
--      --['<C-b>'] = cmp.mapping.scroll_docs(-4),
--      --['<C-f>'] = cmp.mapping.scroll_docs(4),
--      ['<C-Space>'] = cmp.mapping.complete(),
--      ['<C-e>'] = cmp.mapping.abort(),
--      ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehaviour.Replace }), -- Set `select` to `false` to only confirm explicitly selected items.
--       ['<Tab>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_next_item()
--      elseif luasnip.expand_or_jumpable() then
--        luasnip.expand_or_jump()
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--    ['<S-Tab>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_prev_item()
--      elseif luasnip.jumpable(-1) then
--        luasnip.jump(-1)
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--    }),
--    sources = cmp.config.sources({
--      { name = 'nvim_lsp' },
--      { name = 'vsnip' }, -- For vsnip users.
--      -- { name = 'luasnip' }, -- For luasnip users.
--      -- { name = 'ultisnips' }, -- For ultisnips users.
--      -- { name = 'snippy' }, -- For snippy users.
--    }, {
--      { name = 'buffer' },
--    })
--  })
--
--  -- Set configuration for specific filetype.
--  cmp.setup.filetype('gitcommit', {
--    sources = cmp.config.sources({
--      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--    }, {
--      { name = 'buffer' },
--    })
--  })
--
--  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
--  cmp.setup.cmdline({ '/', '?' }, {
--    mapping = cmp.mapping.preset.cmdline(),
--    sources = {
--      { name = 'buffer' }
--    }
--  })
--
--  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--  cmp.setup.cmdline(':', {
--    mapping = cmp.mapping.preset.cmdline(),
--    sources = cmp.config.sources({
--      { name = 'path' }
--    }, {
--      { name = 'cmdline' }
--    })
--  })
    local vim_argv = vim.fn.argv()
    local edit_fn = load_session_if_exists(vim.fn.getcwd()) and vim.api.nvim_buf_get_name(0) ~= ''
        and vim.cmd.tabedit or vim.cmd.edit
    for _, path in ipairs(vim_argv) do edit_fn(path) end
  end
})
AUC('VimLeave', { group = session_aug, callback = function() mksession(vim.fn.getcwd()) end })
AUC('DirChangedPre', {
  group = session_aug,
  callback = function()
    mksession(vim.g.prev_cwd)
    vim.cmd '%bwipe! | clearjumps'
  end
})
AUC('DirChanged', { group = session_aug, callback = function(ev) load_session_if_exists(ev.file) end })

-- Set up lspconfig.
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--  capabilities = capabilities
--}

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
CMD('SessionClearAUC', function() vim.api.nvim_clear_autocmds({ group = session_aug }) end, {})

