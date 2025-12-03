-- ==========================================================================
--  plugins/treesitter.lua - シンタックスハイライト・解析
-- ==========================================================================

return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local status, ts = pcall(require, "nvim-treesitter.configs")
		if (not status) then return end
		ts.setup {
			highlight = {
				enable = true,
				disable = {},
			},
			indent = {
				enable = true,
				disable = {},
			},
			ensure_installed = {
				"markdown",
				"markdown_inline",
				"tsx",
				"typescript",
				"toml",
				"fish",
				"php",
				"json",
				"yaml",
				"swift",
				"css",
				"html",
				"lua",
				"python",
				"terraform",
				"dockerfile",
			},
		}
		local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
		parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
	end
}
