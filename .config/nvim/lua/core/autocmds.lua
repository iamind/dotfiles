-- ==========================================================================
--  core/autocmds.lua - 自動コマンド
-- ==========================================================================

-- --------------------------------------------------------------------------
-- 透過背景設定
-- --------------------------------------------------------------------------
-- ColorScheme適用時に背景を透過にする
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
	end,
})
