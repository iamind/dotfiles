-- ==========================================================================
--  plugins/colorscheme.lua - カラースキーム
-- ==========================================================================

return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,   -- 起動時に読み込む
	priority = 1000, -- 最優先で読み込む
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				cmp = true,
				treesitter = true,
				telescope = { enabled = true },
				flash = true,
				noice = true,
				native_lsp = {
					enabled = true,
				},
			},
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
