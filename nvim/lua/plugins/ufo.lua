return {
	"kevinhwang91/nvim-ufo",
	event = "BufReadPost",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.o.foldenable = true
		vim.o.foldcolumn = "auto:9" -- Show fold column
		vim.o.foldlevel = 99 -- Open all folds by default
		vim.o.foldlevelstart = 99
		vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep:│,foldclose:"

		require("ufo").setup({
			provider_selector = function(_, _, _)
				return { "lsp", "indent" }
			end,
		})

		-- Keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zp", function()
			require("ufo").peekFoldedLinesUnderCursor()
		end)
	end,
}
