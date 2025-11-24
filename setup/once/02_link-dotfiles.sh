#!/bin/zsh

# ==============================================================================
# Dotfiles セットアップスクリプト (XDG準拠・完全版)
# ==============================================================================
set -e

DOTFILES_REPO="git@github.com:iamind/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# リンク対象リスト
# .config 内のファイル・ディレクトリもそのまま記述します
LINK_TARGETS=(
  .zshenv               # Zshの案内看板 (ホーム直下)
  .config/nvim          # Neovim (ディレクトリ)
  .config/wezterm       # WezTerm (ディレクトリ)
  .config/tmux          # Tmux (ディレクトリ)
  .config/zsh           # Zsh本体 (ディレクトリ)
  .config/starship.toml # Starship設定 (ファイル単体)
)

echo "==> 📦 Preparing dotfiles repository..."

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  echo "    Repository not found. Cloning..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "    Repository exists. Pulling latest changes..."
  # git -C "$DOTFILES_DIR" pull --ff-only || echo "    (Skipped pull due to local changes)"
fi

echo "\n==> 🔗 Creating symbolic links..."

for file in "${LINK_TARGETS[@]}"; do
  src="$DOTFILES_DIR/$file"
  
  # ---------------------------------------------------
  # リンク先の決定ロジック
  # ---------------------------------------------------
  if [[ "$file" == .config/* ]]; then
    # .config 以下のものは ~/.config/ にそのまま置く (XDG準拠)
    target_path="$HOME/$file"
  else
    # それ以外 (.zshenv など) はホーム直下へ
    target_path="$HOME/$(basename "$file")"
  fi

  # ---------------------------------------------------
  # リンク作成処理
  # ---------------------------------------------------
  # 親ディレクトリ作成 (例: ~/.config がなければ作る)
  mkdir -p "$(dirname "$target_path")"

  # Check: 既に正しいリンクならスキップ
  if [[ -L "$target_path" ]]; then
    current_link=$(readlink "$target_path")
    if [[ "$current_link" == "$src" ]]; then
      echo "    ⏩ Skip: $target_path is already linked correctly."
      continue
    fi
  fi

  # Backup: 実体ファイル（やディレクトリ）があれば退避
  if [[ -e "$target_path" ]]; then
    # リンク先が既にシンボリックリンクの場合は、上書きするためバックアップしない（削除する）
    if [[ ! -L "$target_path" ]]; then
      ts=$(date +%Y%m%d%H%M%S)
      backup_path="${target_path}.${ts}.bak"
      mv "$target_path" "$backup_path"
      echo "    📦 Backed up existing file/dir: $backup_path"
    fi
  fi
  
  # Link: シンボリックリンクを作成 (上書き強制 -snf)
  ln -snf "$src" "$target_path"
  echo "    ✅ Linked: $target_path -> $src"
done

echo "\n✨ Dotfiles setup complete!"
