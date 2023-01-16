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
  termguicolors=true,  pumblend = 10, winblend = 10, ambiwidth = 'double', 
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
 }
for _, map in pairs(keymaps) do vim.api.nvim_set_keymap(unpack(map)) end

-- :LspInfo
require'lspconfig'.sumneko_lua.setup {
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
-- 
-- " augroup TransparentBG
-- "   au!
-- "   au Colorscheme * highlight Normal ctermbg=NONE
-- "   au Colorscheme * highlight NonText ctermbg=NONE
-- "   au Colorscheme * highlight LineNr ctermbg=NONE
-- "   au Colorscheme * highlight Folded ctermbg=NONE
-- "   au Colorscheme * highlight EndOfBuffer ctermbg=NONE 
-- " augroup END
require'vscode'.setup { transparent = true } -- vim.cmd("colorscheme slate")
