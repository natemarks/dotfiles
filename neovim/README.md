# neovim config
I started with [nvim-starter-kit](https://github.com/bcampolo/nvim-starter-kit) becuase the file organization seemed pretty accessible and it got me of fthe ground wiht LSP autocompletion.

### prerequisites
install lua and luarocks first. They're required by the lazyvim package manager
```bash
sudo ls
bash scripts/install_lua_and_luarocks.sh
```

install nerdfonts
```bash
bash scripts/install_nerdfonts.sh
```

## Installation

'''bash
make reset_neovim_config
# in vim, run lazy sync, tsupdate and checkhealth. may have toi 
# open and close vim a few times
'''








## Goals
I used this approach to get started. It checks these boxes:
 - uses lazy nvim


 - uses treesitter for syntax highlighting where I DO NOT get it from LSP.
 I use tresitter to highlight languase where I DO NOT care about autocompletion:
 JSON, YAML, etc. If I want autocompletion, I get it from the LSP INSTEAD of treesitter

 - I use LSP where I care about autocompletion. Go, Python, etc,
I use the pyright LSP server and gopls
 - DOES NOT use null-ls which is deprecated

I decided to use make for formatting (black) because black.nvim requires pynvim in the project and I don't want extra junk
I MAY use pylint, mypy, for linting in neovim beucase it can be a bit arduous to find the error line in the cli and then go hunting for it in vim.  It might be worthwhile to see them in line in real time


I REALLY want debugging and pytest. I think this is nvim-dap-python which WILL require debugpy in my projects


https://github.com/nanotee/nvim-lua-guide

Good resource for setting up neovim:
https://github.com/tpope/vim-sensible

### future
experiment with fugitive, lazygit, difview


## key bindings and global config


```vim
" Sample .vimrc file by Martin Brochhaus
" Presented at PyCon APAC 2012

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ","


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" Quicksave command
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>


" Quick quit command
noremap <Leader>e :quit<CR>  " Quit current window
noremap <Leader>E :qa!<CR>   " Quit all windows


" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>


" map sort function to a key
"" vnoremap <Leader>s :sort<CR>


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/


" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
"" set t_Co=256
"" color wombat256mod


" Enable syntax highlighting
" You need to reload this file for the change to apply
"" filetype off
"" filetype plugin indent on
"" syntax on


" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=233


" easier formatting of paragraphs
vmap Q gq
nmap Q gqap


" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab


" Make search case insensitive
"" set hlsearch
"" set incsearch
"" set ignorecase
"" set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile
```

## plugins 

https://github.com/vimjoyer/nvim-video


    [video](https://www.youtube.com/watch?v=Co7gcSvq6jA)

### comment
hotkey to comment code

### colorizer
gruvbox for highlighting

### status bar  
nvim-lualine


### fuzzy search

https://www.youtube.com/watch?v=u_OORAL_xSM

telescope

### treesitter
TSInstall go
TSInstall gomod
TSInstall gosum
TSInstall gotmpl
TSInstall lua
TSInstall python
TSInstall json
TSInstall yaml
TSInstall diff
TSInstall bash
TSInstall jq
TSInstall make
TSInstall toml

### cmp

### snippets

### git
external lazygit


### diffview
diffview.nvim

### treeview
neotree.nvim




# Approaches
use whichkey to display keymaps
package manager: [lazy](https://github.com/folke/lazy.nvim)
I use gruvbox for the color scheme. [catpuccin](https://github.com/catppuccin/nvim) is also popular.
vim-fugitive for git integration


Start with the LSP  approach. It'll be required for completions, and it's the most complicated part
 - avoid approaches that use null-ls. it's deprecated and will be removed in the future.
 - I think I want to avoid nvchad. it's a PILE
 - know which LSP servers you'll use: I'm using pyright for pythong anf gopls for go.
 - I may want language servers for bash and GNU make later

do not use neodev.nvim. it's deprecated. use lazydev.nvim instead.

use treesitter for syntax highlighting. 
use telescope for fuzzy search
use lualine for status bar
use neotree for filesystem sidebar
use harpoon to bookmark files for opening

? how to do git diffs. maybe use diffview
? primeagen hot key to open the neovim config tree fs root (pf)
? what is the lazy equivalent to packersync
? I think there's a way to autocomplete/display kepymaps in neovim. I want to do that. I think it's in the lazyvim recommended video (whichkey?)
? should I try lazygit plugin?
## primeagen
https://www.youtube.com/watch?v=w7i4amO_zaE&t=953s
he uses lsp-zero too
I really want todig into his remaps and settings. relative line numbers , incremental search, etc.

## zazen
https://www.youtube.com/watch?v=VljhZ0e9zGE
I like the way he organizes global vs plugin-specific keymaps and options.
He also uses [lsp-zero](https://github.com/VonHeikemen/lsp-zero.nvim) for LSP configuration.  Specifically, he just pastes in the 'automatic setup...' code block:

https://github.com/VonHeikemen/lsp-zero.nvim/blob/v4.x/doc/md/guides/lazy-loading-with-lazy-nvim.md

# recommended setup video on lazyvim page
https://www.youtube.com/watch?v=N93cTbtLCIM

# nvchad
I don't liek nvchad, but this video has a bit of detail on lsp config
https://www.youtube.com/watch?v=4BnVeOUeZxc
avoid null-ls.

##
