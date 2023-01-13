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
set directory=~/.vim/tmp "put .swp files here
set clipboard=unnamedplus 

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

# GitHub Copilot
## :Copilot setup

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


colorscheme codedark

augroup TransparentBG
    autocmd!
  autocmd Colorscheme * highlight Normal ctermbg=none
  autocmd Colorscheme * highlight NonText ctermbg=none
  autocmd Colorscheme * highlight LineNr ctermbg=none
  autocmd Colorscheme * highlight Folded ctermbg=none
  autocmd Colorscheme * highlight EndOfBuffer ctermbg=none 
augroup END
