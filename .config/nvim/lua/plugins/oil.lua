return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = { "icon" },
			delete_to_trash = true,
			view_options = {
				show_hidden = false,
			},
			float = {
				padding = 2,
				max_width = 80,
				max_height = 30,
				border = "rounded",
				win_options = { winblend = 0 },
			},
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<C-s>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["<C-c>"] = "actions.close",
				["<C-r>"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Open Oil (float)" })
	end,
}
