
#### mac-setup-1.sh
##### やること
- PC設定
- Github利用前準備
- Gitコマンドセットアップ
##### 実行要件
- 新PC初回起動1発目に実行してもエラーなく実行できること
- このスクリプトは初回1度のみの運用とすること(内容的に初期設定のみなので)
```zsh
#!/bin/zsh

# ---------------------------------------
# PC設定
# ---------------------------------------

# キーボードの反応速度の修正(PC再起動後に有効化される)
defaults write -g InitialKeyRepeat -int 11
defaults write -g KeyRepeat -int 1

# ---------------------------------------
# Github利用前準備
# ---------------------------------------

set -e

mkdir -p ~/.ssh
chmod 700 ~/.ssh

KEY_NAME="id_ed25519"

echo "==> Generating SSH key: $KEY_NAME"
ssh-keygen -t ed25519 -f ~/.ssh/$KEY_NAME   # 対話でパスフレーズを入力
chmod 400 ~/.ssh/$KEY_NAME
eval "$(ssh-agent -s)"

# macOS Keychain にSSH鍵を保存（再起動後も自動ロード）
ssh-add --apple-use-keychain ~/.ssh/$KEY_NAME

cat > ~/.ssh/config <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/$KEY_NAME
  # AddKeysToAgent yes
  # ↑ macOSでは ssh-add -K でKeychainに保存済みのため不要。
  #    Linuxなど他OSで config ファイルによる自動登録が必要な場合のみ有効化。
EOF

chmod 600 ~/.ssh/config

# --- 公開鍵を表示 ---
echo "==> 以下の公開鍵を GitHub に登録してください"
cat ~/.ssh/${KEY_NAME}.pub
echo "==> 手動でGitHubに公開鍵登録してください"
# pbcopy < ~/.ssh/${KEY_NAME}.pub

# ---------------------------------------
# Gitコマンドセットアップ
# ---------------------------------------

echo "==> Checking git command ..."

if ! command -v git &>/dev/null; then
  echo "⚠️  git が見つかりません。Xcode Command Line Tools をインストールします。"
  if ! xcode-select -p &>/dev/null; then
    echo "   macOS のダイアログが表示されたら『インストール』をクリックしてください。"
    xcode-select --install
    # インストール完了まで待機（最大 15 分 / Ctrl‑C で中断可）
    echo -n "   インストール完了を待機中"
    for i in {1..90}; do               # 90 × 10s = 15 分
      if xcode-select -p &>/dev/null; then break; fi
      printf "."; sleep 10
    done
    echo
  fi
fi

# git が使えるか最終確認
if command -v git &>/dev/null; then
  echo "✅ git を検出: $(git --version)"
else
  echo "❌ git が見つかりませんでした。Xcode CLT インストールを再確認してください。" >&2
  exit 1
fi

echo "🎉 スクリプト完了 — 次のステップへ進んでください。"
```

#### mac-setup-2.sh
##### やること
- dotfileセットアップ
##### 実行要件
- 新PC初回起動1発目『mac-setup-1.sh』実行後に本スクリプトを実行してもエラーが起きないこと
- このスクリプトは初回1度のみの運用としたいが、dotfileに更新があった場合は本スクリプトをメンテナンスして再実行を行うケースもある
```zsh
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
```

#### mac-setup-3.sh
##### やること
- アプリケーションインストール
##### 実行要件
- 新PC初回起動1発目『mac-setup-1.sh』『mac-setup-2.sh』実行後に本スクリプトを実行してもエラーが起きないこと
- このスクリプトは初回1度の実行と都度必要なアプリがあったらこのスクリプトを使って追加していく想定のためかなりの頻度で利用する。
- 冪等性を担保したい
- cliツールもこのスクリプトで管理したい
```zsh
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
  arc                   # Arc ブラウザ

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

```
