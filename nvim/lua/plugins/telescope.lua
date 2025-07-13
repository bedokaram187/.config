return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim", -- faster sorting
		build = "make",
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				layout_config = {
					horizontal = { preview_width = 0.55 },
					vertical = { width = 0.9 },
				},
				file_ignore_patterns = { "node_modules", ".git/", "venv" },
				sorting_strategy = "ascending",
				prompt_prefix = "🔍 ",
			},
			pickers = {
				find_files = {
					hidden = true, -- show dotfiles
				},
			},
		})

		telescope.load_extension("fzf")

		-- Keymaps (you can move this to your keymaps file if you prefer)
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		keymap("n", "<leader>ff", builtin.find_files, opts)
		keymap("n", "<leader>fg", builtin.live_grep, opts)
		keymap("n", "<leader>fb", builtin.buffers, opts)
		keymap("n", "<leader>fh", builtin.help_tags, opts)
		keymap("n", "<leader>fs", builtin.lsp_document_symbols, opts)
		keymap("n", "<leader>fr", builtin.oldfiles, opts)
	end,
}
