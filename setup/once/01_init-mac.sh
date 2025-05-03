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
