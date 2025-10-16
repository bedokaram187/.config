-- configuration of the carbonfox color theme <3
return {
	"EdenEast/nightfox.nvim",
	priority = 1000, -- Ensures it loads before other plugins
	config = function()
		require("nightfox").setup({
			options = {
				transparent = true, -- Enable transparency if you want
				styles = {
					comments = "italic",
					keywords = "bold",
					functions = "italic,bold",
				},
			},
		})
		vim.cmd.colorscheme("carbonfox")
	end,
}
