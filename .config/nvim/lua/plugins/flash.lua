return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		-- デフォルト設定（必要に応じて後で調整可能）
		labels = "asdfghjklqwertyuiopzxcvbnm",
		search = {
			multi_window = true,
		},
		modes = {
			char = {
				jump_labels = true,
			},
		},
	},
	keys = {
		{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
		{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
		{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
		{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
	},
}
