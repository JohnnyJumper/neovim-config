return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
	},
	config = function()
		local function getFilePath()
			return vim.fn.expand("%:p")
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_c = {
					"%=",
					{ getFilePath },
				},
				lualine_x = {
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
					},
				},
				lualine_y = {
					{ require("recorder").displaySlots },
				},
				lualine_z = {
					{ "%p%%/%L", separator = { right = "" }, left_padding = 2 },
					{ require("recorder").recordingStatus },
				},
			},
		})
	end,
}
