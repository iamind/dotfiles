-- md-links.lua
-- Markdown用カスタム機能
-- 1. Float preview (gp)
-- 2. 純粋なリンク作成 (<leader>ml)
-- 3. ファイル切り出し (<leader>mx)

return {
	"nvim-lua/plenary.nvim",
	ft = { "markdown" },
	config = function()
		-----------------------------------------------
		-- Float Preview 機能
		-----------------------------------------------
		local function get_md_link_under_cursor()
			local line = vim.api.nvim_get_current_line()
			local col = vim.api.nvim_win_get_cursor(0)[2] + 1
			local start_pos = 1
			while true do
				local link_start, link_end, text, path = line:find("%[([^%]]*)%]%(([^%)]+)%)", start_pos)
				if not link_start then break end
				if col >= link_start and col <= link_end then return path end
				start_pos = link_end + 1
			end
			return nil
		end

		local function resolve_path(path)
			if not path:match("^/") and not path:match("^~") then
				local current_file = vim.fn.expand("%:p:h")
				path = current_file .. "/" .. path
			end
			path = vim.fn.expand(path)
			path = vim.fn.fnamemodify(path, ":p")
			return path
		end

		local function open_float(filepath)
			local buf = vim.fn.bufnr(filepath, true)
			vim.fn.bufload(buf)

			local width = math.floor(vim.o.columns * 0.7)
			local height = math.floor(vim.o.lines * 0.7)
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)

			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
				title = " " .. vim.fn.fnamemodify(filepath, ":t") .. " ",
				title_pos = "center",
			})

			vim.api.nvim_win_set_option(win, "winblend", 0)
			vim.api.nvim_win_set_option(win, "cursorline", true)

			vim.keymap.set("n", "q", "<CMD>close<CR>", { buffer = buf, silent = true })
			vim.keymap.set("n", "<Esc>", "<CMD>close<CR>", { buffer = buf, silent = true })
		end

		local function follow_md_link_float()
			local path = get_md_link_under_cursor()
			if not path then
				vim.notify("No link under cursor", vim.log.levels.WARN)
				return
			end

			if path:match("^https?://") then
				vim.fn.system({ "open", path })
				vim.notify("Opened in browser: " .. path, vim.log.levels.INFO)
				return
			end

			local filepath = resolve_path(path)
			if vim.fn.filereadable(filepath) == 0 then
				if vim.fn.filereadable(filepath .. ".md") == 1 then
					filepath = filepath .. ".md"
				else
					vim.notify("File not found: " .. filepath, vim.log.levels.WARN)
					return
				end
			end

			open_float(filepath)
		end

		-----------------------------------------------
		-- キーマップ設定
		-----------------------------------------------
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				local opts = { buffer = true, silent = true }

				-- Float preview (gp)
				vim.keymap.set("n", "gp", follow_md_link_float,
					vim.tbl_extend("force", opts, { desc = "Float preview link" }))

				-- 純粋なリンク作成 (<leader>ml)
				vim.keymap.set("v", "<leader>ml", function()
					vim.cmd('normal! "ay')
					local selected = vim.fn.getreg("a")
					if selected == "" then
						vim.notify("No text selected", vim.log.levels.WARN)
						return
					end
					local link = "[" .. selected .. "]()"
					vim.cmd('normal! gv"_c' .. link)
					vim.cmd("startinsert")
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", false)
				end, vim.tbl_extend("force", opts, { desc = "Create markdown link" }))

				-- ファイル切り出し (<leader>mx)
				vim.keymap.set("v", "<leader>mx", function()
					local start_line = vim.fn.line("'<")
					local end_line = vim.fn.line("'>")
					local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
					local selected_text = table.concat(lines, "\n")

					if selected_text == "" then
						vim.notify("No text selected", vim.log.levels.WARN)
						return
					end

					local current_dir = vim.fn.expand("%:p:h")

					vim.ui.input({ prompt = "New file name (without .md): " }, function(filename)
						if not filename or filename == "" then
							vim.notify("Cancelled", vim.log.levels.INFO)
							return
						end

						if not filename:match("%.md$") then
							filename = filename .. ".md"
						end

						local filepath = current_dir .. "/" .. filename

						if vim.fn.filereadable(filepath) == 1 then
							vim.notify("File already exists: " .. filename, vim.log.levels.ERROR)
							return
						end

						local file = io.open(filepath, "w")
						if not file then
							vim.notify("Failed to create file: " .. filepath, vim.log.levels.ERROR)
							return
						end
						file:write(selected_text)
						file:close()

						local title = filename:gsub("%.md$", ""):gsub("-", " ")
						local link = "[" .. title .. "](" .. filename .. ")"

						vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, { link })

						vim.notify("Extracted to: " .. filename, vim.log.levels.INFO)
					end)
				end, vim.tbl_extend("force", opts, { desc = "Extract to file" }))
			end,
		})
	end,
}
