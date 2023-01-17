local options = {
  mouse = 'a',
  virtualedit = 'block',
  clipboard = 'unnamedplus',
  undofile = true,
  shell = 'bash -l', -- login: bash reads ~/.profile at startup 
  foldmethod = 'expr', foldexpr = "nvim_treesitter#foldexpr()", 
  showmatch = true, matchtime = 1,
  ignorecase = true, smartcase = true, 
  tabstop = 2, shiftwidth = 2, expandtab = true, smartindent= true,
  pumblend = 10, winblend = 10, ambiwidth = 'double', termguicolors = true, -- :hi Normal guibg=NONE -- Transparent BG in WSL Win Terminal
  number = true, 
  pumheight = 10,
}
for k, v in pairs(options) do vim.opt[k] = v end

-- local options_append = {
-- }
-- for k, v in pairs(options) do vim.opt[k]:append(v) end
for k, v in pairs({ clipboard = { unnamedplus = true } }) do vim.opt[k]:append(v) end

vim.api.nvim_create_autocmd({ "BufReadPost" }, { pattern = { "*" }, callback = function() vim.api.nvim_exec('silent! normal! g`"zv', false) end, })

local keymaps_opts = { noremap = true, } -- silent = true }
local term_opts = { silent = true }
vim.g.mapleader = " "
local keymaps = {
  -- Move between windows
  { "n", "<C-h>", "<C-w>h", keymaps_opts },
  { "n", "<C-j>", "<C-w>j", keymaps_opts },
  { "n", "<C-k>", "<C-w>k", keymaps_opts },
  { "n", "<C-l>", "<C-w>l", keymaps_opts },
  -- Move between tabs
  { "n", "<C-Left>", ":tabprevious<CR>", keymaps_opts },
  { "n", "<C-Right>", ":tabnext<CR>", keymaps_opts },
  -- Move between buffers
  { "n", "<C-Down>", ":bprevious<CR>", keymaps_opts },
  { "n", "<C-Up>", ":bnext<CR>", keymaps_opts },
  -- Move between splits
  -- Move between splits
  { "n", "<C-S-Left>", ":vertical resize -5<CR>", keymaps_opts },
  { "n", "<C-S-Right>", ":vertical resize +5<CR>", keymaps_opts },
  { "n", "<C-S-Up>", ":resize -5<CR>", keymaps_opts },
  { "n", "<C-S-Down>", ":resize +5<CR>", keymaps_opts },
  -- Move between splits
  { "n", "<C-S-Left>", ":vertical resize -5<CR>", keymaps_opts },
  -- 
  { "n", "<Leader>h", ":<C-u>help<Space>", keymaps_opts },
  { "n", "<Leader>,", ":<C-u>tabnew $MYVIMRC<CR>", keymaps_opts },
  { "n", "<Leader>.,", ":<C-u>luafile $MYVIMRC<CR>", keymaps_opts },
  { "n", "<Leader>m", ":<C-u>marks<CR>", keymaps_opts },
  { "n", "<Leader>r", ":<C-u>registers<CR>", keymaps_opts },
  { "n", "<Leader>l", ":<C-u>ls<CR>", keymaps_opts },
  { "n", "<Leader>b", ":<C-u>buffer", keymaps_opts },
  --
  { "n", "Y", "y$", keymaps_opts },
  -- nnoremap +  <C-a>
  -- nnoremap -  <C-x>
  -- nnoremap j gj
  -- nnoremap k gk
  -- nnoremap ;  :
  -- nnoremap :  ;
  -- vnoremap ;  :
  -- vnoremap :  ;
  { "n", "<Leader>s", ":<C-u>%s///g<Left><Left><Left>", keymaps_opts },
  { "v", "<Leader>s", ":s///g<Left><Left><Left>", keymaps_opts },
  { "n", "<CR>", ":call append(expand('.'), '')<CR>", keymaps_opts },
  { "n", "<S-CR>", ":<C-u>k<C-u>call append(line('.')-1, '')<Cr>", keymaps_opts },
  { "n", "<BS>",  ":<C-u>k<C-u>call append(line('.')-1, '')<Cr>", keymaps_opts },
  { "n", "<Leader>q", ":<C-u>q<CR>", keymaps_opts },
  { "n", "<Leader>Q", ":<C-u>qa!<CR>", keymaps_opts },
  { "n", "<Leader>z", ":<C-u>wa<CR>", keymaps_opts },
  { "n", "<Leader>ZZ", ":<C-u>wqa<CR>", keymaps_opts },
  { "c", "<expr>/", "getcmdtype() == '/' ? '\\/' : '/'", {} },
  { "i", "jk", "<Esc>", keymaps_opts },
  { "i", ",", ", ", keymaps_opts },
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
  -- { 'n', '<space>e', vim.diagnostic.open_float, keymaps_opts }, 
  -- { 'n', '[d', vim.diagnostic.goto_prev, keymaps_opts }, 
  -- { 'n', ']d', vim.diagnostic.goto_next, keymaps_opts }, 
  -- { 'n', '<space>q', vim.diagnostic.setloclist, keymaps_opts }, 
 }
for _, map in pairs(keymaps) do vim.api.nvim_set_keymap(unpack(map)) end

-- :LspInfo
-- vim.lsp.set_log_level("debug")
-- :LspLog
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr) -- TODO: try without using attach
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
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
        globals = {'vim'},
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
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
}
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

require'vscode'.setup { 
  color_overrides = {
    vscBack = 'NONE', 
  -- vscPopupBac = 'NONE', 
  -- vscFoldBackground = 'NONE', 
  -- disable_nvimtree_bg = false, 
  }, 
} -- vim.cmd("colorscheme slate")
-- " augroup TransparentBG
-- "   au!
-- "   au Colorscheme * highlight Normal ctermbg=NONE
-- "   au Colorscheme * highlight NonText ctermbg=NONE
-- "   au Colorscheme * highlight LineNr ctermbg=NONE
-- "   au Colorscheme * highlight Folded ctermbg=NONE
-- "   au Colorscheme * highlight EndOfBuffer ctermbg=NONE 
-- " augroup END

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
