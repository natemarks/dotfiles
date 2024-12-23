-- Set leader key to space
vim.g.mapleader = ","

local keymap = vim.keymap

-- Bind nohl
-- Removes highlight of your last search
-- ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
keymap.set('n', '<C-n>', ':nohl<CR>', {noremap = true})
keymap.set('v', '<C-n>', ':nohl<CR>', {noremap = true})
keymap.set('i', '<C-n>', '<C-o>:nohl<CR>', {noremap = true})

-- Quicksave command
keymap.set('n', '<C-Z>', ':update<CR>', {noremap = true})
keymap.set('v', '<C-Z>', '<C-C>:update<CR>', {noremap = true})
keymap.set('i', '<C-Z>', '<C-O>:update<CR>', {noremap = true})

-- Quick quit command
keymap.set('n', '<Leader>e', ':quit<CR>', {noremap = true})  -- Quit current window
keymap.set('n', '<Leader>E', ':qa!<CR>', {noremap = true})   -- Quit all windows

-- Bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
-- Every unnecessary keystroke that can be saved is good for your health :)
keymap.set('n', '<C-j>', '<C-w>j', {noremap = true})
keymap.set('n', '<C-k>', '<C-w>k', {noremap = true})
keymap.set('n', '<C-l>', '<C-w>l', {noremap = true})
keymap.set('n', '<C-h>', '<C-w>h', {noremap = true})

-- Easier moving between tabs
keymap.set('n', '<Leader>n', ':tabprevious<CR>', {noremap = true})
keymap.set('n', '<Leader>m', ':tabnext<CR>', {noremap = true})

-- Easier formatting of paragraphs
keymap.set('v', 'Q', 'gq', {noremap = true})
keymap.set('n', 'Q', 'gqap', {noremap = true})


-- Split window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- close split window
keymap.set("n", "<leader>sj", "<C-w>-") -- make split window height shorter
keymap.set("n", "<leader>sk", "<C-w>+") -- make split windows height taller
keymap.set("n", "<leader>sl", "<C-w>>5") -- make split windows width bigger 
keymap.set("n", "<leader>sh", "<C-w><5") -- make split windows width smaller

-- Tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle maximize tab

-- Nvim-tree
keymap.set("n", "<leader>oe", ":NvimTreeToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>or", ":NvimTreeFocus<CR>") -- toggle focus to file explorer
keymap.set("n", "<leader>of", ":NvimTreeFindFile<CR>") -- find file in file explorer

-- Telescope
keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})
keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, {})
keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, {})
keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, {})
keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({default_text=":method:"}) end)

-- Git-blame
keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>") -- toggle git blame

-- Harpoon
local wk = require("which-key")
wk.add({
    { "<leader>h", group = "harpoon" },
    { "<leader>ha", require("harpoon.mark").add_file, desc = "Add File", mode = "n" },
    { "<leader>hh", require("harpoon.ui").toggle_quick_menu, desc = "Show UI", mode = "n" },
    { "<leader>h1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon:1", mode = "n" },
    { "<leader>h2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon:2", mode = "n" },
    { "<leader>h3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon:3", mode = "n" },
    { "<leader>h4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon:4", mode = "n" },
    { "<leader>h5", function() require("harpoon.ui").nav_file(5) end, desc = "Harpoon:5", mode = "n" },
    { "<leader>h6", function() require("harpoon.ui").nav_file(6) end, desc = "Harpoon:6", mode = "n" },
    { "<leader>h7", function() require("harpoon.ui").nav_file(7) end, desc = "Harpoon:7", mode = "n" },
    { "<leader>h8", function() require("harpoon.ui").nav_file(8) end, desc = "Harpoon:8", mode = "n" },
    { "<leader>h9", function() require("harpoon.ui").nav_file(9) end, desc = "Harpoon:9", mode = "n" },
})


-- Vim REST Console
keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- LSP
keymap.set('n', '<leader>gg', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap.set('n', '<leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>')
keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('v', '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
keymap.set('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<CR>')
keymap.set('n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
keymap.set('n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>')
keymap.set('n', '<leader>tr', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
keymap.set("n", '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", '<leader>dd', function() require('dap').disconnect(); require('dapui').close(); end)
keymap.set("n", '<leader>dt', function() require('dap').terminate(); require('dapui').close(); end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", '<leader>di', function() require "dap.ui.widgets".hover() end)
keymap.set("n", '<leader>d?', function() local widgets = require "dap.ui.widgets"; widgets.centered_float(widgets.scopes) end)
keymap.set("n", '<leader>df', '<cmd>Telescope dap frames<cr>')
keymap.set("n", '<leader>dh', '<cmd>Telescope dap commands<cr>')
keymap.set("n", '<leader>de', function() require('telescope.builtin').diagnostics({default_text=":E:"}) end)

-- Gitsigns
keymap.set("n", "<leader>vp", ":Gitsigns preview_hunk<CR>")

-- Git
keymap.set("n", "<leader>vd", ":Git difftool -y<CR>")

-- LazyGit
keymap.set("n", "<leader>vv", ":LazyGit<CR>")
