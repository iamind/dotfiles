-- ==========================================================================
--  plugins/noice.lua - コマンドライン・メッセージUI
-- ==========================================================================

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			format = {
				-- コマンドタイプごとにアイコンをカスタマイズ
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
			},
		},

		-- ポップアップの位置（中央上部）
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
			},
		},

		-- LSP進捗を右下にミニ表示
		lsp = {
			progress = {
				enabled = true,
			},
			-- hover/signatureのドキュメントをきれいに
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},

		-- プリセット（便利な組み合わせ）
		presets = {
			bottom_search = false,     -- 検索もポップアップで
			command_palette = true,    -- コマンドパレット風UI
			long_message_to_split = true, -- 長いメッセージは分割表示
			lsp_doc_border = true,     -- LSPドキュメントに枠線
		},

		-- 特定メッセージを非表示（お好みで）
		routes = {
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "written", -- "written" メッセージを非表示
				},
				opts = { skip = true },
			},
		},
	},
}
