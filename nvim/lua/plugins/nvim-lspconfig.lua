-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
}
