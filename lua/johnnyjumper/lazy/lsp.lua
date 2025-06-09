return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				tsserver_path = "/home/zurzula/.local/share/pnpm/global/5/.pnpm/typescript@5.7.3/node_modules/typescript/bin/tsserver",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"stevearc/conform.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 	cmd = { vim.loop.os_homedir() .. "/typescript-go/built/local/tsgo", "--lsp", "-stdio" },
			-- 	filetypes = {
			-- 		"javascript",
			-- 		"jacascriptreact",
			-- 		"javascript.jsx",
			-- 		"typescript",
			-- 		"typescriptreact",
			-- 		"typescript.tsx",
			-- 	},
			-- 	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			-- })

			-- vim.lsp.enable("ts_go_ls")
			local function custom_publish_diagnostics(_, result, ctx, config)
				if not result.diagnostics then
					return
				end

				-- Filter out diagnostics with the specific ESLint rule
				result.diagnostics = vim.tbl_filter(function(diagnostic)
					return diagnostic.code ~= "@typescript-eslint/no-unused-vars"
				end, result.diagnostics)

				-- Use the default handler to publish the filtered diagnostics
				vim.diagnostic.handlers.default[1](_, result, ctx, config)
			end

			local server_overrides = {
				eslint = function()
					require("lspconfig").eslint.setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							client.handlers["textDocument/publishDiagnostics"] = custom_publish_diagnostics
						end,
					})
				end,
				harper_ls = function()
					require("lspconfig").harper_ls.setup({
						capabilities = capabilities,
						settings = {
							["harper_ls"] = {
								linters = {
									SentenceCapitalization = false,
									ToDoHyphen = false,
								},
							},
						},
					})
				end,
				lua_ls = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
			}

			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					-- "ts_ls",
				},
				handlers = {
					function(server_name)
						local lspconfig = require("lspconfig")
						if server_overrides[server_name] then
							server_overrides[server_name]()
						else
							lspconfig[server_name].setup({
								capabilities = capabilities,
							})
						end
					end,
				},
			})

			local function truncate_message(message, max_length)
				if #message > max_length then
					return message:sub(1, max_length) .. "..."
				end
				return message
			end
			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
				severity_sort = true,
				underline = true,
				signs = true,
				update_in_insert = false,
				virtual_text = {
					severity = { max = "WARN" },
					source = "if_many",
					prefix = "●",
					spacing = 8,
				},
				virtual_lines = {
					current_line = true,
					severity = { min = "ERROR" },
					line_hl_group = "DiagnosticError",
					format = function(diagnostic)
						local max_length = 125
						return "● " .. truncate_message(diagnostic.message, max_length)
					end,
				},
			})
			vim.lsp.set_log_level("OFF")
		end,
	},
}
