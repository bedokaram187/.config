return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lspconfig") -- load your servers as usual
		vim.diagnostic.config({ virtual_text = false }) -- disable virtual text globally
	end,
}
