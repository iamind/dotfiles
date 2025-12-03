return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",                                 desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                                  desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>",                                    desc = "Buffers" },
			{ "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File Browser" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",                                  desc = "Help Tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                   desc = "Recent Files" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			telescope.setup({
				defaults = {
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = { prompt_position = "top", preview_width = 0.55 },
						width = 0.87,
						height = 0.80,
					},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					file_ignore_patterns = { "node_modules", ".git/", "%.lock", "__pycache__", "%.pyc", ".DS_Store" },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<Esc>"] = actions.close,
						},
						n = { ["q"] = actions.close },
					},
				},
				extensions = {
					file_browser = {
						theme = "dropdown",
						hijack_netrw = false,
						grouped = true,
						hidden = false,
						respect_gitignore = true,
						prompt_prefix = " 󰥨  ",
						mappings = {
							i = {
								["<C-h>"] = fb_actions.goto_parent_dir,
								["<C-e>"] = fb_actions.goto_home_dir,
								["<C-w>"] = fb_actions.goto_cwd,
								["<C-t>"] = fb_actions.change_cwd,
								["<C-f>"] = fb_actions.toggle_browser,
								["<C-s>"] = fb_actions.toggle_hidden,
								["<C-a>"] = fb_actions.create,
								["<C-r>"] = fb_actions.rename,
								["<C-d>"] = fb_actions.remove,
								["<C-y>"] = fb_actions.copy,
								["<C-m>"] = fb_actions.move,
							},
							n = {
								["h"] = fb_actions.goto_parent_dir,
								["l"] = actions.select_default,
								["."] = fb_actions.toggle_hidden,
								["a"] = fb_actions.create,
								["r"] = fb_actions.rename,
								["d"] = fb_actions.remove,
								["y"] = fb_actions.copy,
								["m"] = fb_actions.move,
							},
						},
					},
				},
			})
			telescope.load_extension("file_browser")
		end,
	},
}
