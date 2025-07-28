-- to activate the configurations in the file ~/.config/nvim/lua/core/options.lua
require("core.options")
-- to activate the configurations in the file ~/.config/nvim/lua/core/keymaps.lua
require("core.keymaps")
-- to activate the configurations in the file ~/.config/nvim/lua/lspconf/lspconfig.lua
require("lsps.lspconf")

-- LAZY
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require("lazy").setup({

	-- the looks
	require("plugins.colortheme"),
	require("plugins.lualine"),
	require("plugins.alpha"),
	require("plugins.indent_blankline"),
	require("plugins.visual_whitespace"),
	require("plugins.blink"),
	require("plugins.noice"),
	require("plugins.misc"),
	-- require("plugins.diagnostic"), -- pretty good but old
	require("plugins.tiny_inline_diagnostic"), -- the new kid on the block
	require("plugins.mini_indentscope"),
	require("plugins.mini_cursorword"),
	-- require("plugins.neoscroll"),
	require("plugins.snacks_animate"),
	require("plugins.snacks_image"),
	require("plugins.snacks_scroll"),
	-- require("plugins.snacks_statuscolumn"),
	require("plugins.numb"),
	require("plugins.render_markdown"),
	-- require("plugins.statuscol"),
	-- require("plugins.lightbulp"),
	-- require("plugins.smear_cursor"),
	-- require("plugins.windows"),
	-- require("plugins.mini_hipatterns"),
	-- require("plugins.mini_animate"),
	-- require("plugins.cursor"),
	-- require 'plugins.reverb',

	-- file manager
	require("plugins.yazi"),
	require("plugins.telescope"),
	require("plugins.neotree"),
	require("plugins.tabby"),
	require("plugins.toggleterm"),

	-- lsp
	require("plugins.treesitter"),
	require("plugins.mason"),
	require("plugins.nvim-lspconfig"),
	require("plugins.conform"),
	require("plugins.typst-preview"),
	require("plugins.nvim_lint"),
	-- require("plugins.vim_tmux"),
	-- require("plugins.package_ui"),

	-- useful
	require("plugins.mini_move"),
	require("plugins.ufo"),
	require("plugins.persistance"),
	-- require("plugins.better_sml"),
	-- require("plugins.ultimate_autopair"),
	require("plugins.nvim_autopairs"),
	require("plugins.relative_toggle"),
	require("plugins.vim_coach"),
	require("plugins.nvim_surround"),
	require("plugins.marks"),
	-- require("plugins.lazydev"),
	-- require("plugins.trouble"),
	-- require("plugins.store"),
	-- require("plugins.comfy_line_numbers"),

	-- vimming
	-- require 'plugins.hardtime' -- use this to learn vim

	-- disabled
	-- require 'plugins.nvim-cmp' (i need to set this up )
	-- require 'plugins.mason-lspconfig'
})

-- NOTE Here is where you configure your lsp.
-- i think most of them has some kind of a dependancy that must be installed for them to work. so be awae of that
vim.lsp.enable("pyright") -- for python
vim.lsp.enable("clangd") -- for c/c++
-- vim.lsp.enable("tinymist") -- for typst
-- vim.lsp.enable("arduino_language_server") -- for arduino [it works after you do this command: arduino-cli board attach -p your board >> /dev/ttyS4 -b arduino:avr:uno ~/arduino_project/nano/nano.ino]
vim.lsp.enable("lua_ls") -- for lua
-- vim.lsp.enable("matlab_ls") -- (does not work)for matlab
vim.lsp.enable("bashls") -- for bash
-- vim.lsp.enable("marksman") -- for markdown
-- vim.lsp.enable("yamlls") -- for yaml
vim.lsp.enable("ltex") -- for plain text
vim.lsp.enable("millet") -- for sml
