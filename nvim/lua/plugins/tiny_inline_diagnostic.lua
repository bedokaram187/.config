return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			use_icons_from_diagnostic = true,

			severity = {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.INFO,
				vim.diagnostic.severity.HINT,
			},
		})
		-- Only if needed in your configuration, if you already have native LSP diagnostics
		vim.diagnostic.config({ virtual_text = { current_line = true } })

		-- vim.api.nvim_create_autocmd("LspAttach", {
		-- 	callback = function()
		-- 		vim.diagnostic.config({ virtual_text = false })
		-- 	end,
		-- })
	end,
}
