local K, H, AU = vim.keymap.set, vim.api.nvim_set_hl, vim.api.nvim_create_autocmd

local options = {
  updatetime = 3000, timeoutlen = 1000,
  virtualedit = 'block',
  autowriteall = true, undofile = true, -- persistent undo history saved in {undodir}
  shell = 'bash -l', -- login: bash reads ~/.profile at startup 
  showmatch = true, matchtime = 1, ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 2, expandtab = true, smartindent = true, list = true, listchars = { tab = '__', trail = '_' },
  pumheight = 10, pumblend = 10, winblend = 10, showtabline = 2, number = true, signcolumn = "yes", termguicolors = true, cmdheight = 0, --[[statuscolumn = '%#NonText#%{&nu?v:lnum:""}%=%{&rnu&&(v:lnum%2)?" ".v:relnum:""}%#LineNr#%{&rnu&&!(v:lnum%2)?" ".v:relnum:""}',]]
  foldmethod = 'expr', foldexpr = "nvim_treesitter#foldexpr()", foldenable = false,
}
for k, v in pairs(options) do vim.opt[k] = v end

H( 0, 'LspDiagnosticsLineNrWarning', { fg = '#E5C07B', bg = '#4E4942', --[[gui = 'bold']] } )
vim.cmd("sign define LspDiagnosticsSignWarning texthl=LspDiagnosticsSignWarning numhl=LspDiagnosticsLineNrWarning")

vim.api.nvim_create_autocmd({ "BufReadPost" }, { pattern = { "*" }, callback = function() vim.api.nvim_exec('silent! normal! g`"zv', false) end, })

local keymaps_opts = { noremap = true, } -- silent = true }
vim.g.mapleader = " "
-- Move between windows
K( "n", "<C-h>", "<C-w>h", keymaps_opts )
K( "n", "<C-j>", "<C-w>j", keymaps_opts )
K( "n", "<C-k>", "<C-w>k", keymaps_opts )
K( "n", "<C-l>", "<C-w>l", keymaps_opts )
-- Move between tabs
K( "n", "<C-Left>", ":tabprevious<CR>", keymaps_opts )
K( "n", "<C-Right>", ":tabnext<CR>", keymaps_opts )
-- Move between buffers
K( "n", "<C-Down>", ":bprevious<CR>", keymaps_opts )
K( "n", "<C-Up>", ":bnext<CR>", keymaps_opts )
-- Move between splits
K( "n", "<C-S-Left>", ":vertical resize -5<CR>", keymaps_opts )
K( "n", "<C-S-Right>", ":vertical resize +5<CR>", keymaps_opts )
K( "n", "<C-S-Up>", ":resize -5<CR>", keymaps_opts )
K( "n", "<C-S-Down>", ":resize +5<CR>", keymaps_opts )
-- Move between splits
K( "n", "<C-S-Left>", ":vertical resize -5<CR>", keymaps_opts )
K( "n", "<Leader>h", ":<C-u>help<Space>", keymaps_opts )
K( "n", "<Leader>,", ":<C-u>tabnew $MYVIMRC<CR>", keymaps_opts )
K( "n", "<Leader>.,", ":<C-u>luafile $MYVIMRC<CR>", keymaps_opts ) -- ':helptags ALL'
K( "n", "<Leader>m", ":<C-u>marks<CR>", keymaps_opts )
K( "n", "<Leader>r", ":<C-u>registers<CR>", keymaps_opts )
K( "n", "<Leader>l", ":<C-u>ls<CR>", keymaps_opts )
K( "n", "<Leader>b", ":<C-u>buff)r", keymaps_opts )
-- 
K( "n", "Y", "y$", keymaps_opts )
-- nnoremap +  <C-a>
-- nnoremap -  <C-x>
K( "n", "j", "gj", keymaps_opts )
K( "n", "k", "gk", keymaps_opts )
-- nnoremap ;  :
-- nnoremap :  ;
-- vnoremap ;  :
-- vnoremap :  ;
K( "n", "<Leader>s", ":<C-u>%s///g<Left><Left><Left>", keymaps_opts )
K( "n", "<Leader>t", ':<C-u>term  && exit' .. string.rep('<left>', 8), keymaps_opts )
K( 't', '<C-o>', '<C-\\><C-n><C-o>', keymaps_opts )
--AU( 'TermOpen', { pattern = '*', callback = function() vim.cmd('setlocal nonumber norelativenumber signcolumn=no showtabline=1 | startinsert') end } )
AU( 'TermClose', { pattern = '*', callback = function() vim.cmd('bdelete') end } )
--K( "n", "<Leader>t", ':<C-u>term  && exit' .. '<Left><Left><Left><Left><Left><Left><Left><Left>", table.insert(keymaps_opts, { silent = true }) )
-- yy:@"
K( "v", "<Leader>s", ":s///g<Left><Left><Left>", keymaps_opts )
K( "v", "z/", "<ESC>/\\%V",  keymaps_opts )
K( "v", "z?", "<ESC>?\\%V",  keymaps_opts )
K( "n", "<CR>", ":call append(expand('.'), '')<CR>j", keymaps_opts )
K( "n", "<S-CR>", ":call append(line('.')-1, '')<Cr>k", keymaps_opts )
K( "n", "<BS>",  ":call append(line('.')-1, '')<Cr>k", keymaps_opts )
K( "n", "<Leader>q", ":<C-u>q<CR>", keymaps_opts )
K( "n", "<Leader>Q", ":<C-u>qa!<CR>", keymaps_opts )
K( "n", "<Leader>z", ":<C-u>wa<CR>", keymaps_opts )
K( "n", "<Leader>ZZ", ":<C-u>wqa<CR>", keymaps_opts )
K( "c", "<expr>/", "getcmdtype() == '/' ? '\\/' : '/'", {} )
K( "i", "jk", "<Esc>", keymaps_opts )
K( "i", ",", ", ", keymaps_opts )
K( "n", "L", "J", keymaps_opts )
K( "n", "J", "gt", keymaps_opts )
K( "n", "K", "gT", keymaps_opts )
K( "n", "(", ":bn<CR>", keymaps_opts )
K( "n", ")", ":bN<CR>", keymaps_opts )
K( "n", "0", "^", keymaps_opts )
K( "n", "^", "0", keymaps_opts )
-- nnoremap <C-t>  <Nop>
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


require'telescope'.setup()

vim.cmd [[
" netrw
let g:netrw_sizestyle="H"
let g:netrw_preview=1 " preview は左右分割表示
let g:netrw_liststyle=3 " tree表示
let g:netrw_keepdir = 0 " tree開いた位置を current dir として扱う。その階層でファイル作成とかができるようになる
let g:netrw_banner = 0 " 上のバナー消す
"window サイズ
let g:netrw_winsize = 25
let g:netrw_browse_split = 4

"Netrw を toggle する関数を設定
"元処理と異なり Vex を呼び出すことで左 window に表示
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Vex
    endif
endfunction

noremap <silent><C-e> :call ToggleNetrw()<CR>
]]
-- :e | completion
-- @:


require'leap'.add_default_mappings()

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "lua", "python", "javascript", "typescript", "html", "css", "json", "yaml", "toml", "go", "rust", "jsonc", "graphql", "dockerfile", "vim", "tsx" },
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

require'indent_blankline'.setup { show_current_context = true, show_current_context_start = true, use_treesitter = true }
require'Comment'.setup {
  pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
  toggler = { line = 'gcc', block = 'gbc' }, --LHS of toggle mappings in NORMAL mode
  opleader = { line = 'gc', block = 'gb' }, --LHS of operator-pending mappings in NORMAL and VISUAL mode
  extra = { above = 'gc0', below = 'gco', eol = 'gcA' },
}
require'nvim-surround'.setup()
require'nvim-autopairs'.setup()

--K('n', '[[', '<cmd>AerialPrev<CR>', { buffer = bufnr })
--K('n', ']]', '<cmd>AerialNext<CR>', { buffer = bufnr })
--K('n', '<leader>a', '<cmd>AerialToggle<CR>')

K ('n',  '<Leader>e', vim.diagnostic.open_float, keymaps_opts )
-- :LspInfo
vim.lsp.set_log_level("debug")
-- :LspLog
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.api.nvim_command('autocmd CursorHold * lua vim.diagnostic.open_float()')
  vim.api.nvim_command('autocmd CursorHoldI * lua vim.diagnostic.open_float()')
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  K( 'n', 'gD', vim.lsp.buf.declaration, bufopts)
  K( 'n', 'gd', vim.lsp.buf.definition, bufopts)
  K( 'n', '<Leader>k', vim.lsp.buf.hover, bufopts)
  K( 'n', 'gi', vim.lsp.buf.implementation, bufopts)
  K( 'n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  K( 'n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  K( 'n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  K( 'n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  K( 'n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  K( 'n', '<space>rn', vim.lsp.buf.rename, bufopts)
  K( 'n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  K( 'n', 'gr', vim.lsp.buf.references, bufopts)
  K( 'n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', }, --> in Neovim
      diagnostics = {
        globals = {'vim', 'require', 'print'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

require'lspconfig'.bashls.setup{ on_attach = on_attach }
require'lspconfig'.tsserver.setup{ on_attach = on_attach }
AU({ "BufNewFile", "BufRead" }, {
	pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
	callback = function()
		vim.diagnostic.disable(0)
	end,
	group = disable_node_modules_eslint_group,
})
require'lspconfig'.tailwindcss.setup {
  on_attach = on_attach,
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  handlers = {
    ["tailwindcss/getConfiguration"] = function (_, _, params, _, bufnr, _)
      -- tailwindcss lang server wai swap = {
      vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
    end
  }

}
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.completion.spell,
  },
})
vim.diagnostic.setqflist({ open = false })

require'symbols-outline'.setup()

require'gitsigns'.setup()

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

require'nightfox'.setup { options = { inverse = { search = true } } }
vim.cmd'colorscheme nordfox'
H( 0, '@variable', { fg = 'NONE' } )

H( 0, 'Normal', { bg = 'NONE' } )
H( 0, 'NonText', { bg = 'NONE' } )
H( 0, 'LineNr', { fg = '#767676', bg = 'NONE' } )
H( 0, 'Folded', { bg = 'NONE' } )
H( 0, 'EndOfBuffer', { bg = 'NONE' } )
H( 0, 'TabLineFill', { bg = 'NONE' } )
H( 0, 'TabLine', { bg = 'NONE' } )
H( 0, 'TabLineSel', { bg = '#545454' } )

require'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

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
