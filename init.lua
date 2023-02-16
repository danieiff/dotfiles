local K, H = vim.keymap.set, vim.api.nvim_set_hl; --local AU = vim.api.nvim_create_autocmd

local options = {
  updatetime = 3000, timeoutlen = 1000,
  virtualedit = 'block',
  autowriteall = true, undofile = true, -- persistent undo history saved in {undodir}
  shell = 'bash -l', -- login: bash reads ~/.profile at startup 
  showmatch = true, matchtime = 1, ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 2, expandtab = true, smartindent = true, list = true, listchars = { tab = '==', trail = '=' },
  pumheight = 10, pumblend = 10, winblend = 10, showtabline = 2, number = true, signcolumn = "yes", termguicolors = true, cmdheight = 0,
  -- synmaxcol = 0 -- Remove limit col number for syntax highlighting line
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
K( "n", "<Leader>.,", ":<C-u>luafile $MYVIMRC<CR>", keymaps_opts )
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
require'telescope'.setup()

require'leap'.add_default_mappings()
local hop = require'hop'
hop.setup()
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})


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
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = { smart_rename = "grr", },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  }
}


require'indent_blankline'.setup {
  --char = '|',
  --context_char = "▎",
  show_current_context = true,
  show_current_context_start = true,
  use_treesitter = true
}
require'Comment'.setup {
  pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
  toggler = { line = 'gcc', block = 'gbc' }, --LHS of toggle mappings in NORMAL mode
  opleader = { line = 'gc', block = 'gb' }, --LHS of operator-pending mappings in NORMAL and VISUAL mode
  extra = { above = 'gc0', below = 'gco', eol = 'gcA' },
}
require'nvim-surround'.setup()

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
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'require', 'print'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.bashls.setup{
  on_attach = on_attach,
}
require'lspconfig'.tsserver.setup{
  on_attach = on_attach,
}
require'lspconfig'.tailwindcss.setup {
  on_attach = on_attach,
  filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  handlers = {
    ["tailwindcss/getConfiguration"] = function (_, _, params, _, bufnr, _)
      -- tailwindcss lang server waits for this repsonse before providing hover
      vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
    end
  }

}

vim.diagnostic.open_float()
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

-- vim.cmd [[
--  set laststatus=2 "ステータス表示
--  set wildmenu "ファイル名補完
--  set lines=70 columns=150 "デフォルトの画面サイズ
--  set ruler "ルーラーを表示
--  " Netrw SETTINGS "ファイラー「Netrw」の設定
--  let g:netrw_banner = 0 "上部のバナー表示の設定
--  let g:netrw_liststyle = 3 "ツリー表示スタイル設定
--  let g:netrw_browse_split = 4 "ブラウズ分割設定
--  let g:netrw_winsize = 30 "表示幅設定
--  let g:netrw_sizestyle = "H" "データサイズの表示設定
--  let g:netrw_timefmt = "%Y/%m/%d(%a) %H:%M:%S" "ファイル日付表示設定
--  let g:netrw_preview = 1  "プレビュー画面分割設定
-- ]]

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

-- vim.api.nvim_set_hl(0, "variable",               { '#EFEFEF' })
-- vim.api.nvim_set_hl(0, "@variable",              { '#EFEFEF' })
--

