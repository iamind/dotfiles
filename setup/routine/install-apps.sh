#!/bin/zsh
set -euo pipefail

echo "🔧 mac-setup-3: アプリケーションのインストールを開始します"

# --------------------------------------------------
# 1. Rosetta 2（Apple Silicon のみ）
# --------------------------------------------------
if [[ "$(uname -m)" == "arm64" ]]; then
  if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
    echo "🚀 Rosetta 2 をインストール中..."
    sudo softwareupdate --install-rosetta --agree-to-license
  else
    echo "✅ Rosetta 2 は既にインストール済みです（スキップ）"
  fi
fi

# --------------------------------------------------
# 2. Homebrew
# --------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew をインストール中..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew は既にインストール済みです（スキップ）"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
grep -qxF "$BREW_LINE" "$HOME/.zprofile" || echo "$BREW_LINE" >> "$HOME/.zprofile"

brew update -q
brew analytics off   # 📉 匿名統計送信をオフにして通信を抑止

# --------------------------------------------------
# 3. CLI ツール
# --------------------------------------------------
cli_pkgs=(
  git          # Git 本体
  mas          # Mac App Store CLI
)
echo "🛠  CLI ツールをインストール / 更新します..."
brew install "${cli_pkgs[@]}"

# --------------------------------------------------
# 4. GUI アプリ（Homebrew Cask）
# --------------------------------------------------
casks=(
  # --- マネジメント系 ---
  1password

  # --- ブラウザ系 ---
  google-chrome
  arc

  # --- PC 操作系 ---
  raycast
  bettertouchtool

  # --- 学習環境 ---
  anki
  obsidian

  # --- 開発環境 ---
  iterm2
  cursor
  visual-studio-code
  warp
)
echo "📦 GUI アプリをインストール / 更新します..."
brew install --cask "${casks[@]}"

# --------------------------------------------------
# 5. Mac App Store アプリ（mas）
# --------------------------------------------------
mas_apps=(
  462058435  # Excel
  462062816  # PowerPoint
  462054704  # Word
)
echo "🏬 App Store アプリをインストール / 更新します..."
for id in "${mas_apps[@]}"; do
  if ! mas list | grep -q "^$id "; then
    if mas install "$id"; then
      echo "   ✅ インストール完了: $id"
    else
      echo "⚠️  $id のインストールに失敗しました（App Store にサインインしていますか？）"
    fi
  else
    echo "   ⏩ 既にインストール済み: $id"
  fi
done

# --------------------------------------------------
# 🚫 Homebrew 未対応アプリ一覧（コメント専用）
#    ここに名前を追記して備忘録として利用してください
# --------------------------------------------------
# - Claude Desktop


echo "🎉 すべてのアプリが最新の状態になりました！"
