-- lazy.nvim
return {
	"sontungexpt/better-diagnostic-virtual-text",
	-- 	"LspAttach",
	config = function(_)
		require("better-diagnostic-virtual-text").setup(opts)
	end,
}

-- or better ways configure in on_attach of lsp client
-- if use this way don't need to call setup function
-- return {
-- 	"sontungexpt/better-diagnostic-virtual-text",
-- 	lazy = true,
-- }
-- M.on_attach = function(client, bufnr)
--     -- nil can replace with the options of each buffer
-- 	require("better-diagnostic-virtual-text.api").setup_buf(bufnr, {})
--
--     --- ... other config for lsp client
-- end
