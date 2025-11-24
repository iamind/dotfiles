return {
	require("plugins.lualine"),  -- status line
	require("plugins.lspconfig"), -- LSP
	require("plugins.lspkind"),
	require("plugins.nvim-cmp"),
	require("plugins.treesitter"),

	{ -- colorscheme
		'cocopon/iceberg.vim',
	},

	{ -- cmp
		'hrsh7th/cmp-nvim-lsp',
	},

	{ -- cmp
		'hrsh7th/cmp-buffer',
	},

	{ --
		'L3MON4D3/LuaSnip',
	},

	{ -- Filler
		'nvim-tree/nvim-tree.lua',
	},

	{ -- icon
		'nvim-tree/nvim-web-devicons',
	},

}
