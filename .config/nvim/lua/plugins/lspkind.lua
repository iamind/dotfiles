-- ==========================================================================
--  plugins/lspkind.lua - 補完アイコン
-- ==========================================================================

return {
	'onsails/lspkind-nvim',
	event = "InsertEnter",
	config = function()
		local status, lspkind = pcall(require, "lspkind")
		if (not status) then return end
		lspkind.init({
			mode = 'symbol',
			preset = 'codicons',
			symbol_map = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = ""
			},
		})
	end
}
