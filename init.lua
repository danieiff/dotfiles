local K, Hl, AU, CMD = vim.keymap.set, vim.api.nvim_set_hl, vim.api.nvim_create_autocmd, vim.api.nvim_create_user_command

local options = {
  updatetime = 3000, timeoutlen = 1000,
  virtualedit = 'block',
  autowriteall = true, undofile = true, -- persistent undo history saved in {undodir}
  shell = os.getenv'SHELL'..' -l',
  showmatch = true, matchtime = 1, ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 2, expandtab = true, smartindent = true, list = true, listchars = { tab = '__', trail = '_' },
  pumheight = 10, pumblend = 10, winblend = 10, showtabline = 2, number = true, relativenumber = true, signcolumn = "yes",
  termguicolors = true, laststatus = 3 , cmdheight = 0, --statuscolumn = '%#NonText#%{&nu?v:lnum:""}%=%{&rnu&&(v:lnum%2)?" ".v:relnum:""}%#LineNr#%{&rnu&&!(v:lnum%2)?" ".v:relnum:""}',
  foldmethod = 'expr', foldexpr = "nvim_treesitter#foldexpr()", foldenable = false,
}
for k, v in pairs(options) do vim.opt[k] = v end

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

-- :LspInfo TODO: nvim-lspconfig source code
--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--  update_in_insert = false,
--virtual_text = {
--	format = function(diagnostic)
--		return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
--	end,
--},
--})

-- vim.lsp.set_log_level("debug") --:LspLog  
CMD( 'LspRestart2', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()) | edit', {bar= true})
CMD( 'LspCapa', 'lua =vim.lsp.get_active_clients()[1].server_capabilities', {})

Hl(0, 'LspDiagnosticsLineNrWarning', { fg = '#E5C07B', bg = '#4E4942', --[[gui = 'bold']] })

K('n', '<space>e', vim.diagnostic.open_float)
K('n', '<leader>D', vim.diagnostic.goto_prev)
K('n', '<leader>d', vim.diagnostic.goto_next)
K('n', '<space>q', vim.diagnostic.setloclist)

AU('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc' --<c-x><c-o>

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
    K('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)

    --AU({'CursorHold', 'CursorHoldI'}, { callback = vim.diagnostic.open_float})
    --vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.supports_method('textDocument/codeAction') then
      local function code_action_listener()
        local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
        local params = vim.lsp.util.make_range_params()
        params.context = context
        vim.lsp.buf_request(0, 'textDocument/codeAction', params, function(err, result, ctx, config)
          -- do something with result - e.g. check if empty and show some indication such as a sign
        end)
      end
      AU({'CursorHold', 'CursorHoldI'}, { callback = code_action_listener } )
    end

    require 'lspsaga'.setup {}
    K("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
    K({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
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
    K("n", "[E", function() require"lspsaga.diagnostic":goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
    K("n", "]E", function() require"lspsaga.diagnostic":goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
    K("n","<leader>o", "<cmd>Lspsaga outline<CR>")
    K("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    K("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")
    -- ++quiet hides 'no hover doc' notification. Pressing the key twice will enter the hover window
    -- ++keep if you want to keep the hover window in the top right hand corner
    -- Note that if you use hover with ++keep, pressing this key again will
    -- close the hover window. If you want to jump to the hover window
    -- you should use the wincmd command "<C-w>w"
    K("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    K("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
    K({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
  end
})

require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', }, --> in Neovim
      diagnostics = {
        globals = { 'vim', 'require', 'print' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),-- Make the server aware of Neovim runtime files
      },
      telemetry = { enable = false },-- Do not send telemetry data containing a randomized but unique identifier
    },
  },
}

require 'lspconfig'.bashls.setup { }
require 'lspconfig'.tsserver.setup { }
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
  }

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
})

require 'lspconfig'.gopls.setup {}

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

local null_ls = require("null-ls")
null_ls.setup({
  diagnostics_format = "#{m} (#{s}: #{c})",
  sources = {
    null_ls.builtins.diagnostics.eslint,
    --null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.formatting.prettier,
    --null_ls.builtins.formatting.stylelint,
    --null_ls.builtins.formatting.rustywind,

    --null_ls.builtins.code_actions.proselint
    --null_ls.builtins.completion.spell,
    --null_ls.builtins.diagnostics.cspell,
    --null_ls.builtins.diagnostics.alex,
    --null_ls.builtins.diagnostics.codespell,
    --null_ls.builtins.diagnostics.misspell
    --null_ls.builtins.formatting.prismaFmt,
    --null_ls.builtins.diagnostics.commitlint,

    --null_ls.builtins.code_actions.gomodifytags -- requires Go tree-sitter parser
    --null_ls.builtins.formatting.stylua,
    --null_ls.builtins.formatting.golines,
    null_ls.builtins.formatting.rustfmt,
    --null_ls.builtins.code_actions.ltrs
    --null_ls.builtins.diagnostics.buf
    --null_ls.builtins.diagnostics.editorconfig_checker
    --null_ls.builtins.diagnostics.gitlint
    --null_ls.builtins.code_actions.gitrebase

    --null_ls.builtins.diagnostics.cfn_lint

    null_ls.builtins.code_actions.gitsigns,
    --null_ls.builtins.code_actions.refactoring,
    --null_ls.builtins.completion.luasnip,
    --null_ls.builtins.completion.vsnip,
    --null_ls.builtins.completion.tags
  },
})
local gitsigns = null_ls.builtins.code_actions.gitsigns.with({
    config = {
        filter_actions = function(title)
            return title:lower():match("blame") == nil -- filter out blame actions
        end,
    },
})

-- Define the command to run Prettier
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

vim.cmd [[ inoremap <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"]]

--vim.cmd [[
--  command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
--  function! s:ChangeCurrentDir(directory, bang)
--      if a:directory == ''
--          lcd %:p:h
--      else
--          execute 'lcd' . a:directory
--      endif
--
--      if a:bang == ''
--          pwd
--      endif
--  endfunction
--
--  " Change current directory.
--  nnoremap <silent> <Space>cd :<C-u>CD<CR>
--]]

--vim.cmd [[
--  function! s:is_changed() "{{{
--      try
--          " When no `b:vimrc_changedtick` variable
--          " (first time), not changed.
--          return exists('b:vimrc_changedtick')
--          \   && b:vimrc_changedtick < b:changedtick
--      finally
--          let b:vimrc_changedtick = b:changedtick
--      endtry
--  endfunction "}}}
--  autocmd vimrc CursorMovedI * if s:is_changed() | doautocmd User changed-text | endif
--
--  let s:current_changed_times = 0
--  let s:max_changed_times = 20
--  function! s:changed_text() "{{{
--      if s:current_changed_times >= s:max_changed_times - 1
--          call feedkeys("\<C-g>u", 'n')
--          let s:current_changed_times = 0
--      else
--          let s:current_changed_times += 1
--      endif
--  endfunction "}}}
--  autocmd vimrc User changed-text call s:changed_text()
--]]


--vim.opt.clipboard = {
--  name = 'WslClipboard',
--  copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
--  paste = {
--    ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--    ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
--  },
--  cache_enabled = 0
--}

vim.cmd [[ 
    let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': 'clip.exe',
    \      '*': 'clip.exe',
    \    },
    \   'paste': {
    \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }
    ]]

--set number
--augroup numbertoggle
-- autocmd!
-- autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
-- autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
--augroup END

require 'nvim-cursorword'
require 'digraph'

-- local luasnip = require 'luasnip' --?
--local cmp = require'cmp'
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

-- Set up lspconfig.
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--  capabilities = capabilities
--}


vim.api.nvim_create_autocmd({ "BufReadPost" },
  { pattern = { "*" }, callback = function() vim.api.nvim_exec('silent! normal! g`"zv', false) end, })
