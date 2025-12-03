-- ==========================================================================
--  plugins/render-markdown.lua - Notion風リッチMarkdown表示
-- ==========================================================================

return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	ft = { 'markdown' },
	opts = {
		-- ■ 全体の余白設定
		padding = { highlight = 'Normal' },
		-- ■ 見出し：Notionのように「行全体」に色を敷く
		heading = {
			sign = false, -- 左の記号は消す（モダンさ優先）
			position = 'inline',
			width = 'full', -- 【重要】画面の右端まで色を伸ばす
			-- アイコンはシンプルに
			icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' },
			-- 左端に太い線を出してアクセントにする
			border = true,
			border_width = 2,
			border_prefix = false,
		},

		-- ■ コードブロック：枠線ではなく「面」で表現
		code = {
			style = 'full', -- ここもフル幅にする
			width = 'full',
			left_pad = 2,
			right_pad = 2,
			border = 'left', -- 左にアクセントラインを入れるだけにする（ズレない）
			highlight = 'RenderMarkdownCode',
		},
		-- ■ チェックボックス
		checkbox = {
			unchecked = { icon = '󰄱 ' },
			checked   = { icon = '󰄵 ' },
		},
		-- ■ 引用（Blockquote）
		quote = {
			repeat_linebreak = true,
			border = 'left', -- 左線のみ
		},
	},

	config = function(_, opts)
		require('render-markdown').setup(opts)

		-- ■ 色彩設計：Icebergに合う「Notion Dark」カラー
		local colors = {
			-- 背景色を控えめにして、文字を読みやすく
			H1 = { bg = "#2b3347", fg = "#89b4fa", border = "#89b4fa" },
			H2 = { bg = "#253035", fg = "#a6e3a1", border = "#a6e3a1" },
			H3 = { bg = "#333025", fg = "#f9e2af", border = "#f9e2af" },
			H4 = { bg = "#352528", fg = "#f38ba8", border = "#f38ba8" },
			-- コードブロックは背景をわずかに変える程度が一番モダン
			Code = { bg = "#1b1e26", border = "#454b68" },
		}

		for level, color in pairs(colors) do
			if level:match("^H") then
				-- 見出しの背景
				vim.api.nvim_set_hl(0, 'RenderMarkdown' .. level .. 'Bg', { bg = color.bg, fg = color.fg })
				-- 見出しの左線（Border）
				vim.api.nvim_set_hl(0, 'RenderMarkdown' .. level, { fg = color.border })
			elseif level == "Code" then
				vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = color.bg })
				vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = color.bg, fg = "#c0c0c0" })
			end
		end
	end,
}
