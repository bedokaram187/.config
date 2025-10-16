local opt = vim.opt
local g = vim.g

-- Disable netrw (we use neo-tree)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Disable unused providers for faster startup
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Editor appearance
opt.number = true
opt.relativenumber = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
opt.termguicolors = true -- set termguicolors to enable highlight groups
vim.wo.signcolumn = "yes" -- Keep signcolumn on by default
vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true -- convert tabs to spaces
vim.o.autoindent = true --copy indent from current line when starting new one (default: true)
vim.o.breakindent = true --enable break indent
vim.o.smartindent = true -- make indenting smarter again

-- Text wrapping
vim.o.wrap = false --Display lines as one long line (default: true)
vim.o.linebreak = false --companion to wrap, don't split words (default: false )
vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience

-- Search behavior
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true -- Incremental search
opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window splitting
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
opt.splitkeep = "screen" -- Keep text on screen when splitting

-- File handling
vim.o.swapfile = false -- creates a swapfile
vim.o.backup = false -- creates a backup file
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.o.fileencoding = "utf-8" -- the encoding written to a file

-- Scrolling and cursor
vim.o.scrolloff = 10 -- minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
opt.guicursor = "a:block-Cursor,i:block-iCursor,v:block-vCursor,c-ci-cr:block-cCursor,r:block-rCursor"

-- Timing
vim.o.updatetime = 250 -- Decrease update time
opt.timeoutlen = 300 -- Time to wait for mapped sequence

-- Mouse and clipboard
opt.mouse = "a" --enable mouse
opt.mousemoveevent = true -- Enable mouse move events
vim.o.clipboard = "unnamedplus" --sync clipboard between OS and neovim

-- Completion behavior
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c") -- Don't show completion messages
opt.shortmess:append("I") -- Don't show intro message

-- Performance improvements
opt.lazyredraw = false -- Don't redraw during macros (disabled for noice.nvim)
opt.ttyfast = true -- Fast terminal connection
opt.redrawtime = 10000 -- Allow more time for syntax highlighting

-- Disable some built-in plugins for faster startup
-- local disabled_built_ins = {
-- 	"gzip",
-- 	"tarPlugin",
-- 	"tohtml",
-- 	"tutor",
-- 	"zipPlugin",
-- 	"netrwPlugin",
-- 	"matchit",
-- 	"matchparen",
-- 	"2html_plugin",
-- 	"getscript",
-- 	"getscriptPlugin",
-- 	"vimball",
-- 	"vimballPlugin",
-- 	"rrhelper",
-- 	"spellfile_plugin",
-- 	"logiPat",
-- }

-- for _, plugin in pairs(disabled_built_ins) do
-- 	g["loaded_" .. plugin] = 1
-- end

---===============
---- OTHER =======
---===============

-- Enhanced word boundaries
opt.iskeyword:append("-") -- Treat dash as part of word

-- Concealment for better reading
opt.conceallevel = 2 -- Hide markup characters

-- Better error format
opt.errorformat:prepend("%f:%l:%c: %m")

-- what does this bum even do ?
vim.cmd("syntax on")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Carbonfox cursor colors (manually set) (this is such a good idea. i love it)
vim.cmd.highlight({ args = { "iCursor", "guibg=#a6e3a1" } }) -- green
vim.cmd.highlight({ args = { "rCursor", "guibg=#f9e2af" } }) -- yellow
vim.cmd.highlight({ args = { "vCursor", "guibg=#cba6f7" } }) -- purple
vim.cmd.highlight({ args = { "cCursor", "guibg=#f38ba8" } }) -- red
vim.cmd.highlight({ args = { "Cursor", "guibg=#89b4fa" } }) -- blue

-- set the correct patten for commentstring in a .sml file
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sml",
	callback = function()
		vim.bo.commentstring = "(* %s *)"
	end,
})
