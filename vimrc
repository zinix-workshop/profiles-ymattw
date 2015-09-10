" Matthew Wang's vimrc for text term with Solarized dark background
"
" Requires Vundle (https://github.com/gmarik/Vundle) to manage plugins
"
"   git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"   cp vimrc ~/.vimrc
"   vim +PluginInstall +qall
"
" Remember to change terminal type to xterm-256color!

" Load vundle and plugins
"
set nocompatible
filetype off

if version >= 700
    set runtimepath+=~/.vim/bundle/Vundle.vim
    execute "call vundle#begin()"|      " execute to avoid syntax error in vim<7

    " vundle is required!
    Plugin 'gmarik/Vundle.vim'

    " fugitive is required by gitv
    Plugin 'tpope/vim-fugitive'
    Plugin 'gregsexton/gitv'

    Plugin 'godlygeek/tabular'

    Plugin 'tpope/vim-markdown'

    Plugin 'elzr/vim-json'
    let g:vim_json_syntax_conceal = 0

    Plugin 'ahayman/vim-nodejs-complete'

    if executable('ctags')
        Plugin 'vim-scripts/taglist.vim'
        let Tlist_Auto_Open = 0
        let Tlist_Use_Right_Window = 1
        let Tlist_Exit_OnlyWindow = 1
        let Tlist_File_Fold_Auto_Close = 1
        " For TagList on mac: brew install ctags
        if has('unix') && system('uname -s') =~ '^Darwin'
            let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
        endif
    endif

    " 'Valloric/YouCompleteMe' might be better but its installation is too much
    " heavy on most systems
    "
    Plugin 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabContextDefaultCompletionType = "<c-n>"
    let g:SuperTabNoCompleteAfter =
        \ ['^', '\s', '[^-]>', "'", '[~`!@#$%^&*()+={},</?\"\[\]\|-]']

    if version > 702
        Plugin 'ymattw/AutoComplPop'
    endif

    Plugin 'altercation/vim-colors-solarized'

    execute "call vundle#end()"|        " execute to avoid syntax error in vim<7
endif

filetype plugin indent on

" vundle and plugins now loaded
"
syntax on
silent! colorscheme solarized           " Needs to be after vundle#end()

" Default background, window and font tunings
"
if has('gui_running')
    set background=light
    if has('gui_mac') || has('gui_macvim')
        set guifont=Monaco:h13
    elseif has('gui_gtk') || has('gui_gtk2')
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 13
    endif
else
    set background=dark
    set t_ti= t_te=                     " prevent clear screen after exit
endif

" Basic settings
"
set noswapfile nobackup                 " no tmp files
set incsearch smartcase ignorecase hls  " searching
set showmatch matchtime=2 synmaxcol=150 " interface
set si smarttab shiftround backspace=2  " editing
set tw=79 formatoptions=tcroqnmMB       " formatting
set nofoldenable foldmethod=manual      " folding
set foldtext=FoldText()                 " folding
set fillchars=vert:\|,fold:.            " folding
set wildmode=list:full                  " misc: complete and list matched files
set isfname-==                          " misc: '=' is not part of filename
set matchpairs+=<:>                     " misc: '%' can match <> pair in html
set et sts=4 sw=4 ts=8                  " tab: default to 4-space soft tab
set enc=utf-8                           " work with LC_COLLATE=C & LC_CTYPE=C
let mapleader = ","

if exists('&wildignorecase')
    set nowildignorecase
    set nofileignorecase                " don't ignore case on searching files
endif

if version > 603 || version == 603 && has('patch83')
    set list listchars=tab:▸\ ,trail:▌  " highlight special chars, :h dig
else
    set list listchars=tab:▸\ ,trail:_  " segment fault seen in vim 6.3.82
endif

" File type detect
"
au! BufEnter *[Mm]akefile*,[Mm]ake.*,*.mak,*.make setl filetype=make
au! BufEnter *.md,*.markdown setl filetype=markdown
au! BufEnter Gemfile,Berksfile,Thorfile,Vagrantfile setl filetype=ruby

" File type tag size
"
au! FileType html,ruby,eruby,yaml setl et sts=2 sw=2
au! FileType make setl noet sw=8
au! FileType gitcommit setl tw=72

" Colors, suitable for Solarized dark background
"
hi! link CharAtCol80 WarningMsg         " note 'set cc=+1' confuses :vsp
mat CharAtCol80 /\%80v/
hi! link SmartReplacedChar ErrorMsg
2mat SmartReplacedChar /\%xa0\|[“”‘’—]/ " happens when copy from pages/alternote
hi! link ColorColumn Search

" Powerful statusline, underlined status line looks better with cursor line
"
set noruler laststatus=2                " no ruler, always show status line
set stl=                                " reset
set stl+=\ %0*%n%*                      " buffer number
set stl+=\ %0*%f%*                      " short pathname
set stl+=\ %3*%m%*                      " modified flag
set stl+=\ %3*%r%*                      " readonly flag
set stl+=\ %1*[%{&ft}]%*                " file type
set stl+=\ %1*%{&enc}%*                 " file encoding
set stl+=\ %3*%{&ff=='dos'?'dos':''}%*  " dos format flag
set stl+=\ %3*%{&ic?'ic':'noic'}%*      " ignorecase flag
set stl+=\ %3*%{&et?'et:'.&sts:'noet:'.&ts}%*
                                      \ " expandtab and (soft)tabstop
set stl+=\ %2*%{&hls?'hls':''}%*        " highlight search flag
set stl+=\ %2*%{&list?'list':''}%*      " list mode flag
set stl+=\ %3*%{&paste?'paste':''}%*    " paste mode flag
set stl+=\ %0*%=%*                      " start to align right
set stl+=\ %0*%4l,%-2v%*                " line and column info
set stl+=\ %0*%3p%%%*                   " line percentage
hi! User1 cterm=underline ctermfg=white gui=underline guibg=#ccc6b3 guifg=#fdf6e3
hi! User2 cterm=underline ctermfg=magenta gui=underline guibg=#ccc6b3 guifg=magenta
hi! User3 cterm=underline ctermfg=red gui=underline guibg=#ccc6b3 guifg=red
hi! StatusLine cterm=underline ctermfg=blue gui=underline guibg=#ccc6b3
hi! StatusLineNC cterm=underline ctermfg=grey gui=underline guibg=#eee8d5

" Global key maps. Make sure <BS> and <C-H> are different in terminal setting!
"
nmap <Space>    :set list!<CR>|         " toggle list mode
nmap <BS>       :set ic!<CR>|           " toggle ignore case
nmap <C-N>      :set nu!<CR>|           " ctrl-n to toggle :set number
nmap <C-P>      :set paste!<CR>|        " ctrl-p to toggle paste mode
nmap <C-H>      :set hls!<CR>|          " ctrl-h to toggle highlight search
nmap <C-K>      :%s/[ \t]\+$//g<CR>|    " remove trailing blank
imap <C-J>      <ESC>kJA|               " join to prev line (undo auto wrap)
nmap <leader>t  :TlistToggle<CR>|       " toggle TagList window
nmap <leader><Tab>
              \ :call ToggleTab()<CR>|  " toggle hard/soft tab
nmap <leader>2  :set et sts=2 sw=2<CR>| " use 2-space indent
nmap <leader>4  :set et sts=4 sw=4<CR>| " use 4-space indent
nmap q:         :q|                     " q: is boring
nmap \\         :call ExecuteMe()<CR>|  " execute current file
nmap !!         :q!<CR>|                " quit without saving
nmap Q          vipgq|                  " format current paragraph
nmap qq         :q<CR>

" File type key mappings
"
au! FileType markdown nmap <buffer> T
              \ vip:Tabularize /\|<CR>| " tabularize markdown tables
au! FileType c,cpp,javascript,css nmap <buffer> <leader>c
              \ I/* <ESC>A */<ESC>|     " comment out current line with /* */
au! FileType c,cpp,javascript, css nmap <leader>u
              \ 0f*h3x$3x|              " comment out /* */

" Mode key mappings
"
if exists('&diff') && &diff
    nmap <Up>   [c|                     " previous change
    nmap <Down> ]c|                     " next change
    nmap <Left> <C-w>h|                 " left window
    nmap <Right> <C-w>l|                " right window
endif

if exists('&spell')                     " toggle spell
    nmap <CR>   :call ToggleSpell()<CR>
endif

if exists('&cursorline')                " toggle cursor line
    nmap _      :set cursorline!<CR>
endif

if exists('&cursorcolumn')              " toggle cursor column
    nmap \|     :set cursorcolumn!<CR>
endif

" Misc
"
let loaded_matchparen = 0
let python_highlight_all = 1

" Remember last cursor postion, :h last-position-jump
set viminfo='10,\"10,<50,s10,%,h,f10
au! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

if exists('&cursorline')
    set cul
    augroup ActiveBuffer
        au! WinEnter * setl cursorline
        au! WinLeave * setl nocursorline
    augroup END
endif

" Helper functions
"
function! ToggleTab()
    let expr = &et == 1 ? "setl noet sw=8" : "setl et sw=".&sts
    exe expr
endfunction

function! ToggleSpell()
    let expr = &spell == 1 ? "setl nospell cul" : "setl spell nocul"
    exe expr
endfunction

function! FoldText()
    let line = getline(v:foldstart)
    return '+' . line[1:]
endfunction

" Execute current file and pipe output to new window below, window height will
" be 1/3 of the vim window size
"
function! ExecuteMe()
    let file = expand("%:p")
    exe "botright " . (&lines / 3) . " new"
    exe ".!" .  file
endfunction

" EOF
