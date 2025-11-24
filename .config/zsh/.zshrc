# ==============================================================================
#  Zsh Configuration (XDG準拠 & Dotfiles管理)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. プラグインマネージャ (zplug)
# ------------------------------------------------------------------------------
# zplugがインストールされている場合のみ読み込む
if [[ -f ~/.zplug/init.zsh ]]; then
  source ~/.zplug/init.zsh
  
  # --- 使用するプラグイン定義 ---
  # コマンドのシンタックスハイライト（色分け）
  zplug "zsh-users/zsh-syntax-highlighting"
  # cdコマンドの強化（履歴から移動など）
  zplug "b4b4r07/enhancd", use:"init.sh"

  # --- 未インストールのプラグインがあれば確認してインストール ---
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi
  
  # プラグインをロード
  zplug load
fi

# ------------------------------------------------------------------------------
# 2. 基本設定 (Basic Settings)
# ------------------------------------------------------------------------------
setopt interactive_comments  # コマンドラインで '#' 以降をコメントとして扱う
setopt no_beep               # ビープ音を鳴らさない（静音化）
setopt print_eight_bit       # 日本語ファイル名を表示可能にする
setopt correct               # コマンドのスペルミスを自動訂正・指摘する
setopt auto_cd               # 'cd' 無しでディレクトリ名を入力するだけで移動する
autoload -Uz colors          # 色を使用出来るようにする
export TERM=xterm-256color   # 256色表示を有効化

# ------------------------------------------------------------------------------
# 3. 環境変数 (Environment Variables)
# ------------------------------------------------------------------------------
# 言語設定（日本語）
export LANG=ja_JP.UTF-8

# ※ Homebrewの設定は .zprofile で読み込まれているため、ここでは記述しません。
#    (重複実行防止)

# Nodebrew (Node.jsバージョン管理)
export PATH="$HOME/.nodebrew/current/bin:$PATH"

# Dotfiles Bin (自作スクリプト)
# ~/.dotfiles/bin にあるスクリプトを、コマンドとしてどこでも使えるようにする
export PATH="$HOME/.dotfiles/bin:$PATH"

# ------------------------------------------------------------------------------
# 4. 履歴・ヒストリ設定 (History)
# ------------------------------------------------------------------------------
setopt share_history          # 複数のターミナル間で履歴をリアルタイム共有
setopt hist_ignore_all_dups   # 重複するコマンドは履歴に残さない
setopt hist_reduce_blanks     # 余分なスペースを削除して履歴に保存

# 【重要】履歴ファイルの保存場所
# ZDOTDIR (.config/zsh) 配下に保存することで、ホームディレクトリを汚さない
HISTFILE="$ZDOTDIR/.zsh_history"

# 保存する履歴の件数
HISTSIZE=1000000
SAVEHIST=1000000

# ------------------------------------------------------------------------------
# 5. エイリアス (Aliases)
# ------------------------------------------------------------------------------
# --- Git操作 ---
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gs='git status'
alias gp='git push'

# --- Docker / K8s ---
alias d='docker'
alias dc='docker-compose'
alias k='kubectl'

# --- ツール短縮 ---
alias t='tmux'
alias nv='nvim'
alias ondo='istats all' # Macの温度やファン速度表示

# --- 設定ファイル編集 (ショートカット) ---
# Neovimの設定を開く (init.lua)
alias ed='nv ~/.config/nvim/init.lua'
alias nvf='nv ~/.config/nvim'

# Zshの設定を開く (.config/zsh/.zshrc)
alias zshconfig='nv $ZDOTDIR/.zshrc'
# Zshの設定を再読み込みする
alias sz='source $ZDOTDIR/.zshrc'

# ------------------------------------------------------------------------------
# 6. 便利な関数 (Functions)
# ------------------------------------------------------------------------------
# pecoを使った履歴検索 (Ctrl + R)
# 過去のコマンドをインクリメンタルサーチで選択・入力できる
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# ------------------------------------------------------------------------------
# 7. プロンプト設定 (Prompt)
# ------------------------------------------------------------------------------
# ※ 将来的に 'Starship' を導入する場合は、ここ以下を全て削除し
#    eval "$(starship init zsh)" の1行に置き換えてください。

export CLICOLOR=1
autoload -Uz compinit && compinit -d "$ZDOTDIR/.zcompdump"

# 左側のプロンプト定義 (ユーザー名、パスなど)
function left-prompt {
  local name_t='255m%}'
  local name_b='246m%}'
  local path_t='255m%}'
  local path_b='240m%}'
  local arrow='087m%}'
  local text_color='%{\e[38;5;'
  local back_color='%{\e[30;48;5;'
  local reset='%{\e[0m%}'
  local sharp='\uE0B0'
  
  local user="${back_color}${name_b}${text_color}${name_t}"
  local dir="${back_color}${path_b}${text_color}${path_t}"
  echo "${user} %n@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp} ${reset}\n${text_color}${arrow}→ ${reset}"
}

PROMPT=`left-prompt` 

# コマンド実行ごとに改行を入れる (見やすくする)
function precmd() {
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}

# 右側のプロンプト定義 (Gitブランチ情報)
# Gitリポジトリ内にいる時だけ、ブランチ名とステータスを表示する
function rprompt-git-current-branch {
  local branch_name st branch_status
  local branch='\ue0a0'
  local color='%{\e[38;5;'
  local green='114m%}'
  local red='001m%}'
  local yellow='227m%}'
  local blue='033m%}'
  local reset='%{\e[0m%}'
  
  if [ ! -e ".git" ]; then
    return
  fi
  
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch_status="${color}${green}${branch} "
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="${color}${red}${branch} ?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="${color}${red}${branch} +"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="${color}${yellow}${branch} !"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo "${color}${red}${branch} !(no branch)${reset}"
    return
  else
    branch_status="${color}${blue}${branch} "
  fi
  
  echo "${branch_status}$branch_name${reset}"
}

setopt prompt_subst
RPROMPT='`rprompt-git-current-branch`'
