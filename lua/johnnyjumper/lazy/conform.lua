return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				lua = { "stylua" },
				html = { "htmlbeautifier" },
				bash = { "beautysh" },
				yaml = { "yamlfix" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				arduino = { "clang-format" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
			vim.notify("Format is complete")
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
