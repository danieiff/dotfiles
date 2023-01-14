"uncomment vim9script

set pumheight=10
set display=lastline

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
set clipboard=unnamedplus 
set shell=bash\ -l " --login: bash reads ~/.profile at startup 

let mapleader = "\<Space>"
nnoremap <Leader>,  :<C-u>tabnew $MYVIMRC<CR>
nnoremap <Leader>.,  :<C-u>source $MYVIMRC<CR>
nnoremap <Leader>m  :<C-u>marks<CR>
nnoremap <Leader>r  :<C-u>registers<CR>
nnoremap <Leader>l  :<C-u>ls<CR>
nnoremap <C-h>  :<C-u>help<Space>
nnoremap Y  y$
nnoremap +  <C-a>
nnoremap -  <C-x>
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

inoremap jk <Esc>

nnoremap <C-t>  <Nop>
nnoremap <C-t>n  :<C-u>tabnew<CR>
nnoremap <C-t>c  :<C-u>tabclose<CR>
nnoremap <C-t>o  :<C-u>tabonly<CR>
nnoremap <C-t>j  :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <C-t>k  gT'')))''

nnoremap t  <Nop>
nnoremap tt  <C-]>           "jump
nnoremap tj  :<C-u>tag<CR>   "go forward
nnoremap tk  :<C-u>pop<CR>   "go backward
nnoremap tl  :<C-u>tags<CR>  "history list

" GitHub Copilot >vim9 or neovim
" :Copilot setup
" let b:copilot_enabled = { '*': v:false }

"filetype plugin indent on
" LSP
 if executable('tailwindcss-intellisense')
   au User lsp_setup call lsp#register_server({
         \ 'name': 'tailwindcss-intellisense',
         \ 'cmd': {server_info->['tailwindcss-intellisense', '--stdio']},
         \ 'allowlist': ['css', 'html', 'htmldjango', 'typescriptreact'],
         \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tailwind.config.cjs'))},
         \ })
 endif

" let g:lsp_folding_enable = 0 TODO: check issue
" set foldmethod=expr
"   \ foldexpr=lsp#ui#vim#folding#foldexpr()
"   \ foldtext=lsp#ui#vim#folding#foldtext()

" Status Line
set statusline=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}
set rulerformat=%15(%c%V\ %p%%%)
"set rulerformat=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}

function! FileTime()
  let ext=tolower(expand("%:e"))
  let fname=tolower(expand('%<'))
  let filename=fname . '.' . ext
  let msg=""
  let msg=msg." ".strftime("(Modified %b,%d %y %H:%M:%S)",getftime(filename))
  return msg
endfunction

function! CurTime()
  let ftime=""
  let ftime=ftime." ".strftime("%x %b,%d %y %H:%M:%S")
  return ftime
endfunction

augroup TransparentBG
  au!
  au Colorscheme * highlight Normal ctermbg=NONE
  au Colorscheme * highlight NonText ctermbg=NONE
  au Colorscheme * highlight LineNr ctermbg=NONE
  au Colorscheme * highlight Folded ctermbg=NONE
  au Colorscheme * highlight EndOfBuffer ctermbg=NONE 
augroup END
colorscheme codedark

"swap file
set dir=~/.vim/swp "put .swp files here
augroup swapchoice-readonly
  au!
  au SwapExists * let v:swapchoice = 'o'
augroup END
