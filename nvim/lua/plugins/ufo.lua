-- return {
-- 	"kevinhwang91/nvim-ufo",
-- 	event = "BufReadPost",
-- 	dependencies = "kevinhwang91/promise-async",
-- 	config = function()
-- 		vim.o.foldenable = true
-- 		vim.o.foldcolumn = "auto:9" -- Show fold column
-- 		vim.o.foldlevel = 99 -- Open all folds by default
-- 		vim.o.foldlevelstart = 99
-- 		vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep:│,foldclose:"
--
-- 		require("ufo").setup({
-- 			provider_selector = function(_, _, _)
-- 				return { "lsp", "indent" }
-- 			end,
-- 		})
--
-- 		-- Keymaps
-- 		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
-- 		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
-- 		vim.keymap.set("n", "zp", function()
-- 			require("ufo").peekFoldedLinesUnderCursor()
-- 		end)
-- 	end,
-- }
-- 代码折叠配置

vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" …  %d lines"):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	config = function()
		local ufo = require("ufo")
		vim.keymap.set("n", "zR", ufo.openAllFolds)
		vim.keymap.set("n", "zM", ufo.closeAllFolds)
		vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
		vim.keymap.set("n", "zm", ufo.closeFoldsWith)

		-- Option 2: nvim lsp as LSP client
		-- Tell the server the capability of foldingRange,
		-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		ufo.setup({
			open_fold_hl_timeout = 100,
			fold_virt_text_handler = handler,
		})
	end,
}
-- 代码折叠配置
--
-- return {
-- 	"kevinhwang91/nvim-ufo",
-- 	dependencies = {
-- 		"kevinhwang91/promise-async",
-- 		"neovim/nvim-lspconfig",
-- 	},
-- 	config = function()
-- 		vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- 		vim.opt.foldcolumn = "0" -- '0' is not bad
-- 		vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- 		vim.opt.foldlevelstart = 99
-- 		vim.opt.foldenable = true
--
-- 		local ufo = require("ufo")
-- 		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- 		vim.keymap.set("n", "zR", ufo.openAllFolds)
-- 		vim.keymap.set("n", "zM", ufo.closeAllFolds)
-- 		vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
-- 		vim.keymap.set("n", "zm", ufo.closeFoldsWith)
--
-- 		-- Option 2: nvim lsp as LSP client
-- 		-- Tell the server the capability of foldingRange,
-- 		-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
-- 		local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 		capabilities.textDocument.foldingRange = {
-- 			dynamicRegistration = false,
-- 			lineFoldingOnly = true,
-- 		}
-- 		local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
-- 		for _, server in ipairs(language_servers) do
-- 			require("lspconfig")[server].setup({
-- 				capabilities = capabilities,
-- 				-- you can add other fields for setting up lsp server in this table
-- 			})
-- 		end
--
-- 		require("ufo").setup({
-- 			open_fold_hl_timeout = 100,
-- 		})
-- 	end,
-- }
