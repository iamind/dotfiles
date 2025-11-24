-- ==========================================================================
--  My Neovim Configuration (Refactored)
-- ==========================================================================

-- --------------------------------------------------------------------------
-- 1. システム・基本設定
-- --------------------------------------------------------------------------
vim.opt.title = true   -- ターミナルタイトルを動的に更新
vim.opt.backup = false -- バックアップファイルを生成しない

-- Mac OSのクリップボード共有
vim.opt.clipboard:append { 'unnamedplus' }

-- シェル設定 (必要であれば有効化)
-- vim.opt.shell = 'fish'
-- vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }


-- --------------------------------------------------------------------------
-- 2. 表示・UI (Visual)
-- --------------------------------------------------------------------------
vim.opt.number = true -- 行番号を表示
-- vim.wo.number = true    -- 現在のウィンドウだけ行番号

vim.opt.cmdheight = 1      -- コマンドラインの高さ
vim.opt.showcmd = true     -- 入力中のコマンドを表示
vim.opt.laststatus = 2     -- ステータスラインを常に表示
vim.opt.scrolloff = 10     -- スクロール時の余白確保

vim.opt.breakindent = true -- 折り返し行のインデント維持
vim.opt.wrap = false       -- 行の自動折り返しを無効化

-- カーソル下の単語に下線 (必要であれば有効化)
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])


-- --------------------------------------------------------------------------
-- 3. インデント・タブ (Indentation)
-- --------------------------------------------------------------------------
vim.opt.tabstop = 2        -- タブ文字幅
vim.opt.shiftwidth = 2     -- インデント幅
vim.opt.smarttab = true    -- スマートなタブ挙動
vim.opt.autoindent = true  -- 自動インデント
vim.opt.smartindent = true -- スマートインデント

-- タブをスペースに変換
-- vim.opt.expandtab = true


-- --------------------------------------------------------------------------
-- 4. 検索・置換 (Search)
-- --------------------------------------------------------------------------
vim.opt.hlsearch = true      -- 検索ハイライト
vim.opt.inccommand = 'split' -- 置換プレビュー

-- 大文字小文字の扱い
-- vim.opt.ignorecase = true


-- --------------------------------------------------------------------------
-- 5. 編集・その他 (Editing & Others)
-- --------------------------------------------------------------------------
-- バックスペースの挙動
-- vim.opt.backspace = { 'start', 'eol', 'indent' }

-- インサートモード終了時にペーストモードOFF
-- vim.api.nvim_create_autocmd("InsertLeave", { pattern = '*', command = "set nopaste" })

-- フォーマットオプション
-- vim.opt.formatoptions:append { 'r' }

-- ファイル検索パス
-- vim.opt.path:append { '**' }
-- vim.opt.wildignore:append { '*/node_modules/*' }


-- --------------------------------------------------------------------------
-- 6. プラグインマネージャ (lazy.nvim)
-- --------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")


-- --------------------------------------------------------------------------
-- [Archive] 削除・修正したコード
-- --------------------------------------------------------------------------
-- vim.cmd("autocmd!") -- 危険: プラグインのautocmdも消えるため削除
-- vim.opt.encoding = 'utf-8' -- 不要: NeovimはデフォルトUTF-8
-- vim.scriptencoding = 'utf-8'
-- vim.opt.fileencoding = 'utf-8'
-- plugins = require('plugins') -- 不要: グローバル変数汚染のため削除
