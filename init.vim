call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
"
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#coc#enabled = 0
let airline#extensions#coc#error_symbol = 'Error:'
let airline#extensions#coc#warning_symbol = 'Warning:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}' 
let g:airline_theme = 'minimalist'
"
set number
set showmatch matchtime=1
set ignorecase        
set smartcase       
set incsearch         
set mouse=a       
set fileformats=unix,dos
set noerrorbells
set laststatus=2
set linebreak
set tabstop=2 expandtab
set virtualedit=block 
set hidden    
set statusline^=%{coc#status()}

nnoremap <Space>.v  :<C-u>tabnew $MYVIMRC<CR>
nnoremap <Space>s.  :<C-u>source $MYVIMRC<CR>
nnoremap <Space>m  :<C-u>marks<CR>
nnoremap <Space>r  :<C-u>registers<CR>
nnoremap <Space>l  :<C-u>ls<CR>
nnoremap <C-h>  :<C-u>help<Space>
nnoremap <Space>n  :<C-u>NERDTreeToggle<CR>
nnoremap gc  `[v`]
nnoremap j gj
nnoremap k gk
nnoremap ;  :
nnoremap :  ;
vnoremap ;  :
vnoremap :  ;
nnoremap gs  :<C-u>%s///g<Left><Left><Left>
vnoremap gs  :s///g<Left><Left><Left>
nnoremap 0 :<C-u>call append(expand('.'), '')<Cr>j
nnoremap 9 :<C-u>k<C-u>call append(line('.')-1, '')<Cr>

cnoremap <expr> /
\ getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?
\ getcmdtype() == '/' ? '\/' : '/'

inoremap jj <Esc>               "<------

nnoremap <C-t>  <Nop>
nnoremap <C-t>n  :<C-u>tabnew<CR>
nnoremap <C-t>c  :<C-u>tabclose<CR>
nnoremap <C-t>o  :<C-u>tabonly<CR>
nnoremap <C-t>j  :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <C-t>k  gT'')))''

nnoremap t  <Nop>
nnoremap tt  <C-]>           "「飛ぶ」
nnoremap tj  :<C-u>tag<CR>   "「進む」
nnoremap tk  :<C-u>pop<CR>   "「戻る」
nnoremap tl  :<C-u>tags<CR>  "履歴一覧

"
augroup MyAutoCmd
  autocmd!
  autocmd VimEnter * set t_ut=  "wsl display setting 
  autocmd BufWritePost ~/.config/nvim/init.vim, source $MYVIMRC | set foldmethod=marker
  autocmd vimenter * ++nested colorscheme gruvbox
 "autocmd vimenter * NERDTree
 "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END 
"
