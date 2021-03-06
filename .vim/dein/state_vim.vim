if g:dein#_cache_version !=# 150 || g:dein#_init_runtimepath !=# '/Users/zen/.vim,/usr/share/vim/vimfiles,/usr/share/vim/vim81,/usr/share/vim/vimfiles/after,/Users/zen/.vim/after,/Users/zen/.vim/dein/repos/github.com/Shougo/dein.vim' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/zen/.vimrc'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/zen/.vim/dein'
let g:dein#_runtime_path = '/Users/zen/.vim/dein/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/Users/zen/.vim/dein/.cache/.vimrc'
let &runtimepath = '/Users/zen/.vim,/usr/share/vim/vimfiles,/Users/zen/.vim/dein/repos/github.com/Shougo/dein.vim,/Users/zen/.vim/dein/.cache/.vimrc/.dein,/usr/share/vim/vim81,/Users/zen/.vim/dein/.cache/.vimrc/.dein/after,/usr/share/vim/vimfiles/after,/Users/zen/.vim/after'
filetype off
