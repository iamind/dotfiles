-- ==========================================================================
--  plugins/lspconfig.lua - LSP設定（Neovim 0.11 向け）
--  - require('lspconfig').<server>.setup(...) は使用しない
--  - vim.lsp.config / vim.lsp.enable を使用
-- ==========================================================================

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- フォーマット保存用 autocommand グループ
		local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })

		local function enable_format_on_save(_, bufnr)
			vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup_format,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end

		-- LSP アタッチ時の共通キーマップ設定
		local function on_attach(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			vim.keymap.set(
				"n",
				"gD",
				vim.lsp.buf.declaration,
				vim.tbl_extend("force", opts, { desc = "Go to declaration" })
			)

			vim.keymap.set(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				vim.tbl_extend("force", opts, { desc = "Go to implementation" })
			)
		end

		-- LSP 用の capabilities（nvim-cmp 連携）
		local capabilities = nil
		do
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end
		end

		------------------------------------------------------------------------
		-- 1. 共通設定（すべての LSP に適用）
		------------------------------------------------------------------------
		local common = {
			on_attach = on_attach,
		}
		if capabilities ~= nil then
			common.capabilities = capabilities
		end

		-- "*" で全サーバーに共通設定をマージ
		-- 参考: :help vim.lsp.config() / nvim-lspconfig README
		vim.lsp.config("*", common)

		------------------------------------------------------------------------
		-- 2. サーバーごとの上書き・追加設定
		------------------------------------------------------------------------

		-- Python: pyright
		vim.lsp.config("pyright", {
			-- 共通設定に on_attach / capabilities はすでに含まれている
		})

		-- Lua: lua-language-server
		vim.lsp.config("lua_ls", {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				enable_format_on_save(client, bufnr)
			end,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		})

		-- YAML: yamlls
		vim.lsp.config("yamlls", {})

		-- JSON: jsonls
		vim.lsp.config("jsonls", {})

		-- Terraform: terraformls
		vim.lsp.config("terraformls", {})

		-- Markdown: marksman
		vim.lsp.config("marksman", {})

		-- Dockerfile: dockerls
		vim.lsp.config("dockerls", {})

		-- JavaScript/TypeScript: ts_ls
		vim.lsp.config("ts_ls", {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				enable_format_on_save(client, bufnr)
			end,
		})

		------------------------------------------------------------------------
		-- 3. サーバーを有効化
		--    参考: nvim-lspconfig README の Migration / Quickstart
		------------------------------------------------------------------------
		vim.lsp.enable({
			"pyright",
			"lua_ls",
			"yamlls",
			"jsonls",
			"terraformls",
			"marksman",
			"dockerls",
			"ts_ls",
		})

		------------------------------------------------------------------------
		-- 4. Diagnostic 表示設定
		------------------------------------------------------------------------
		vim.diagnostic.config({
			underline = true,
			update_in_insert = true,
			virtual_text = { spacing = 4, prefix = "●" },
			severity_sort = true,
			float = { source = true },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN]  = " ",
					[vim.diagnostic.severity.HINT]  = " ",
					[vim.diagnostic.severity.INFO]  = " ",
				},
			},
		})
	end,
}
