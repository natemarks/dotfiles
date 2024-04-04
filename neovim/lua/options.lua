
-- install xclip for xorg (or wl-copy and wl-paste for way)
-- test yank a line with yy and paster it outside of neovim
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- Rebind <Leader> key
-- I like to have it here because it is easier to reach than the default and
-- it is next to ``m`` and ``n`` which I use for navigating between tabs.
vim.g.mapleader = ','

-- Bind nohl
-- Removes highlight of your last search
-- ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
vim.api.nvim_set_keymap('n', '<C-n>', ':nohl<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-n>', ':nohl<CR>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-n>', '<C-o>:nohl<CR>', {noremap = true})

-- Quicksave command
vim.api.nvim_set_keymap('n', '<C-Z>', ':update<CR>', {noremap = true})
vim.api.nvim_set_keymap('v', '<C-Z>', '<C-C>:update<CR>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-Z>', '<C-O>:update<CR>', {noremap = true})

-- Quick quit command
vim.api.nvim_set_keymap('n', '<Leader>e', ':quit<CR>', {noremap = true})  -- Quit current window
vim.api.nvim_set_keymap('n', '<Leader>E', ':qa!<CR>', {noremap = true})   -- Quit all windows

-- Bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
-- Every unnecessary keystroke that can be saved is good for your health :)
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})

-- Easier moving between tabs
vim.api.nvim_set_keymap('n', '<Leader>n', ':tabprevious<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>m', ':tabnext<CR>', {noremap = true})

-- Map sort function to a key. I can't get this to work
-- vim.api.nvim_set_keymap('v', '<Leader>s', ':sort<CR>', {noremap = true})

-- Easier moving of code blocks
-- Try to go into visual mode (v), then select several lines of code here and
-- then press ``>`` several times.
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true})  -- better indentation
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true})  -- better indentation

-- Show whitespace
-- MUST be inserted BEFORE the colorscheme command
--vim.api.nvim_exec([[
--    augroup ShowWhitespace
--        autocmd!
--        autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
--        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
--    augroup end
--]], false)

-- Color scheme
-- Uncomment and modify the color scheme as needed
-- vim.cmd[[set t_Co=256]]
-- vim.cmd[[colorscheme wombat256mod]]

-- Enable syntax highlighting
-- You need to reload this file for the change to apply
-- vim.cmd[[filetype off]]
-- vim.cmd[[filetype plugin indent on]]
-- vim.cmd[[syntax on]]

-- Showing line numbers and length
vim.opt.number = true  -- show line numbers
vim.opt.tw = 79        -- width of document (used by gd)
vim.opt.wrap = false   -- don't automatically wrap on load
vim.opt.formatoptions:remove('t') -- don't automatically wrap text when typing
vim.opt.colorcolumn = '80'
vim.cmd[[highlight ColorColumn ctermbg=233]]

-- Easier formatting of paragraphs
vim.api.nvim_set_keymap('v', 'Q', 'gq', {noremap = true})
vim.api.nvim_set_keymap('n', 'Q', 'gqap', {noremap = true})

-- Useful settings
vim.opt.history = 700
vim.opt.undolevels = 700

-- Real programmers don't use TABs but spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Make search case insensitive
-- Uncomment the following lines if you want case-insensitive search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable backup and swap files
-- They trigger too many events for file system watchers
vim.opt.backup = false
vim.opt.writebackup = false
-- noswapfile doesn't exist
-- vim.opt.noswapfile = true


-- telescope settings
vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', {noremap = true})

-- neo-tree.nvim settings
-- open file system
vim.api.nvim_set_keymap('n', '<Leader>t', ':Neotree filesystem reveal left<CR>', {noremap = true})
