let mapleader = "\<Space>"
"let g:snipMate.snippet_version = 1

colorscheme evening

autocmd BufRead,SourcePre,WinNew * highlight trailingWhitespace ctermbg=Red guibg=red
"autocmd sourcePre * highlight trailingWhitespace ctermbg=Red guibg=red
"autocmd winNew * highlight trailingWhitespace ctermbg=Red guibg=red

autocmd BufRead,SourcePre,WinNew * match trailingWhitespace /\s\+$/
"autocmd sourcePre * match trailingWhitespace /\s\+$/
"autocmd winNew * match trailingWhitespace /\s\+$/

autocmd BufRead,BufNewFile *.pug setlocal wrap

filetype plugin on

noremap <Leader>n :noh<CR>
noremap <Leader>v :tabedit $MYVIMRC<CR>
noremap <Leader>vv :source $MYVIMRC<CR>

nnoremap <Leader>g :!git<Space>

inoremap <S-CR> <CR><Tab>

autocmd BufRead,BufNewFile * hi Folded ctermbg=DarkBlue ctermfg=White guibg=#666666 guifg=white

set
	\ autoindent
	\ autoread
	\ backspace=indent,eol,start
	\ complete=.
	\ encoding=utf-8
	\ foldmethod=indent
	\ guifont=consolas:h12
	\ guioptions=""
	\ hlsearch ignorecase incsearch
	\ nowrap
	\ relativenumber
	\ ruler
	\ scrolloff=1 sidescrolloff=1
	\ shiftwidth=0
	\ smartcase
	\ splitbelow splitright
	\ tabstop=4
	\ wildmode=longest

syntax enable
