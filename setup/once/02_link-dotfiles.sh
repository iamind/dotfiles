#!/bin/zsh

# ==============================================================================
# Dotfiles セットアップスクリプト (XDG準拠・完全版)
# ==============================================================================
set -e

# ✅ 修正箇所: あなたの実際のパスに合わせました
DOTFILES_DIR="$HOME/.dotfiles"

# リンク対象リスト
# ここに書かれたパス構成が、そのままリポジトリ内にある必要があります
LINK_TARGETS=(
  .zshenv               # Zshの案内看板 (ホーム直下)
  .config/nvim          # Neovim
  .config/wezterm       # WezTerm
  .config/tmux          # Tmux
  .config/zsh           # Zsh本体
  .config/sheldon       # Sheldon (ディレクトリごとリンク)
  .config/starship.toml # Starship設定 (ファイル単体)
)

echo "==> 🚀 Starting Dotfiles Setup..."
echo "    Target Repository: $DOTFILES_DIR"

# リポジトリの存在チェック
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "❌ Error: Directory $DOTFILES_DIR does not exist."
  echo "    Please run: git clone <your-repo-url> $DOTFILES_DIR"
  exit 1
fi

echo "\n==> 🔗 Creating symbolic links..."

for file in "${LINK_TARGETS[@]}"; do
  # リポジトリ内のソースパス
  src="$DOTFILES_DIR/$file"

  # ソースが存在しない場合は警告を出してスキップ (エラーで止めない)
  if [[ ! -e "$src" ]]; then
    echo "    ⚠️  Warning: Source not found, skipping... ($src)"
    continue
  fi

  # ---------------------------------------------------
  # リンク先の決定ロジック
  # ---------------------------------------------------
  if [[ "$file" == .config/* ]]; then
    # .config 以下のものは ~/.config/ にそのまま置く
    target_path="$HOME/$file"
  else
    # それ以外 (.zshenv など) はホーム直下へ
    target_path="$HOME/$(basename "$file")"
  fi

  # ---------------------------------------------------
  # リンク作成処理
  # ---------------------------------------------------
  # 親ディレクトリ作成
  mkdir -p "$(dirname "$target_path")"

  # Check: 既に正しいリンクならスキップ
  if [[ -L "$target_path" ]]; then
    current_link=$(readlink "$target_path")
    if [[ "$current_link" == "$src" ]]; then
      echo "    ⏩ Skip: $target_path is already linked correctly."
      continue
    fi
  fi

  # Backup: 実体ファイルがあれば退避
  if [[ -e "$target_path" && ! -L "$target_path" ]]; then
    ts=$(date +%Y%m%d%H%M%S)
    backup_path="${target_path}.${ts}.bak"
    mv "$target_path" "$backup_path"
    echo "    📦 Backed up existing file: $backup_path"
  fi

  # Link: シンボリックリンクを作成 (上書き強制 -snf)
  ln -snf "$src" "$target_path"
  echo "    ✅ Linked: $target_path -> $src"
done

echo "\n✨ Dotfiles setup complete!"
