#!/bin/zsh

# ---------------------------------------
# dotfileセットアップ
# ---------------------------------------
set -e

# 変更して使う ▼
DOTFILES_REPO="git@github.com:iamind/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
LINK_TARGETS=(
  .zshrc
  .tmux.conf
)

echo "==> Cloning dotfiles repository..."
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "   dotfiles repo already exists, pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

echo "==> Creating symbolic links..."
for file in "${LINK_TARGETS[@]}"; do
  src="$DOTFILES_DIR/$file"
  dst="$HOME/$file"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    ts=$(date +%Y%m%d%H%M%S); mv "$dst" "${dst}.${ts}.bak"
    echo "   Backed up existing $dst -> ${dst}.bak"
  fi
  ln -snf "$src" "$dst"
  echo "   Linked $dst -> $src"
done

echo "✅ dotfiles setup complete."

exec "$SHELL" -l
