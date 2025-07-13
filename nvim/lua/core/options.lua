vim.opt.number = true

--set relative line numbers
vim.opt.relativenumber = true

--enable mouse
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- so when you're done with searching a word, you press escape and the highlighting will be gone
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- what does this bum even do ?
vim.cmd("syntax on")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- convert tabs to spaces

vim.o.clipboard = "unnamedplus" --sync clipboard between OS and neovim

vim.o.wrap = false --Display lines as one long line (default: true)
vim.o.linebreak = false --companion to wrap, don't split words (default: false )

vim.o.autoindent = true --copy indent from current line when starting new one (default: true)

vim.o.breakindent = true --enable break indent

vim.wo.signcolumn = "yes" -- Keep signcolumn on by default

vim.o.updatetime = 250 -- Decrease update time

vim.o.backup = false -- creates a backup file

vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience

vim.opt.termguicolors = true -- set termguicolors to enable highlight groups

vim.o.scrolloff = 10 -- minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`

vim.o.cursorline = true -- highlight the current line

vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window

vim.o.swapfile = false -- creates a swapfile

vim.o.smartindent = true -- make indenting smarter again

vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore

vim.o.fileencoding = "utf-8" -- the encoding written to a file

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--to make a highlight for current column and row
vim.o.cursorcolumn = true
vim.o.cursorline = true

-- Carbonfox cursor colors (manually set)
vim.cmd.highlight({ args = { "iCursor", "guibg=#a6e3a1" } }) -- green
vim.cmd.highlight({ args = { "rCursor", "guibg=#f9e2af" } }) -- yellow
vim.cmd.highlight({ args = { "vCursor", "guibg=#cba6f7" } }) -- purple
vim.cmd.highlight({ args = { "cCursor", "guibg=#f38ba8" } }) -- red
vim.cmd.highlight({ args = { "Cursor", "guibg=#89b4fa" } }) -- blue

vim.opt.guicursor = "a:block-Cursor,i:block-iCursor,v:block-vCursor,c-ci-cr:block-cCursor,r:block-rCursor"

-- NEOVIDE
-- if vim.g.neovide then
-- 	vim.keymap.set({ "n", "x" }, "<C-S-C>", '"+y', { desc = "Copy to system clipboard" })
-- 	vim.keymap.set({ "n", "x" }, "<C-S-V>", '"+p', { desc = "Paste from system clipboard" })
-- end
-- System clipboard mappings (converted from Vimscript)
-- vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
-- vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from system clipboard" })
-- vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard in insert mode", expr = true })
-- vim.keymap.set("c", "<C-v>", "<C-r>+", { desc = "Paste from clipboard in command-line", expr = true })
-- vim.keymap.set("i", "<C-r>", "<C-v>", { desc = "Insert raw character" })
-- if vim.g.neovide then
-- 	vim.api.nvim_set_keymap("v", "<sc-c>", '"+y', { noremap = true })
-- 	vim.api.nvim_set_keymap("n", "<sc-v>", 'l"+P', { noremap = true })
-- 	vim.api.nvim_set_keymap("v", "<sc-v>", '"+P', { noremap = true })
-- 	vim.api.nvim_set_keymap("c", "<sc-v>", '<C-o>l<C-o>"+<C-o>P<C-o>l', { noremap = true })
-- 	vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>l"+Pli', { noremap = true })
-- 	vim.api.nvim_set_keymap("t", "<sc-v>", '<C-\\><C-n>"+Pi', { noremap = true })
-- end
if vim.g.neovide then
	local opts = { noremap = true, silent = true, desc = "Neovide clipboard" }

	vim.keymap.set("v", "<C-S-c>", '"+y', opts) -- Copy in visual mode
	vim.keymap.set("n", "<C-S-v>", '"+P', opts) -- Paste in normal mode
	vim.keymap.set("v", "<C-S-v>", '"+P', opts) -- Paste in visual mode
	vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true, expr = true }) -- Paste in insert
	vim.keymap.set("c", "<C-S-v>", "<C-r>+", { noremap = true, expr = true }) -- Paste in command
	vim.keymap.set("t", "<C-S-v>", '<C-\\><C-n>"+Pi', opts) -- Paste in terminal mode
end
