local opt = vim.opt

-- Session Management
opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Line Numbers
opt.relativenumber = true
opt.number = true

-- Tabs & Indentation
opt.tabstop = 4
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.autoindent = true

-- Line Wrapping
opt.wrap = false

-- Search Settings
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Cursor Line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.diagnostic.config {
  float = { border = "rounded" }, -- add border to diagnostic popups
}

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable the mouse while in nvim
opt.mouse = ""

-- Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds

-- Useful settings
opt.history = 700
opt.undolevels = 700

-- Disable backup and swap files
-- They trigger too many events for file system watchers
opt.backup = false
opt.writebackup = false


-- experimental
-- opt.scrolloff = 8
-- opt.colorcolumn = "80"
-- vim.o.autoread = true0"
