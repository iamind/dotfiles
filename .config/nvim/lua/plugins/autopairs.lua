-- ==========================================================================
--  plugins/autopairs.lua - 括弧自動補完
-- ==========================================================================

return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
	opts = {
		check_ts = true,                    -- treesitter連携
		ts_config = {
			markdown = { "code_fence_content" }, -- コードブロック内では無効
		},
		-- Alt+e で選択範囲を括弧で囲む
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = [=[[%'%"%>%]%)%}%,]]=],
			end_key = "$",
			before_key = "h",
			after_key = "l",
			cursor_pos_before = true,
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			highlight = "Search",
			highlight_grey = "Comment",
		},
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		npairs.setup(opts)

		-- nvim-cmpとの連携
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
