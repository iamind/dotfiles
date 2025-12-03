# keymaps.md

## 概要
Neovimの設定ファイル一式から抽出したキーマップ定義の一覧です。
プラグインごとに分類し、通常時の操作と、特定のウィンドウ（ファイラや検索窓など）での操作を分けて記載しています。

### 凡例
* **Mode**:
    * `n`: Normal
    * `i`: Insert
    * `v`: Visual
    * `x`: Visual (矩形選択含む)
    * `o`: Operator-pending
    * `c`: Command-line
    * `(Oil)`: Oilファイルブラウザ内
    * `(Telescope)`: Telescopeウィンドウ内
    * `(Cmp)`: 補完メニュー表示中
* **Default**: プラグインがない場合の標準的なVimの動作
* **Action**: 設定された動作

---

## 1. oil.nvim (ファイル操作)
**Source**: `plugins/oil.lua`

### グローバル（どこでも使える）
| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `-` | n | 前の行の行頭へ移動 | `Open parent directory` | Oilで親ディレクトリを開く |
| `<leader>o` | n | (なし) | `Open Oil (float)` | Oilをフローティングウィンドウで開く |

### Oilバッファ内（Oil起動時のみ）
| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `g?` | n | Rot13エンコード | `actions.show_help` | ヘルプ（キーマップ一覧）を表示 |
| `<CR>` | n | 次の行へ移動 | `actions.select` | ファイルを開く / ディレクトリに入る |
| `<C-v>` | n | 矩形選択モード | `actions.select_vsplit` | 垂直分割(vsplit)で開く |
| `<C-s>` | n | (XOFF) | `actions.select_split` | 水平分割(split)で開く |
| `<C-t>` | n | タグジャンプ戻る | `actions.select_tab` | 新しいタブで開く |
| `<C-p>` | n | 前の行へ移動 | `actions.preview` | プレビュー表示 |
| `<C-c>` | n | 中断 | `actions.close` | Oilを閉じる |
| `<C-r>` | n | Redo | `actions.refresh` | 表示をリフレッシュ |
| `-` | n | 前の行の行頭へ移動 | `actions.parent` | 親ディレクトリへ移動 |
| `_` | n | (行頭へ移動) | `actions.open_cwd` | カレントディレクトリをOilで開く |
| `` ` `` | n | マークジャンプ | `actions.cd` | ディレクトリへ移動 (cd) |
| `~` | n | 大文字小文字変換 | `actions.tcd` | タブごとのディレクトリへ移動 (tcd) |
| `gs` | n | スリープ | `actions.change_sort` | ソート順の変更 |
| `gx` | n | ネットrwを開く | `actions.open_external` | 外部アプリで開く |
| `g.` | n | 直前の変更箇所へ | `actions.toggle_hidden` | 隠しファイルの表示切替 |
| `g\` | n | (なし) | `actions.toggle_trash` | ゴミ箱の表示切替 |

---

## 2. telescope.nvim (検索・ファイルブラウザ)
**Source**: `plugins/telescope.lua`

### グローバル（起動ショートカット）
| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<leader>ff` | n | (なし) | `Telescope find_files` | ファイル検索 |
| `<leader>fg` | n | (なし) | `Telescope live_grep` | 全文検索 (Grep) |
| `<leader>fb` | n | (なし) | `Telescope buffers` | バッファ一覧 |
| `<leader>fe` | n | (なし) | `file_browser path=%:p:h` | ファイルブラウザを開く |
| `<leader>fh` | n | (なし) | `Telescope help_tags` | ヘルプ検索 |
| `<leader>fr` | n | (なし) | `Telescope oldfiles` | 最近開いたファイル |

### Telescopeウィンドウ内 (共通)
| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<C-j>` | i | 改行 | `actions.move_selection_next` | 次の候補へ移動（下） |
| `<C-k>` | i | ダイグラフ入力 | `actions.move_selection_previous` | 前の候補へ移動（上） |
| `<C-q>` | i | (XON) | `send_to_qflist + open` | クイックフィックスリストへ送る |
| `<Esc>` | i | ノーマルモードへ | `actions.close` | 閉じる |
| `q` | n | マクロ記録 | `actions.close` | 閉じる |

### File Browser拡張機能内
| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<C-h>` | i | バックスペース | `fb_actions.goto_parent_dir` | 親ディレクトリへ移動 |
| `<C-e>` | i | 行末へ挿入 | `fb_actions.goto_home_dir` | ホームディレクトリへ移動 |
| `<C-w>` | i | 前の単語削除 | `fb_actions.goto_cwd` | カレントディレクトリへ移動 |
| `<C-t>` | i | インデント | `fb_actions.change_cwd` | ディレクトリを変更 (cd) |
| `<C-f>` | i | インデント | `fb_actions.toggle_browser` | ブラウザ表示切替 |
| `<C-s>` | i | (XOFF) | `fb_actions.toggle_hidden` | 隠しファイル表示切替 |
| `<C-a>` | i | (なし) | `fb_actions.create` | 新規作成 |
| `<C-r>` | i | レジスタ挿入 | `fb_actions.rename` | リネーム |
| `<C-d>` | i | インデント解除 | `fb_actions.remove` | 削除 |
| `<C-y>` | i | 上の行をコピー | `fb_actions.copy` | コピー |
| `<C-m>` | i | 改行 | `fb_actions.move` | 移動 |
| `h` | n | 左移動 | `fb_actions.goto_parent_dir` | 親ディレクトリへ移動 |
| `l` | n | 右移動 | `actions.select_default` | 選択（ディレクトリに入る） |
| `.` | n | 直前の操作繰り返し | `fb_actions.toggle_hidden` | 隠しファイル表示切替 |
| `a` | n | 追記モード | `fb_actions.create` | 新規作成 |
| `r` | n | 1文字置換 | `fb_actions.rename` | リネーム |
| `d` | n | 削除オペレータ | `fb_actions.remove` | 削除 |
| `y` | n | ヤンク | `fb_actions.copy` | コピー |
| `m` | n | マーク | `fb_actions.move` | 移動 |

---

## 3. flash.nvim (高速移動)
**Source**: `plugins/flash.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `s` | n, x, o | `cl` (文字削除挿入) | `flash.jump()` | Flashジャンプ（画面内移動） |
| `S` | n, x, o | `cc` (行削除挿入) | `flash.treesitter()` | Flash Treesitter（構文選択） |
| `r` | o | `r` (1文字置換) | `flash.remote()` | リモート操作（対象を選択） |
| `R` | o, x | `R` (置換モード) | `flash.treesitter_search()` | Treesitter検索 |
| `<c-s>` | c | (XOFF) | `flash.toggle()` | Flash検索の切り替え |

---

## 4. mkdnflow.nvim (Markdownリンク・リスト)
**Source**: `plugins/mkdnflow.lua`
※ `markdown` ファイルでのみ有効

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<CR>` | n, v | 下行へ移動 | `MkdnEnter` | リンクを開く / リンク化 |
| `gf` | n | ファイルを開く | `MkdnFollowLink` | リンク先へジャンプ |
| `gv` | n | 選択範囲復元 | `(custom) vsplit` | リンク先を垂直分割で開く |
| `gs` | n | スリープ | `(custom) split` | リンク先を水平分割で開く |
| `<leade>td>` | n, v | (なし) | `MkdnToggleToDo` | チェックボックス切替 `[ ]` ↔ `[x]` |
| `<CR>` | i | 改行 | `MkdnNewListItem` | リスト内で改行し次を作成 |
| `o` | n | 行挿入 | `MkdnNewListItemBelow` | 下にリストアイテム追加 |
| `O` | n | 行挿入 | `MkdnNewListItemAbove` | 上にリストアイテム追加 |
| `]]` | n | 次セクション | `MkdnNextHeading` | 次の見出しへ |
| `[[` | n | 前セクション | `MkdnPrevHeading` | 前の見出しへ |
| `<Tab>` | n | ジャンプ進む | `MkdnNextLink` | 次のリンクへ |
| `<S-Tab>` | n | (なし) | `MkdnPrevLink` | 前のリンクへ |
| `<Tab>` | i | タブ挿入 | `MkdnTableNextCell` | テーブル：次のセル |
| `<S-Tab>` | i | インデント解除 | `MkdnTablePrevCell` | テーブル：前のセル |
| `<leader>tr` | n | (なし) | `MkdnTableNewRowBelow` | テーブル：下に行追加 |
| `<leader>tc` | n | (なし) | `MkdnTableNewColAfter` | テーブル：右に列追加 |
| `>>` | n | インデント | `MkdnIncreaseIndent` | インデント増加 |
| `<<` | n | インデント解除 | `MkdnDecreaseIndent` | インデント減少 |

---

## 5. md-links.lua (Markdown拡張)
**Source**: `plugins/md-links.lua`
※ `markdown` ファイルでのみ有効

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `gp` | n | (exモード等) | `follow_md_link_float` | リンクをフローティングでプレビュー |
| `<leader>ml` | v | (なし) | `Create markdown link` | 選択テキストをリンク化 |
| `<leader>mx` | v | (なし) | `Extract to file` | 別ファイルへ切り出し |
| `q` | n(Float) | マクロ記録 | `close` | プレビューを閉じる |
| `<Esc>` | n(Float) | (なし) | `close` | プレビューを閉じる |

---

## 6. nvim-cmp (自動補完)
**Source**: `plugins/nvim-cmp.lua`
※ 補完メニュー表示中

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<C-d>` | i | インデント解除 | `scroll_docs(-4)` | ドキュメントを上にスクロール |
| `<C-f>` | i | インデント | `scroll_docs(4)` | ドキュメントを下にスクロール |
| `<C-Space>` | i | (なし) | `complete()` | 補完メニューを表示 |
| `<C-e>` | i | 行末へ | `close()` | 補完メニューを閉じる |
| `<CR>` | i | 改行 | `confirm({ select = true })` | 補完を確定 |

---

## 7. nvim-autopairs (括弧補完)
**Source**: `plugins/autopairs.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<M-e>` | i | (Alt+e) | `fast_wrap` | Fast Wrap（括弧で囲む） |

---

## 8. nvim-lspconfig (LSP定義ジャンプ)
**Source**: `plugins/lspconfig.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `gD` | n | 行全体定義へ | `vim.lsp.buf.declaration` | 宣言元へジャンプ |
| `gi` | n | 挿入位置へ | `vim.lsp.buf.implementation` | 実装箇所へジャンプ |

---



## 1. [oil](oil).nvim (ファイル操作)
**Source**: `plugins/oil.lua`
※ ファイルシステムを編集するバッファ内での操作

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `-` | n | 行頭移動 | `Open parent directory` | 親ディレクトリへ移動（Oil起動） |
| `<leader>o` | n | (なし) | `Open Oil (float)` | Oilをフローティングウィンドウで開く |
| **(Oil内)** | | | | |
| `g?` | n | Rot13 | `actions.show_help` | ヘルプ（キーマップ一覧）を表示 |
| `<CR>` | n | 次行へ | `actions.select` | 選択（ファイルを開く / ディレクトリ移動） |
| `<C-v>` | n | 矩形選択 | `actions.select_vsplit` | 垂直分割(vsplit)で開く |
| `<C-s>` | n | (XOFF) | `actions.select_split` | 水平分割(split)で開く |
| `<C-t>` | n | タグ戻る | `actions.select_tab` | 新規タブで開く |
| `<C-p>` | n | 前行へ | `actions.preview` | プレビュー表示 |
| `<C-c>` | n | 中断 | `actions.close` | 閉じる |
| `<C-r>` | n | Redo | `actions.refresh` | リフレッシュ（再読み込み） |
| `-` | n | 行頭移動 | `actions.parent` | 親ディレクトリへ移動 |
| `_` | n | 行頭移動 | `actions.open_cwd` | カレントディレクトリをOilで開く |
| `` ` `` | n | マーク | `actions.cd` | ディレクトリへ移動(cd) |
| `~` | n | 大文字変換 | `actions.tcd` | タブ用ディレクトリへ移動(tcd) |
| `gs` | n | スリープ | `actions.change_sort` | ソート順の変更 |
| `gx` | n | ネットrw | `actions.open_external` | 外部アプリで開く |
| `g.` | n | 直前変更 | `actions.toggle_hidden` | 隠しファイルの表示切替 |
| `g\` | n | (なし) | `actions.toggle_trash` | ゴミ箱の表示切替 |

---

## 2. telescope.nvim (検索・多機能セレクタ)
**Source**: `plugins/telescope.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<leader>ff` | n | (なし) | `Telescope find_files` | ファイル検索 |
| `<leader>fg` | n | (なし) | `Telescope live_grep` | 全文検索 (Grep) |
| `<leader>fb` | n | (なし) | `Telescope buffers` | バッファ一覧 |
| `<leader>fe` | n | (なし) | `file_browser ...` | ファイルブラウザを開く |
| `<leader>fh` | n | (なし) | `Telescope help_tags` | ヘルプ検索 |
| `<leader>fr` | n | (なし) | `Telescope oldfiles` | 最近開いたファイル |
| **(Telescope内)** | | | | |
| `<C-j>` | i | 改行 | `move_selection_next` | 次の候補へ（下） |
| `<C-k>` | i | ダイグラフ | `move_selection_previous` | 前の候補へ（上） |
| `<C-q>` | i | (XON) | `send_to_qflist + open` | クイックフィックスへ送る |
| `<Esc>` | i | Normalへ | `close` | 閉じる |
| `q` | n | 記録 | `close` | 閉じる |
| **(File Browser内)** | | | | |
| `<C-h>` | i | Backspace | `goto_parent_dir` | 親ディレクトリへ |
| `<C-e>` | i | 行末 | `goto_home_dir` | ホームディレクトリへ |
| `<C-w>` | i | 単語削除 | `goto_cwd` | カレントディレクトリへ |
| `<C-t>` | i | インデント | `change_cwd` | ディレクトリ変更(cd) |
| `<C-f>` | i | インデント | `toggle_browser` | ブラウザ表示切替 |
| `<C-s>` | i | (XOFF) | `toggle_hidden` | 隠しファイル表示切替 |
| `<C-a>` | i | (なし) | `create` | 新規作成 |
| `<C-r>` | i | レジスタ | `rename` | リネーム |
| `<C-d>` | i | インデント | `remove` | 削除 |
| `<C-y>` | i | 行コピー | `copy` | コピー |
| `<C-m>` | i | 改行 | `move` | 移動 |
| `h` | n | 左 | `goto_parent_dir` | 親ディレクトリへ |
| `l` | n | 右 | `select_default` | 選択（中に入る） |

---

## 3. flash.nvim (高速移動)
**Source**: `plugins/flash.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `s` | n, x, o | `cl` | `flash.jump()` | Flashジャンプ（画面内移動） |
| `S` | n, x, o | `cc` | `flash.treesitter()` | Flash Treesitter（構文選択） |
| `r` | o | `r` | `flash.remote()` | リモート操作（対象を選択） |
| `R` | o, x | `R` | `flash.treesitter_search()` | Treesitter検索 |
| `<c-s>` | c | (XOFF) | `flash.toggle()` | Flash検索の切り替え |

---

## 4. mkdnflow.nvim (Markdownリンク・リスト)
**Source**: `plugins/mkdnflow.lua`
※ `markdown` ファイルタイプ限定

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<CR>` | n, v | 下行へ | `MkdnEnter` | リンクを開く / リンク化 |
| `gf` | n | ファイル開く | `MkdnFollowLink` | リンク先へジャンプ |
| `gv` | n | 選択復元 | `(custom) vsplit` | リンク先を垂直分割で開く |
| `gs` | n | スリープ | `(custom) split` | リンク先を水平分割で開く |
| `<C-Space>` | n, v | (なし) | `MkdnToggleToDo` | To-do切替 `[ ]` ↔ `[x]` |
| `<CR>` | i | 改行 | `MkdnNewListItem` | 次のリストアイテム作成 |
| `o` | n | 下に行挿入 | `MkdnNewListItemBelow` | 下にリストアイテム追加 |
| `O` | n | 上に行挿入 | `MkdnNewListItemAbove` | 上にリストアイテム追加 |
| `]]` | n | 次セクション | `MkdnNextHeading` | 次の見出しへ |
| `[[` | n | 前セクション | `MkdnPrevHeading` | 前の見出しへ |
| `<Tab>` | n | ジャンプ進 | `MkdnNextLink` | 次のリンクへ |
| `<S-Tab>` | n | (なし) | `MkdnPrevLink` | 前のリンクへ |
| `<Tab>` | i | タブ | `MkdnTableNextCell` | テーブル：次のセル |
| `<S-Tab>` | i | インデント除 | `MkdnTablePrevCell` | テーブル：前のセル |
| `<leader>tr` | n | (なし) | `MkdnTableNewRowBelow` | テーブル：下に行追加 |
| `<leader>tc` | n | (なし) | `MkdnTableNewColAfter` | テーブル：右に列追加 |
| `>>` | n | インデント | `MkdnIncreaseIndent` | インデント増加 |
| `<<` | n | インデント除 | `MkdnDecreaseIndent` | インデント減少 |

---

## 5. md-links.lua (Markdown拡張)
**Source**: `plugins/md-links.lua`
※ `markdown` ファイルタイプ限定

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `gp` | n | (exモード等) | `follow_md_link_float` | リンクをフローティングでプレビュー |
| `<leader>ml` | v | (なし) | `Create markdown link` | 選択テキストをリンク化 |
| `<leader>mx` | v | (なし) | `Extract to file` | 別ファイルへ切り出し |
| `q` | n(Float) | 記録 | `close` | プレビューを閉じる |
| `<Esc>` | n(Float) | (なし) | `close` | プレビューを閉じる |

---

## 6. nvim-cmp (自動補完)
**Source**: `plugins/nvim-cmp.lua`
※ 補完メニュー表示中

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<C-d>` | i | インデント除 | `scroll_docs(-4)` | ドキュメントを上にスクロール |
| `<C-f>` | i | インデント | `scroll_docs(4)` | ドキュメントを下にスクロール |
| `<C-Space>` | i | (なし) | `complete()` | 補完メニューを表示 |
| `<C-e>` | i | 行末へ | `close()` | 補完メニューを閉じる |
| `<CR>` | i | 改行 | `confirm({ select = true })` | 補完を確定 |

---

## 7. nvim-autopairs (括弧補完)
**Source**: `plugins/autopairs.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `<M-e>` | i | (Alt+e) | `fast_wrap` | Fast Wrap（括弧で囲む） |

---

## 8. nvim-lspconfig (LSP定義ジャンプ)
**Source**: `plugins/lspconfig.lua`

| Keymap | Mode | Default | Action (Original) | Action (Japanese) |
| :--- | :---: | :--- | :--- | :--- |
| `gD` | n | 行全体定義 | `vim.lsp.buf.declaration` | 宣言元へジャンプ |
| `gi` | n | 挿入位置 | `vim.lsp.buf.implementation` | 実装箇所へジャンプ |

---

## 9. その他のプラグイン (キーマップなし/無効)

以下のプラグインは、提供された設定ファイルおよびデフォルト設定の調査結果に基づき、**有効なキーマップが存在しません**。

| Plugin | Source | Status | Note |
| :--- | :--- | :--- | :--- |
| **nvim-treesitter** | `treesitter.lua` | **None** | `incremental_selection` 設定が未定義のため、デフォルトの選択キー (`gnn`等) も無効です。 |
| **render-markdown** | `render-markdown.lua` | **None** | 見た目の変更のみ。デフォルトで有効な操作キーマップはありません。 |
| **noice.nvim** | `noice.lua` | **None** | UI変更のみ。`keys` 定義がなく、デフォルトのスクロールキー等もLazyVim等とは異なり、素のNoiceでは自動設定されません。 |
| **lualine.nvim** | `lualine.lua` | **None** | ステータスライン表示のみ。 |
| **catppuccin** | `colorscheme.lua` | **None** | カラースキーム（色設定）のみ。 |
| **lspkind** | `lspkind.lua` | **None** | 補完アイコンの変更のみ。 |
