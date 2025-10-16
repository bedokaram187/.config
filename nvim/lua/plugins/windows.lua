return {
	"anuvyklack/windows.nvim",
	dependencies = {
		"anuvyklack/middleclass", -- required
		"anuvyklack/animation.nvim", -- optional, for smooth resize animation
	},
	config = function()
		require("windows").setup({
			-- Optional animation settings
			animation = {
				enable = true,
				duration = 150,
				fps = 60,
				easing = "in_out_sine",
			},
			-- When true, will ignore floating windows
			ignore = {
				buftype = { "quickfix", "nofile", "help" },
				filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
			},
			autowidth = {
				enable = false,
			},
		})

		-- -- Optional: map a key to toggle animation or equalize
		-- vim.keymap.set("n", "<leader>wm", require("windows").maximize, { desc = "Maximize Window" })
		-- vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize Windows" })
	end,
}
