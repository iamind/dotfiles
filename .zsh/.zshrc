# --------------------------------------------------------------------------
# zplug
# --------------------------------------------------------------------------

source ~/.zplug/init.zsh
# 「ユーザ名/リポジトリ名」で記述し、ダブルクォートで見やすく括る（括らなくてもいい）
zplug "zsh-users/zsh-syntax-highlighting"
zplug "b4b4r07/enhancd", use:"init.sh"

# check コマンドで未インストール項目があるかどうか verbose にチェックし
# false のとき（つまり未インストール項目がある）y/N プロンプトで
# インストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose

# peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
 


# --------------------------------------------------------------------------
# 基本設定
# --------------------------------------------------------------------------
setopt interactive_comments  # '#' 以降をコメントとして扱う
setopt no_beep  # ビープ音を鳴らさない
setopt print_eight_bit  # 日本語ファイル名を表示可能にする
setopt correct  # コマンドのスペルミスを指摘
setopt auto_cd  # cd無しでもディレクトリ移動
autoload -Uz colors  # 色を使用出来るようにする
export TERM=xterm-256color


# --------------------------------------------------------------------------
# 環境変数
# --------------------------------------------------------------------------
export PATH="$HOME/.nodebrew/current/bin:$PATH"
export LANG=ja_JP.UTF-8
export PATH="$HOME/bin:$PATH"


# --------------------------------------------------------------------------
# ヒストリの設定
# --------------------------------------------------------------------------

setopt share_history  # 同時に起動しているzshの間でhistoryを共有する
setopt hist_ignore_all_dups  # 同じコマンドをhistoryに残さない
setopt hist_reduce_blanks  # historyに保存するときに余分なスペースを削除する
HISTFILE=~/.zsh_history  # 履歴ファイルの保存先
HISTSIZE=1000000  # メモリに保存される履歴の件数
SAVEHIST=1000000  # HISTFILE で指定したファイルに保存される履歴の件数



# --------------------------------------------------------------------------
# エイリアス系
# --------------------------------------------------------------------------

# Git系
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gs='git status'
alias gp='git push'

# Docker系
alias d='docker'
alias dc='docker-compose'

# kubectl
alias k='kubectl'

# Tmux系
alias t='tmux'

# Shell Script系
alias ide='./ide.zsh'

# Vim系
alias nv='nvim'

# Linux系
alias ls='exa --icons'

# Tool系　
alias ondo='istats all'

alias ed='nv ~/.config/nvim/init.vim'
alias nvf='nv ~/.config/nvim'

# --------------------------------------------------------------------------
# プロンプトの設定
# --------------------------------------------------------------------------

export CLICOLOR=1

autoload -Uz compinit && compinit  # Gitの補完を有効化

function left-prompt {
  name_t='255m%}'      # user name text clolr
  name_b='246m%}'    # user name background color
  path_t='255m%}'     # path text clolr
  path_b='240m%}'   # path background color
  arrow='087m%}'   # arrow color
  text_color='%{\e[38;5;'    # set text color
  back_color='%{\e[30;48;5;' # set background color
  reset='%{\e[0m%}'   # reset
  sharp='\uE0B0'      # triangle
  
  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
  echo "${user} %n@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp} ${reset}\n${text_color}${arrow}→ ${reset}"
}

PROMPT=`left-prompt` 

# コマンドの実行ごとに改行
function precmd() {
    # Print a newline before the prompt, unless it's the
    # first prompt in the process.
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}


# git ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status
  
  branch='\ue0a0'
  color='%{\e[38;5;' #  文字色を設定
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'   # reset
  
# ブランチマーク
# ${branch}の後にスーペースを入れる
if [ ! -e ".git" ]; then
    # git 管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="${color}${green}${branch} "
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="${color}${red}${branch} ?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="${color}${red}${branch} +"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="${color}${yellow}${branch} !"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "${color}${red}${branch} !(no branch)${reset}"
    return
  else
    # 上記以外の状態の場合
    branch_status="${color}${blue}${branch} "
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name${reset}"
}
 
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
 
# プロンプトの右側にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'


# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
