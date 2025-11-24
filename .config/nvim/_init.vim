" -----------------------------------------------------------
" setting
" -----------------------------------------------------------

set fenc=utf-8  "文字コードをUFT-8に設定
set fileencoding=utf-8  " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932  " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac  " 改行コードの自動判別. 左側が優先される
" set ambiwidth=double  "□や○文字が崩れる問題を解決
set nobackup " バックアップファイルを作らない
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する
set noswapfile  " swapファイルを作成しない
set clipboard+=unnamedplus  "OSのクリップボードを使用する
set ttyfast  "ターミナルを高速にする


let g:python3_host_prog = '/Users/zen/.pyenv/versions/3.9.0/bin/python'
let g:node_host_prog = '/usr/local/bin/neovim-node-host'



" -----------------------------------------------------------
" Plugins
" -----------------------------------------------------------
runtime ./plug.vim









"----------Vim機能設定----------
 "ビープ音可視化
set visualbell t_vb=



"-----------------------------------
"          Vimキーバインド
"-----------------------------------

let mapleader = "\<Space>"


noremap <C-l> $
noremap <C-h> 0

" エスケープキー設定
inoremap <Leader>, <Esc>
vnoremap <Leader>, <Esc>


nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l


" 実行コマンド
nmap <F5> :!python3 %
nmap <F6> :term python3 %
nmap <Leader>f :LspDocumentFormat






nnoremap <ESC><ESC> :nohlsearch<CR>


"----------------------------------------------------------
"                  ステータスラインの設定
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの現在位置を表示する



"---------------------------------------------
"                   見た目
"---------------------------------------------
set number  " 行番号を表示
set showmatch  " 括弧入力時の対応する括弧を表示
set cursorline  " 現在の行を強調表示
set wildmenu  " コマンドラインの補完
set history=5000  " 保存するコマンド履歴の数
syntax enable  " シンタックスハイライトの有効化
set virtualedit=onemore  " 行末の1文字先までカーソルを移動できるように
set termguicolors
set t_Co=256  "ターミナルで256色表示を使う
"-----------------------------------------
"              ColorScheme
"-----------------------------------------
colorscheme iceberg



"-----------------------------------------
"                透明化
"-----------------------------------------
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

autocmd FileTYpe tex syntax region texRefZone matchgroup=texStatement
     \ start="\\ref\(fig\|tab\|sec\|eqn\|chap\|alg\){"
     \ end="}\|%stopzone\>"
     \ contains=@texRefGroup






nnoremap <silent><Leader>f :<C-u>Defx -split=vertical -winwidth=40 -search=`expand('%:p')` -direction=topleft `expand('%:p:h')`<CR>
autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
   \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> j
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'k'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> k
  \ line('.') == line('$') ? 'gg' : 'k'
  nnoremap <silent><buffer><expr> i
  \ line('.') == 1 ? 'G' : 'i'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
  noremap <silent><buffer>h i
  noremap <silent><buffer>i k
  " noremap <silent><buffer>j h
  noremap <silent><buffer>k j
endfunction
