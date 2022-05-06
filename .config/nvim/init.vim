" every vim config has this
set nocompatible

" enable vim syntax highlight
syntax on

" line numbers
set number 

" highlight line number
set cursorline 

" built in vim plugs
filetype plugin on

set laststatus=3 "soon it will be available

" 24 bit colors
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Function to prevent FZF commands from opening in functional buffers
"
" See: https://github.com/junegunn/fzf/issues/453
" TODO: Remove once this workaround is no longer necessary.
function! FZFOpen(cmd)
    " Define the functional buffer types that we want to not clobber
    let functional_buf_types = ['quickfix', 'help', 'nofile', 'terminal']

    " If more than 1 window, and buffer type is not one of the functional types
    if winnr('$') > 1 && (index(functional_buf_types, &bt) >= 0)
        " Find all 'normal' (not functional) buffer windows
        let norm_wins = filter(range(1, winnr('$')),
                    \ 'index(functional_buf_types, getbufvar(winbufnr(v:val), "&bt")) == -1')

        " Grab the first one that we can use
        let norm_win = !empty(norm_wins) ? norm_wins[0] : 0

        " Move to that window
        exe norm_win . 'winc w'
    endif

    " Execute the passed command
    exe a:cmd
endfunction

" Map CTRL+P to open FZF
nmap <C-P> :call FZFOpen(':Files')<CR>

" remove big INSERT msg
set noshowmode

" Who wants an 8 character tab? Not me!
set shiftwidth=2
set softtabstop=2

" Spaces are better than a tab character
set expandtab
set smarttab

" better with long lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" scroll multyple lines
nnoremap <C-e> 10<C-e>
nnoremap <C-y> 10<C-y>

" buffers 
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

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

"Basic rename function just in case
" For local replace
nnoremap ggr gd[{V%::s/<C-R>///gc<left><left><left>
" For global replace
nnoremap ggR gD:%s/<C-R>///gc<left><left><left>
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

" reselect after ident
:vnoremap < <gv
:vnoremap > >gv

" ident lines that start with #
autocmd FileType cpp set cinkeys-=0#

" restore cursor on exit
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
Plug 'aaronrancsik/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'aaronrancsik/vim-code-dark'
Plug 'feline-nvim/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'sunaku/tmux-navigate'
Plug 'preservim/nerdcommenter'
Plug 'psliwka/vim-smoothie'
Plug 'lambdalisue/suda.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'folke/which-key.nvim'
Plug 'lewis6991/gitsigns.nvim'
call plug#end()

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

 local my_theme = {
        fg           = '#D0D0D0',
        bg           = '#1F1F23',
        black        = '#1B1B1B',
        skyblue      = '#50B0F0',
        cyan         = '#009090',
        green        = '#60A040',
        oceanblue    = '#000000',
        magenta      = '#C26BDB',
        orange       = '#FF9000',
        red          = '#D10000',
        violet       = '#9E93E8',
        white        = '#FFFFFF',
        yellow       = '#E1E120'
    }

require('feline').setup()
require('feline').use_theme(my_theme)

require'colorizer'.setup()

require("which-key").setup {}

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '▐', numhl='GiSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '▐', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '▁', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},

    topdelete    = {hl = 'GitSignsDelete', text = '▔', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
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
hi CocErrorHighlight gui=undercurl term=undercurl guisp=#F44747
hi CocWarningHighlight gui=undercurl term=undercurl guisp=#CCA700


nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>

function! s:EditAlternate()
    let l:alter = CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand("%:p")})
    " remove file:/// from response
    let l:alter = substitute(l:alter, "file://", "", "")
    execute 'edit ' . l:alter
endfunction
autocmd FileType cpp nmap <M-o> :call <SID>EditAlternate()<CR>

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
