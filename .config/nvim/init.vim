set nocompatible
syntax on
filetype plugin on

set autoread                                                                                                                                                                                    
au CursorHold * checktime

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" automatic session management ugly proof of concept a decent plugin needed
fu! SaveSessIfExist()
if filereadable(getcwd() . '/.session.vim')
  call SaveSess()
endif
endfunction
  
fu! SaveSess()
    execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction

fu! RestoreSess()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        let g:restoreSessions = 1
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction
autocmd VimLeave * call SaveSessIfExist()
autocmd VimEnter * nested call RestoreSess()




set number 
" Spaces are better than a tab character
set expandtab
set smarttab

" better with long lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

set noshowmode

" Who wants an 8 character tab? Not me!
set shiftwidth=2
set softtabstop=2

augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20
augroup END

" coc settings
source $HOME/.config/nvim/plug-config/coc.vim

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/fern.vim'
Plug 'aaronrancsik/fern-hijack.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'tomasiser/vim-code-dark' 
Plug 'doums/barow'
Plug 'doums/barowLSP'
Plug 'doums/barowGit'
Plug 'sunaku/tmux-navigate'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'preservim/nerdcommenter'
Plug 'psliwka/vim-smoothie'
Plug 'vimpostor/vim-prism'
call plug#end()

" theme
colorscheme codedark
let $BAT_THEME='ansi'
" hi Normal ctermbg=NONE guibg=NONE
" hi NonText ctermbg=NONE guibg=NONE

" syntax highlight 
hi LspCxxHlGroupNamespace ctermfg=Cyan guifg=#51c9b1 cterm=none gui=none

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" smooth scroll
let g:smoothie_speed_linear_factor = 20
let g:smoothie_speed_constant_factor = 10
let g:smoothie_speed_exponentiation_factor = 0.99
let g:smoothie_update_interval = 10

" blamer
let g:blamer_enabled = 1 

" fzf no search in filenames pls 
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" fern
let g:cursorhold_updatetime = 100
let g:fern#renderer = "nerdfont"
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
augroup END

" barow
let g:barow = {
      \  'modules': [
      \    [ 'barowGit#branch', 'StatusLine' ],
      \    [ 'barowLSP#error', 'BarowError' ],
      \    [ 'barowLSP#warning', 'BarowWarning' ],
      \    [ 'barowLSP#info', 'BarowInfo' ],
      \    [ 'barowLSP#hint', 'BarowHint' ],
      \    [ 'barowLSP#coc_status', 'StatusLine' ]
      \  ]
      \}
