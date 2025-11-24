# ==============================================================================
#  Zsh Configuration (XDG準拠 & Dotfiles管理)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. プラグインマネージャ (zplug)
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# 2. 基本設定 (Basic Settings)
# ------------------------------------------------------------------------------
setopt interactive_comments  # コマンドラインで '#' 以降をコメントとして扱う
setopt no_beep               # ビープ音を鳴らさない
setopt print_eight_bit       # 日本語ファイル名を表示可能にする
setopt correct               # コマンドのスペルミスを指摘
setopt auto_cd               # ディレクトリ名だけで移動
autoload -Uz colors          # 色を使用出来るようにする
export TERM=xterm-256color   # 256色表示

# 【移動】補完機能を有効化 (Starship導入に伴いここに移動)
autoload -Uz compinit && compinit -d "$ZDOTDIR/.zcompdump"

# ------------------------------------------------------------------------------
# 3. 環境変数 (Environment Variables)
# ------------------------------------------------------------------------------
export LANG=ja_JP.UTF-8

# Nodebrew
export PATH="$HOME/.nodebrew/current/bin:$PATH"

# Dotfiles Bin
export PATH="$HOME/.dotfiles/bin:$PATH"

# ------------------------------------------------------------------------------
# 4. 履歴・ヒストリ設定 (History)
# ------------------------------------------------------------------------------
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# 履歴ファイルの保存場所 (XDG準拠)
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# ------------------------------------------------------------------------------
# 5. エイリアス (Aliases)
# ------------------------------------------------------------------------------
# Git
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gs='git status'
alias gp='git push'

# Docker / K8s
alias d='docker'
alias dc='docker-compose'
alias k='kubectl'

# Tools
alias t='tmux'
alias nv='nvim'
alias ondo='istats all'

# Config Edit
alias ed='nv ~/.config/nvim/init.lua'
alias nvf='nv ~/.config/nvim'
alias zshconfig='nv $ZDOTDIR/.zshrc'
alias sz='source $ZDOTDIR/.zshrc'

# ------------------------------------------------------------------------------
# 6. 便利な関数 (Functions)
# ------------------------------------------------------------------------------
# peco history search (Ctrl + R)
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# ------------------------------------------------------------------------------
# 7. プロンプト設定 (Starship)
# ------------------------------------------------------------------------------
# 【修正】古い設定を全削除し、Starshipの初期化コードのみにしました

# Starshipがインストールされていれば有効化
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    # 未インストールの場合はシンプルなプロンプトを表示 (フォールバック)
    PROMPT="%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ "
fi

# --- Sheldon (Plugin Manager) ---
# sourceだと毎回ファイルを生成して読み込むが、
# eval "$(sheldon source)" はメモリ上で展開するため高速かつクリーン
eval "$(sheldon source)"
