return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 60,
			open_mapping = [[<C-\>]], -- Change to your preferred keybinding
			direction = "float", -- "float", "horizontal", or "vertical"
			hide_numbers = true,
			shade_filetypes = {},
			start_in_insert = true,
			insert_mappings = true,
			presist_size = true,
			float_opts = {
				border = "curved", -- "single", "double", "shadow", etc.
				winblend = 3, -- Transparency level
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
	end,
}
