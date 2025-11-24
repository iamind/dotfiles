# 1. Zshの設定ファイル読み込み先を変更
export ZDOTDIR="$HOME/.config/zsh"

# 2. セッション履歴の保存先を変更
export SHELL_SESSION_DIR="$HOME/.config/zsh/sessions"

# 3. 【重要】保存先フォルダがなければ自動で作る
if [[ ! -d "$SHELL_SESSION_DIR" ]]; then
  mkdir -p "$SHELL_SESSION_DIR"
fi
