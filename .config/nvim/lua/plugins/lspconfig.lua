return {
	'neovim/nvim-lspconfig',
	config = function()
		-- ================================
		-- 基本設定
		-- ================================
		local status, nvim_lsp = pcall(require, "lspconfig")
		if not status then return end

		local protocol = require('vim.lsp.protocol')

		-- フォーマット保存用 autocommand グループ
		local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
		local enable_format_on_save = function(_, bufnr)
			vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup_format,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end

		-- LSP アタッチ時のキーマップ設定
		local on_attach = function(client, bufnr)
			local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
			local opts = { noremap = true, silent = true }

			buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
			buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		end

		-- 補完アイコン設定
		protocol.CompletionItemKind = {
			'', '', '', '', '', '', '', 'ﰮ', '',
			'', '', '', '', '', '﬌', '', '', '',
			'', '', '', '', '', 'ﬦ', '',
		}

		-- LSP 用の capabilities
		local capabilities = require('cmp_nvim_lsp').default_capabilities()

		-- ================================
		-- 言語ごとの Language Server 設定
		-- ================================

		-- Python: pyright
		nvim_lsp.pyright.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Lua: lua-language-server
		nvim_lsp.lua_ls.setup {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				enable_format_on_save(client, bufnr) -- 保存時にフォーマット
			end,
			settings = {
				Lua = {
					diagnostics = { globals = { 'vim' } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
				},
			},
		}

		-- YAML: yamlls
		nvim_lsp.yamlls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- JSON: jsonls
		nvim_lsp.jsonls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Terraform: terraformls
		nvim_lsp.terraformls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Markdown: marksman
		nvim_lsp.marksman.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Dockerfile: dockerls
		nvim_lsp.dockerls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- ================================
		-- Diagnostic 表示設定
		-- ================================
		vim.diagnostic.config({
			underline = true,
			update_in_insert = true,
			virtual_text = { spacing = 4, prefix = "●" },
			severity_sort = true,
			float = { source = true },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN]  = " ",
					[vim.diagnostic.severity.HINT]  = " ",
					[vim.diagnostic.severity.INFO]  = " ",
				},
			},
		})
	end
}
