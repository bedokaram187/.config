-- lua/plugins/lint.lua
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			lua = { "luacheck" },
			python = { "flake8" },
			sh = { "shellcheck" },
			c = { "cpplint" },
			cpp = { "cpplint" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
