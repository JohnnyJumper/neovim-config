return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		enabled = false,
		opts = {
			settings = {
				-- tsserver_path = "/home/zurzula/.local/share/pnpm/global/5/.pnpm/typescript@5.9.2/node_modules/typescript/bin/tsserver",
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
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

			vim.lsp.config("ts_go_ls", {
				cmd = { "tsgo", "--lsp", "-stdio" },
				capabilities = capabilities,
				filetypes = {
					"javascript",
					"jacascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			})

			vim.lsp.enable("ts_go_ls")

			local server_overrides = {
				eslint = {
					capabilities = capabilities,
					settings = {
						workingDirectories = { mode = "auto" },
						experimental = { useFlatConfig = true },
					},
				},
				harper_ls = {
					capabilities = capabilities,
					settings = {
						["harper_ls"] = {
							linters = {
								SentenceCapitalization = false,
								ToDoHyphen = false,
							},
						},
					},
				},
				lua_ls = {
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using (most
								-- likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
								-- Tell the language server how to find Lua modules same way as Neovim
								-- (see `:h lua-module-load`)
								path = {
									"lua/?.lua",
									"lua/?/init.lua",
								},
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths
									-- here.
									-- '${3rd}/luv/library'
									-- '${3rd}/busted/library'
								},
							},
						})
					end,

					capabilities = capabilities,
					settings = {
						Lua = {},
					},
				},

				arduino_language_server = {
					cmd = {
						"arduino-language-server",
						"-cli",
						"/home/zurzula/.local/bin/arduino-cli",
						"-clangd",
						"/home/zurzula/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd",
						"-cli-config",
						"$HOME/.arduino15/arduino-cli.yaml",
						"-fqbn",
						"esp32:esp32:esp32cam",
					},
					capabilities = capabilities,
				},
				-- lspconfig.clangd.setup(require("esp32").lsp_config())
			}

			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"harper_ls",
					"arduino_language_server",
				},
				handlers = {
					function(server_name)
						if server_overrides[server_name] then
							vim.lsp.config(server_name, server_overrides[server_name])
						else
							vim.lsp.config(server_name, { capabilities = capabilities })
						end
						vim.lsp.enable(server_name)
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
				signs = false,
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
			vim.lsp.set_log_level("DEBUG")
		end,
	},
}
