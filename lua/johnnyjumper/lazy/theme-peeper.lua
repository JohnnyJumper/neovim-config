return {
	-- "JohnnyJumper/theme-peeper",
	dir = vim.fn.expand("~/projects/theme-peeper.nvim"),
	name = "theme-peeper.nvim",
	lazy = false,
	dependencies = {
		{
			"folke/snacks.nvim",
			opts = {
				picker = {},
			},
		},
	},
	keys = {
		{
			"<leader>te",
			function()
				require("theme_peeper").select()
			end,
			desc = "Theme peeper",
		},
	},
	opts = {
		picker = "snacks",
		previewer = "float",

		persist = true,

		preview = {
			profile = "code",
			max_height = 24,
			border = "rounded",
			placement = "center",
		},

		pickers = {
			snacks = {
				width = 56,
				max_height = 12,
				preview_width = 80,
				preview_max_height = 24,
			},
		},
	},
}
