local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- =========================================================
--  Appearance (見た目)
-- =========================================================
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 18.0

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

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
-- 【重要】ここを修正しました
-- OptionキーをMeta(Alt)キーとして認識させる設定
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- 日本語入力(IME)を有効化
config.use_ime = true

return config
