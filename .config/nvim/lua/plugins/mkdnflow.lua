return {
	"jakewvincent/mkdnflow.nvim",
	ft = { "markdown" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		modules = {
			bib = false,      -- 参考文献は使わない
			buffers = true,   -- バッファ管理
			conceal = false,  -- concealはrender-markdown.nvimに任せる
			cursor = true,    -- カーソル移動
			folds = false,    -- フォールドは使わない
			frontmatter = false, -- フロントマター解析は不要
			links = true,     -- リンク機能
			lists = true,     -- リスト機能
			maps = true,      -- マッピング有効
			paths = true,     -- パス解決
			tables = true,    -- テーブル操作
			yaml = false,     -- YAML解析は不要
		},

		-- リンク設定
		links = {
			style = "markdown",      -- []() 形式（wikilink形式ではない）
			conceal = false,         -- render-markdown.nvimに任せる
			context = 0,             -- リンク検出のコンテキスト行数
			implicit_extension = "md", -- 拡張子省略時は.mdを補完
			transform_implicit = false, -- 暗黙変換しない
			transform_explicit = function(text)
				-- リンクテキストをファイル名に変換（スペース→ハイフン、小文字化）
				return text:gsub(" ", "-"):lower()
			end,
		},

		-- 新規ファイル作成設定
		new_file_template = {
			use_template = false, -- テンプレートは使わない（シンプルに）
		},

		-- To-do設定
		to_do = {
			symbols = { " ", "x" }, -- 未完了: [ ], 完了: [x]
			update_parents = true, -- 親リストも更新
			not_started = " ",
			complete = "x",
		},

		-- テーブル設定
		tables = {
			trim_whitespace = true,
			format_on_move = true,
			auto_extend_rows = true,
			auto_extend_cols = true,
		},

		-- マッピング設定
		mappings = {
			-- リンクフォロー・作成（Normalモード）
			MkdnEnter = { { "n", "v" }, "<CR>" }, -- リンクフォロー or 選択テキストをリンク化
			MkdnFollowLink = { "n", "gf" },    -- gfでもリンクフォロー

			-- リンクを別ウィンドウで開く
			MkdnSTab = { "n", "gv" }, -- vsplitで開く（Shift-Tabの代わり）

			-- To-doトグル
			-- Raycastと競合するため <C-Space> から <leader>td に変更
			MkdnToggleToDo = { { "n", "v" }, "<leader>td" },

			-- リスト操作（Insertモード）
			MkdnNewListItem = { "i", "<CR>" },      -- Enterでリスト継続
			MkdnNewListItemBelowInsert = { "n", "o" }, -- oで新規リストアイテム
			MkdnNewListItemAboveInsert = { "n", "O" }, -- Oで上に新規リストアイテム

			-- 見出しレベル変更を無効化（oilの - キーと競合するため）
			MkdnDecreaseHeading = false,
			MkdnIncreaseHeading = false,

			-- リスト・見出しナビゲーション
			MkdnNextHeading = { "n", "]]" }, -- 次の見出し
			MkdnPrevHeading = { "n", "[[" }, -- 前の見出し
			MkdnNextLink = { "n", "<Tab>" }, -- 次のリンク
			MkdnPrevLink = { "n", "<S-Tab>" }, -- 前のリンク

			-- テーブル操作
			MkdnTableNextCell = { "i", "<Tab>" },      -- 次のセル
			MkdnTablePrevCell = { "i", "<S-Tab>" },    -- 前のセル
			MkdnTableNewRowBelow = { "n", "<leader>tr" }, -- 行追加
			MkdnTableNewColAfter = { "n", "<leader>tc" }, -- 列追加

			-- インデント
			MkdnIncreaseIndent = { "n", ">>" },
			MkdnDecreaseIndent = { "n", "<<" },

			-- 使わない機能は無効化
			MkdnCreateLink = false, -- 別途<CR>で対応
			MkdnCreateLinkFromClipboard = false,
			MkdnDestroyLink = false,
			MkdnMoveSource = false,
			MkdnYankAnchorLink = false,
			MkdnYankFileAnchorLink = false,
			MkdnFoldSection = false,
			MkdnUnfoldSection = false,
			MkdnUpdateNumbering = false,
			MkdnTableNextRow = false,
			MkdnTablePrevRow = false,
			MkdnExtendList = false,
		},

		-- ファイルをタブで開く（自作md-links.luaと同じ挙動）
		perspective = {
			priority = "current", -- 現在のファイルからの相対パス優先
			fallback = "first",
			root_tell = false,
		},
	},

	config = function(_, opts)
		require("mkdnflow").setup(opts)

		-- vsplit用のカスタムマッピング（MkdnSTabがvsplitではないので）
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				-- gvでvsplit
				vim.keymap.set("n", "gv", function()
					local link = require("mkdnflow").links.getLinkPart()
					if link then
						vim.cmd("vsplit")
						require("mkdnflow").links.followLink()
					end
				end, { buffer = true, silent = true, desc = "Follow link (vsplit)" })

				-- gsでsplit
				vim.keymap.set("n", "gs", function()
					local link = require("mkdnflow").links.getLinkPart()
					if link then
						vim.cmd("split")
						require("mkdnflow").links.followLink()
					end
				end, { buffer = true, silent = true, desc = "Follow link (split)" })
			end,
		})
	end,
}
