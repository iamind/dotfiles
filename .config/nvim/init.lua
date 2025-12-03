-- ==========================================================================
--  init.lua - エントリポイント
-- ==========================================================================

-- --------------------------------------------------------------------------
-- 1. コア設定
-- --------------------------------------------------------------------------
-- Leader キーと基本設定はプラグイン読み込みより先に実行
require("core.keymaps")
require("core.options")
require("core.autocmds")

-- --------------------------------------------------------------------------
-- 2. プラグインマネージャ (lazy.nvim)
-- --------------------------------------------------------------------------
local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvim が未インストールなら自動で clone
if not uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

-- runtimepath に lazy.nvim を追加
vim.opt.rtp:prepend(lazypath)

-- --------------------------------------------------------------------------
-- 3. プラグイン読み込み設定
--    - "plugins" モジュールにプラグイン定義を集約
--    - LuaRocks 機能は使わないので明示的に無効化
-- --------------------------------------------------------------------------
require("lazy").setup("plugins", {
	rocks = {
		enabled = false, -- ← LuaRocks サポートを完全に無効化して :checkhealth の ERROR を消す
		-- hererocks = false, -- enabled=false なら明示不要だが、より厳密に切りたいならコメントアウト解除
	},
})
