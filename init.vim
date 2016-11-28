set nocompatible " Vim not vi

" Vim-Plug
call plug#begin('~/.nvim/plugged')
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
call plug#end()

let g:UltiSnipsExpandTrigger='<C-s>'
