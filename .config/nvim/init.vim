set nocompatible
syntax on
filetype plugin on

" set laststatus 3 "soon it will be available

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


"Basic rename function
" For local replace
nnoremap ggr gd[{V%::s/<C-R>///gc<left><left><left>
" For global replace
nnoremap ggR gD:%s/<C-R>///gc<left><left><left>

set number 
" Spaces are better than a tab character
set expandtab
set smarttab

" better with long lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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
Plug 'p00f/clangd_extensions.nvim'
Plug 'cdelledonne/vim-cmake'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
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
" Plug 'aaronrancsik/barowGit'
Plug 'sunaku/tmux-navigate'
Plug 'preservim/nerdcommenter'
Plug 'psliwka/vim-smoothie'
Plug 'lambdalisue/suda.vim'
call plug#end()

" new syntax highlight
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- List of parsers to ignore installing
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  playground = {
      enable = true,
  }
}


EOF




" cmake
let g:cmake_link_compile_commands = 1
nmap <leader>cmg :CMakeGenerate<cr>
nmap <leader>cmb :CMakeBuild<cr>
nmap <leader>gt :GTestRunUnderCursor<cr>

" theme
" For dark theme
let g:vscode_style = "dark"
" Enable transparent background.
let g:vscode_transparency = 1
" Enable italic comment
let g:vscode_italic_comment = 1
colorscheme codedark

" undercurl after theme
hi CocUnderline gui=undercurl term=undercurl
hi CocErrorHighlight gui=undercurl term=undercurl guisp=red
hi CocWarningHighlight gui=undercurl term=undercurl guisp=yellow


nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>

" make theme bg transparent
 hi Normal           ctermbg=none guibg=none
 hi CursorLineNr                  guibg=none
 hi EndOfBuffer                   guibg=none
 hi Folded           ctermbg=none guibg=none
 hi LineNr           ctermbg=none guibg=none
 hi SignColumn       ctermbg=none guibg=none
 hi FernBranchSymbol ctermbg=none guibg=none
 hi FernLeafSymbol   ctermbg=none guibg=none


" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Disable default mappings
let g:NERDCreateDefaultMappings = 0
" custom mappings
map <C-_> <plug>NERDCommenterToggle


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
  " \    [ 'barowGit#branch', 'StatusLine' ],
let g:barow = {
      \  'modules': [
      \    [ 'barowLSP#error', 'BarowError' ],
      \    [ 'barowLSP#warning', 'BarowWarning' ],
      \    [ 'barowLSP#info', 'BarowInfo' ],
      \    [ 'barowLSP#hint', 'BarowHint' ],
      \    [ 'barowLSP#coc_status', 'StatusLine' ]
      \  ]
      \}
