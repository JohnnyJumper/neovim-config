return {
	"bngarren/checkmate.nvim",
	ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
	opts = {
		keys = {
			["<leader>Tt"] = "toggle",
			["<leader>Tc"] = "check",
			["<leader>Tu"] = "unchek",
			["<leader>Tn"] = "create",
			["<leader>TR"] = "remove_all_metadata",
		},
	},
}
