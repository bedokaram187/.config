---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{
			"<leader>-",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			"<leader>cw",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
	},
	opts = {
		open_for_directories = false,
		open_multiple_tabs = false,
		highlight_groups = {
			hovered_buffer = nil,
			hovered_buffer_in_same_directory = nil,
		},
		floating_window_scaling_factor = 0.9,
		yazi_floating_window_winblend = 0,
		log_level = vim.log.levels.OFF,
		open_file_function = function(chosen_file, config, state)
			vim.cmd("edit " .. vim.fn.fnameescape(chosen_file))
		end,
		keymaps = {
			open_file_in_vertical_split = "<C-v>",
			open_file_in_tab = "<C-t>",
			copy_relative_path_to_selected_files = "<C-y>",
		},
		set_keymappings_function = function(yazi_buffer_id, config, context)
			-- you can override keymaps here
		end,
		yazi_floating_window_border = "rounded",
		clipboard_register = "*",
		hooks = {
			yazi_opened = function(preselected_path, yazi_buffer_id, config)
				-- actions after yazi is opened
			end,
			yazi_closed_successfully = function(chosen_file, config, state)
				-- actions after yazi is closed
			end,
			yazi_opened_multiple_files = function(chosen_files, config, state)
				-- actions when multiple files are opened
			end,
		},
		highlight_hovered_buffers_in_same_directory = true,
		integrations = {
			grep_in_directory = function(directory)
				-- defaults to Telescope if available
			end,
			grep_in_selected_files = function(selected_files) end,
			replace_in_directory = function(directory) end,
			replace_in_selected_files = function(selected_files) end,
			resolve_relative_path_application = "",
		},
		future_features = {
			nvim_0_10_termopen_fallback = true,
			process_events_live = true,
		},
	},
	init = function()
		-- Disable netrw plugin
		vim.g.loaded_netrwPlugin = 1
	end,
}
