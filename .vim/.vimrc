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


let g:jellybeans_overrides = {
\   'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}
if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif
