return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 20,
		open_mapping = [[<c-/>]],
		hide_numbers = true,
		shade_terminals = true,
		shading_factor = 2,
		insert_mappings = true,
		start_in_insert = true,
		direction = "float",
		float_opts = {
			border = "curved",
			winblend = 30,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
		highlights = {
			Normal = { link = "ToggleTermNormal" },
			NormalFloat = { link = "ToggleTermNormalFloat" },
			FloatBorder = { link = "ToggleTermFloatBorder" },
		},
		on_create = function()
			vim.cmd([[ setlocal signcolumn=no ]])
		end,
		winbar = { enabled = false },
	},
	config = function(_, opts)
		local toggleterm = require("toggleterm")
		toggleterm.setup(opts)

		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			dir = vim.uv.cwd(),
			direction = "float",
			display_name = "lazygit",
			float_opts = opts["float_opts"],
		})
		function _lazygit_toggle()
			lazygit:toggle()
		end
		vim.api.nvim_set_keymap("n", "<leader>g/", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })
	end,
}
