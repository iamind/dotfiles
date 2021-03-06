map <C-n> :NERDTreeToggle<CR>map <C-n> :NERDTreeToggle<CR>"==========Vim基本設定==========
" ファイルを上書きする前にバックアップを作ることを無効化
set nowritebackup

" ファイルを上書きする前にバックアップを作ることを無効化
set nobackup


"==========Vim機能設定==========
"ビープ音可視化
set visualbell t_vb=

" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect


"==========見た目==========
"行番号の表示
set number

"現在の行を強調表示
set cursorline

" 括弧入力時の対応する括弧を表示
set showmatch

" シンタックスハイラト有効
syntax enable

" ステータスラインを常に表示
set laststatus=2

" コマンドラインの補完
set wildmode=list:longest


"==========Vimキーバインド==========
noremap h i
noremap i k
noremap j h
noremap k j

inoremap <C-[> <Esc>

map <C-n> :NERDTreeToggle<CR>


"-------プラグインマネージャー-------
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/zen/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/zen/.vim/dein')
  call dein#begin('/Users/zen/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/zen/.vim/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('scrooloose/nerdtree')
  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
