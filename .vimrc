set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'tell-k/vim-autopep8'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'nvie/vim-flake8'
Plugin 'altercation/vim-colors-solarized'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'leshill/vim-json'
Plugin 'w0rp/ale'
" All of your Plugins must be added before the following line
call vundle#end()            " required

" Plugin 'altercation/vim-colors-solarized' 
" syntax enable
set background=dark
colorscheme solarized

" Plugin 'tell-k/vim-autopep8'
let g:autopep8_disable_show_diff=1
let g:autopep8_on_save = 1

" Plugin 'vim-syntastic/syntastic'
" https://github.com/vim-syntastic/syntastic
let g:syntastic_python_checkers = ['pylint']
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_flow = 1

" Plugin 'w0rp/ale'
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

filetype plugin on
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" 					auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set undodir=~/.vim/.undo//
set noswapfile
set nobackup

" python settings
let python_highlight_all=1
syntax on
set nohidden
set wildmenu
set wildmode=list:longest
set showcmd
set hlsearch
set backspace=indent,eol,start
set laststatus=2
set confirm
set visualbell
set number
set autoindent
set copyindent
set shiftround
set expandtab
set fileformat=unix
set encoding=utf-8
set tabstop=4
set softtabstop=4
set shiftwidth=4

au BufNewFile,BufRead *.py
    \ set textwidth=79

" autocmd Filetype html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

:highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.js match ExtraWhitespace /\s\+$/

let mapleader=","

nmap <leader>n		:bnext<CR>
nmap <leader>p		:bprevious<CR>

" https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
" window
nmap <leader>swh	:topleft  vnew<CR>
nmap <leader>swl	:botright vnew<CR>
nmap <leader>swk    :topleft  new<CR>
nmap <leader>swj	:botright new<CR>
" buffer
nmap <leader>sh		:leftabove  vnew<CR>
nmap <leader>sl		:rightbelow vnew<CR>
nmap <leader>sk 	:leftabove  new<CR>
nmap <leader>sj 	:rightbelow new<CR>

nmap <silent> <C-K> :wincmd k<CR>
nmap <silent> <C-J> :wincmd j<CR>
nmap <silent> <C-H> :wincmd h<CR>
nmap <silent> <C-L> :wincmd l<CR>

autocmd BufWritePost .vimrc source %

