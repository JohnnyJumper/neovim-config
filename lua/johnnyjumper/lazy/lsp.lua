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
			vim.lsp.enable("ts_go_ls")

			local function exists(p)
				return vim.uv.fs_stat(p) ~= nil
			end
			local function home_join(rel)
				return (vim.env.HOME or "~") .. "/" .. rel
			end

			local servers = {
				ts_go_ls = {
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
					settings = { preferences = { maximumHoverLength = "800" } },
					enable = true,
				},
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
						["harper-ls"] = {
							linters = {
								SentenceCapitalization = false,
								ToDoHyphen = false,
							},
						},
					},
				},
				lua_ls = {
					on_init = function(client)
						local wf = client.workspace_folders
						if not wf or not wf[1] then
							return
						end
						local root = wf[1].name

						if
							root ~= vim.fn.stdpath("config")
							and (exists(root .. "/.luarc.json") or exists(root .. "/.luarc.jsonc"))
						then
							return
						end
						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
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
						home_join(".local/bin/arduino-cli"),
						"-clangd",
						home_join(".espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd"),
						"-cli-config",
						home_join(".arduino15/arduino-cli.yaml"),
						"-fqbn",
						"esp32:esp32:esp32cam",
					},
					capabilities = capabilities,
				},
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
			})

			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
				if config.enable then
					vim.lsp.enable(server_name)
				end
			end

			local function trunc(s, n)
				return (#s > n) and (s:sub(1, n) .. "...") or s
			end

			vim.diagnostic.config({
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
						return "● " .. trunc(diagnostic.message, max_length)
					end,
				},
			})
			vim.lsp.set_log_level("OFF")
		end,
	},
}
