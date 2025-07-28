return {
	"mcauley-penney/visual-whitespace.nvim",
	keys = { "v", "V", "<C-v>" }, -- Lazy load on visual mode keys
	opts = {
		highlight = { link = "Visual" },
		space_char = "·",
		tab_char = "→",
		nl_char = "↲",
		cr_char = "←",
		enabled = true,
		excluded = {
			filetypes = {},
			buftypes = {},
		},
	},
}
