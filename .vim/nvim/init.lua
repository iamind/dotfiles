vim.cmd("autocmd!") -- 全てのautocommandを削除する



-- [エンコーディング関係]
vim.opt.encoding = 'utf-8' -- エンコーディングをUTF-8に設定
vim.scriptencoding = 'utf-8' -- スクリプトエンコーディングをUTF-8に設定
vim.opt.fileencoding = 'utf-8' -- ファイルのエンコーディングをUTF-8に設定


-- [Editor visual]
vim.o.number = true -- 行番号を表示する設定にします
-- vim.wo.number = true -- 現在のウィンドウだけ行番号を表示
vim.opt.tabstop = 2 -- タブストップを2に設定
vim.opt.shiftwidth = 2 -- シフト幅を2に設定
vim.opt.hlsearch = true -- 検索結果のハイライトを有効化

-- [Editor settings]
vim.o.autoindent = true -- 自動インデント機能の有無
vim.opt.smartindent = true -- スマートインデントの有無
vim.opt.backup = false -- バックアップを無効化





-- ターミナルのタイトルを動的に更新
vim.opt.title = true






-- コマンドラインで実行中のコマンドを表示
vim.opt.showcmd = true

-- コマンドラインの高さを1に設定
vim.opt.cmdheight = 1

-- ステータスラインを常に表示
vim.opt.laststatus = 2

-- タブをスペースに変換
-- vim.opt.expandtab = true

-- スクロール開始位置を設定
vim.opt.scrolloff = 10

-- シェルをfishに設定
-- vim.opt.shell = 'fish'

-- バックアップをスキップするファイルを設定
-- vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }

-- インクリメンタル置換を有効化
vim.opt.inccommand = 'split'

-- 大文字小文字を区別しない検索を有効化
-- vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search

-- スマートタブを有効化
vim.opt.smarttab = true

-- 折り返し行のインデントを有効化
vim.opt.breakindent = true





-- 行の自動折り返しを無効化
vim.opt.wrap = false -- No Wrap lines

-- バックスペースの動作を設定
-- vim.opt.backspace = { 'start', 'eol', 'indent' }

-- ファイル検索パスにサブフォルダを追加
-- vim.opt.path:append { '**' } -- Finding files - Search down into subfolders

-- ファイル検索から特定のパスを除外
-- vim.opt.wildignore:append { '*/node_modules/*' }


-- カーソル下の単語に下線を引く
-- vim.cmd([[let &t_Cs = "\e[4:3m"]])
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- インサートモードを終了したときにペーストモードをオフにする
-- vim.api.nvim_create_autocmd("InsertLeave", {
--  pattern = '*',
--  command = "set nopaste"
-- })

-- ブロックコメントにアスタリスクを追加
-- vim.opt.formatoptions:append { 'r' }







-- Mac OSのクリップボード共有
vim.opt.clipboard:append { 'unnamedplus' }


-- [lazy.nvim]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
plugins = require('plugins')
require("lazy").setup("plugins")








