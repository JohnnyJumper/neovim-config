return {
	"JohnnyJumper/theme-peeper.nvim",
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
		apply = function(theme)
			require("johnnyjumper.theme").apply(theme)
		end,
	},
}
