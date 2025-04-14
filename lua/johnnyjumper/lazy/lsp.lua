return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		require("mason").setup()
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"ts_ls",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
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
				["harper_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.harper_ls.setup({
						capabilities = capabilities,
						settings = {
							["harper-ls"] = {
								linters = {
									SentenceCapitalization = false,
									TodoHyphen = false,
								},
							},
						},
					})
				end,
			},
		})

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
		})
	end,
}
