set nocompatible " Vim not vi

" The following is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 

" Vim-Plug
" ========
call plug#begin('~/.nvim/plugged')
" Language server protocol:
Plug 'neovim/nvim-lspconfig'
Plug 'anott03/nvim-lspinstall'
" Fuzzy finding:
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Plug 'kien/ctrlp.vim'
" Plug 'cloudhead/neovim-fuzzy'
" Plug 'sjl/gundo.vim'
" Undo:
Plug 'mbbill/undotree'
" Enhanced syntax parsing:
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Clipboard:
Plug 'maxbrunsfeld/vim-yankstack'
" TMUX integration:
Plug 'jpalardy/vim-slime'
" GNU global and Ctags:
Plug 'jsfaint/gen_tags.vim'
Plug 'vim-scripts/taglist.vim'
" Snippets:
"Plug 'majutsushi/tagbar'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Tim Pope:
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'rebelot/kanagawa.nvim'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'logico/typewriter-vim'
Plug 'ErichDonGubler/vim-sublime-monokai'
Plug 'nanotech/jellybeans.vim'
Plug 'xiyaowong/nvim-transparent'
" On-demand loading - programming languages:
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'jalvesaq/Nvim-R', { 'for': 'r' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
" File Tree:
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Add plugins to &runtimepath
call plug#end()

" Make Y behave just like C and D:
noremap Y y$
noremap U y$

" See :help 'guicursor'
":set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
"  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"  \,sm:block-blinkwait175-blinkoff150-blinkon175
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
elseif empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif


" Backup and Swap-Directories
set directory=~/.nvim/tmp/swap
set backupdir=~/.nvim/tmp/backup
" persistent undo:
if(version >= 703)
  set undofile
  set undodir=~/.nvim/tmp/undo
endif

" General settings
let mapleader = "\<space>"
let maplocalleader = "\\"
set wildmenu
set wildmode=full
set ls=2
set hidden
syntax enable
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set number
set relativenumber
filetype plugin indent on 
" No error-bell nor flash
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
set cursorline
"set autochdir " always switch to the current file directory
set ignorecase
set smartcase

" Neovim LSP customizations; see:
" https://github.com/neovim/nvim-lspconfig
" (last visited 15th of February 2021)
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.get()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<space>h', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
  

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

let g:LanguageClient_serverCommands = {
      \ 'r': ['R', '--slave', '-e', 'languageserver::run()'],
      \ }


" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory = '~/.config/nvim/my_neosnippets'

" Toggle NERDTree:
nnoremap <Leader>n :NERDTreeToggle<CR>

" Close all Buffers except the current one:
com! -nargs=0 BufOnly :%bd | e#

" Jump to alternate buffer:
nnoremap <Leader>, :b#<CR>

" Shortcut to :only
nnoremap <Leader>. :only<CR>

" Formatting:
map Q gq
" Format a paragraph:
nnoremap <Leader>q :normal Qipg;g;<CR>
"set textwidth=80

"Remap Arrows to navigate with prepended 'g',
"so one can navigate through wrapped lines:
noremap <up> gk
noremap <down> gj
noremap k gk
noremap j gj
inoremap <A-k> <esc>g<up>i
inoremap <A-j> <esc>g<down>i
"Colorscheme & Font:
if has("mac")
  set gfn=Monaco:h13
  colorscheme jellybeans
  set background=dark
else
  set gfn=Monospace\ 12
  if !has('gui_running')
    colorscheme gruvbox
  else
    colorscheme jellybeans
  endif
endif

" Yankstack:
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste

" Wrapping:
command! -nargs=* Wrap set wrap linebreak nolist
" set showbreak=…

" vim-slime
let g:slime_target = "tmux"
let g:slime_paste_file = "$HOME/.slime_paste"
let g:slime_default_config = {"socket_name": "default", "target_pane": "1.2"}

" Format R files:
command! FrmtR !R -e 'require(formatR); tidy_source("%", file="%", width.cutoff=45)'

" Surround for eruby:
" autocmd FileType eruby let b:surround_37 = "<% \r %>"
" autocmd FileType eruby let b:surround_61 = "<%= \r %>"
" autocmd FileType eruby let b:surround_35 = "#{ \r }"
" autocmd FileType ruby let b:surround_35 = "#{ \r }"

" Rust (rust.vim)
let g:rustfmt_autosave = 1

"" rust-analyzer-language-server
"let g:ale_linters = {'rust': ['analyzer']}

" Spellcheck:
com Se set spell spelllang=en
com Sd set spell spelllang=de
" Ctrl-Z in INSERT mode will correct last misspelled word before current
" cursor position:
inoremap <C-z> <Esc>[s1z=gi

" Format Javascript Code-File:
autocmd FileType javascript setlocal equalprg=js-beautify\ --stdin\ -s\ 2\ -w\ 80
augroup filetypedetect
  " associate *.ejs with javascript filetype
  au BufRead,BufNewFile *.ejs setfiletype javascript
  au BufRead,BufNewFile *.vue setfiletype javascript
augroup END

" rails-vim and ctags
" ctag the RVM-Environment and write those tags into ./tmp/rvm_env_tags
fun! RtagsEnvFunky() 
  !mkdir -p ./tmp && ctags -f ./tmp/rvm_env_tags -R --langmap="ruby:+.rake.builder.rjs" --c-kinds=+p --fields=+S --languages=-javascript $GEM_HOME/gems $MY_RUBY_HOME 
  set tags+=tmp/rvm_env_tags
endfun
com! RtagsEnv :call RtagsEnvFunky()
if(filereadable("tmp/rvm_env_tags"))
  set tags+=tmp/rvm_env_tags
endif

" Cscope for Ruby on current directory.
" (
" To add GEMs and Ruby add following between '.' and '-iname':
" $GEM_HOME $MY_RUBY_HOME
" )
com! Rscope !find . -iname '*.rb' -o -iname '*.erb' -o -iname '*.rhtml' <bar> cscope -q -i - -b

if has("cscope")
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
  set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f-
endif

nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
" end Cscope

" Taglist
map <LocalLeader>, :TlistToggle <CR>
map <LocalLeader>- :TlistUpdate <CR>
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1
let Tlist_Auto_Update = 1
let Tlist_Sort_Type = "name"
" enable support for R / Splus:
let tlist_r_settings = 'Splus;r:object/function'

" Folding stuff
" set foldmethod=indent
" set foldlevelstart=1
" set foldminlines=1
" set foldignore=''
"hi Folded guibg=red guifg=Red cterm=bold ctermbg=DarkGrey ctermfg=lightblue
"hi FoldColumn guibg=grey78 gui=Bold guifg=DarkBlue
"set foldcolumn=2
"set foldclose=
"set foldnestmax=2
"set fillchars=vert:\|,fold:\

" Telescope:
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Define Function Quick-Fix-List-Do:
fun! QFDo(bang, command) 
     let qflist={} 
     if a:bang 
         let tlist=map(getloclist(0), 'get(v:val, ''bufnr'')') 
     else 
         let tlist=map(getqflist(), 'get(v:val, ''bufnr'')') 
     endif 
     if empty(tlist) 
        echomsg "Empty Quickfixlist. Aborting" 
        return 
     endif 
     for nr in tlist 
     let item=fnameescape(bufname(nr)) 
     if !get(qflist, item,0) 
         let qflist[item]=1 
     endif 
     endfor 
     :exe 'argl ' .join(keys(qflist)) 
     :exe 'argdo ' . a:command 
endfunc 
com! -nargs=1 -bang Qfdo :call QFDo(<bang>0,<q-args>)

" Enable JQuery-Syntax
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

"""""""""""""""""""""""""""""""""""
" Bram Moolenaar's .vimrc-example "
"""""""""""""""""""""""""""""""""""
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=1000	" keep 1000 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nohlsearch " No highlighting of search terms

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
map <Leader>o :DiffOrig <CR>

""""""""""""""""""""""""""""""""""""""""""
" End of Bram Moolenaar's .vimrc-example "
""""""""""""""""""""""""""""""""""""""""""
