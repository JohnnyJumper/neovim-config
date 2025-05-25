return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				duration = 150,
				delay = 100,
				style = {
					{ fg = "#ffffab" },
					{ fg = "#c21f30" },
				},
			},
			indent = {
				enable = true,
				chars = {
					"│",
					"¦",
					"┆",
					"┊",
				},
			},
			line_num = {
				enable = true,
				style = {
					{ fg = "#ffffab" },
					{ fg = "#c21f30" },
				},
			},
			blank = {
				enable = true,
			},
		})
	end,
}
