-- plugins/lspkind.lua

return {
	"onsails/lspkind.nvim",
	event = "VeryLazy",
	config = function()
		require("lspkind").init({
			-- Enables text annotations (e.g., "Function", "Variable")
			mode = "symbol_text",
			-- Default symbol map, you can override any entry
			symbol_map = {
				Text = "",
				Method = "",
				Function = "",
				Constructor = "",
				Field = "",
				Variable = "",
				Class = "",
				Interface = "",
				Module = "",
				Property = "",
				Unit = "",
				Value = "",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "",
				Reference = "",
				Folder = "",
				EnumMember = "",
				Constant = "",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
			},
			-- You can also set `preset = 'codicons'` or 'default'
		})
	end,
}
