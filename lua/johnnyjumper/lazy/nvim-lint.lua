return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")
		local util = require("lspconfig.util")

		local eslint = lint.linters.eslint_d
		if type(eslint) == "function" then
			eslint = eslint()
			lint.linters.eslint_d = eslint
		end

		local ESLINT_CONFIGS = { "eslint.config.mjs", "eslint.config.js", "eslint.config.cjs" }

		local function nearest_eslint_config(fname)
			-- find the directory that contains any eslint.config.*
			local file = nil
			local dir = util.search_ancestors(fname, function(path)
				for _, f in ipairs(ESLINT_CONFIGS) do
					local p = path .. "/" .. f
					if vim.loop.fs_stat(p) then
						file = p
						return true
					end
				end
			end)
			if not dir then
				return nil
			end
			return file
		end

		table.insert(eslint.args, function()
			local cfg = nearest_eslint_config(vim.api.nvim_buf_get_name(0))
			return cfg and ("--config=" .. cfg) or ""
		end)

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
		}

		vim.diagnostic.config({ virtual_text = true })

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
