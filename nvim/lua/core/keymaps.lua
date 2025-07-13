-- for conciseness
local opts = { noremap = true, silent = true }

-- set space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- disable the spacebar key's default behavior in normal and visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- close everything
vim.keymap.set("n", "<leader>n", ":qa<CR>", opts) -- open new tab

---- Tabs
-- you can close the current tab with <leader>q
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", opts) -- go to next tab
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", opts) -- go to previous tab
--for i = 1, 9 do
--  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', opts) -- Jump to tab 1–9
--end

--delete signle character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- resize with arrows
-- vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
-- vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
-- vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
-- vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- navigate between splits
-- vim.keymap.set("n", "<C-n>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-e>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<M-n>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<M-e>", ":wincmd l<CR>", opts)

-- Window management
-- better keymaps to make splits
vim.keymap.set("n", "<leader>|", "<C-w>v", opts) -- split window vertically
-- vim.keymap.set("n", "<leader>-", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>c", ":close<CR>", opts) -- close current split window

-- toogle line wrap
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- In visual mode, moves the selected text block down by one line and reselects it.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Scrolls half a page down/up and keeps the cursor centered on the screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Disables the `Q` command (which enters Ex mode), as it's rarely useful.
vim.keymap.set("n", "Q", "<nop>")

-- Makes the current file executable.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- remap ; to : in normal mode, so that you don't have to press shift and hurt your pinkie
vim.keymap.set("n", ";", ":", { noremap = true })

-- Better window navigation using Ctrl + h/j/k/l (like moving between splits)
-- vim.keymap.set("n", "<C-e>", "<C-w>k", { noremap = true }) -- Move to above window
-- vim.keymap.set("n", "<C-n>", "<C-w>j", { noremap = true }) -- Move to below window
vim.keymap.set("n", "<C-n>", "<C-w>h", { noremap = true }) -- Move to left window
vim.keymap.set("n", "<C-e>", "<C-w>l", { noremap = true }) -- Move to right window

-- Quick save with <leader>s (<leader> is ' ')
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true }) -- Save file

-- Close buffer (file) quickly with <leader>q
vim.keymap.set("n", "<leader>q", ":bd<CR>", { noremap = true, silent = true }) -- Close buffer

--typst-prview.nvim keymaps
vim.keymap.set("n", "<leader>pp", "<cmd>TypstPreviewUpdate<CR>", { desc = "Typst: Preview first command" })
vim.keymap.set("n", "<leader>ps", "<cmd>TypstPreview document<CR>", { desc = "Typst: start Preview" })
vim.keymap.set("n", "<leader>pe", "<cmd>TypstPreviewStop<CR>", { desc = "Typst: End Preview" })

-- run current python file
-- vim.keymap.set('n', '<leader>py', ':!python3 %<CR>', {
--     desc = 'Run python file',
-- })
-- vim.keymap.set('n', '<leader>py', ':terminal python3 %<CR>', {
--     desc = 'Run python file in terminal',
-- })
vim.keymap.set("n", "<leader>rp", function()
	local file = vim.fn.expand("%")
	require("toggleterm").exec("python3 " .. file, 1)
end, { desc = "Run python file in ToggleTerm" })

-- autocomplete using contrl + p inside insert mode
vim.keymap.set("i", "<C-p>", "<C-x><C-l>", { noremap = true, desc = "Trigger line completion" })

-- code folding
vim.keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "close code folding" })
vim.keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "open code folding" })
