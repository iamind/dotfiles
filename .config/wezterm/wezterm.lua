local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =========================================================
--  Appearance (見た目)
-- =========================================================
-- Neovimとお揃いのカラーテーマ
config.color_scheme = 'Tokyo Night'

-- 先ほど入れたNerd Fontを指定
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 14.0

-- ウィンドウの透明度 (少し透けさせるとかっこいい)
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- ウィンドウの装飾 (Macっぽさを残しつつシンプルに)
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- =========================================================
--  Keys & Behavior (操作)
-- =========================================================
-- 日本語入力の不具合防止 (Mac用)
config.send_composed_key_when_left_alt_is_pressed = true
config.use_ime = true

-- OptionキーをMetaキーとして扱う (Neovimでのキーバインド用)
config.macos_option_as_alt = 'Both'

return config 
