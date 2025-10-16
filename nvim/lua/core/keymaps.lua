-- for conciseness
local opts = { noremap = true, silent = true }

----------------
---- basics ----
----------------
-- set space as leader key
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- disable the spacebar key's default behavior in normal and visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- close everything
vim.keymap.set("n", "<leader>n", ":qa<CR>", opts) -- close nvim

-- Quick save with <leader>s (<leader> is ' ')
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true }) -- Save file

-- Close buffer (file) quickly with <leader>q
vim.keymap.set("n", "<leader>q", ":bd<CR>", { noremap = true, silent = true }) -- Close buffer

-- code folding
vim.keymap.set("n", "-", "<cmd>foldclose<CR>", { desc = "close code folding" })
vim.keymap.set("n", "+", "<cmd>foldopen<CR>", { desc = "open code folding" })

-- toogle line wrap
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

--------------
---- Tabs ----
--------------
-- you can close the current tab with <leader>q
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", opts) -- go to next tab
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", opts) -- go to previous tab

-- find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

----------------
---- splits ----
----------------
-- better keymaps to make splits
vim.keymap.set("n", "<leader>|", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>c", ":close<CR>", opts) -- close current split window

-- navigate between splits
vim.keymap.set("n", "<M-n>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<M-e>", ":wincmd l<CR>", opts)

-- window navigation using Ctrl + n/e (like moving between splits)
vim.keymap.set("n", "<C-n>", "<C-w>h", { noremap = true }) -- Move to left window
vim.keymap.set("n", "<C-e>", "<C-w>l", { noremap = true }) -- Move to right window

--------------------
---- copy pasta ----
--------------------
-- keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

--delete signle character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

----------------
---- useful ----
----------------
-- remap ; to : in normal mode, so that you don't have to press shift and hurt your pinkie
vim.keymap.set("n", ";", ":", { noremap = true })

-- Disables the `Q` command (which enters Ex mode), as it's rarely useful.
vim.keymap.set("n", "Q", "<nop>")

-- Scrolls half a page down/up and keeps the cursor centered on the screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-------------------------
---- plugin specific ----
-------------------------

--typst-prview.nvim keymaps
vim.keymap.set("n", "<leader>pp", "<cmd>TypstPreviewUpdate<CR>", { desc = "Typst: Preview first command" })
vim.keymap.set("n", "<leader>ps", "<cmd>TypstPreview document<CR>", { desc = "Typst: start Preview" })
vim.keymap.set("n", "<leader>pe", "<cmd>TypstPreviewStop<CR>", { desc = "Typst: End Preview" })
