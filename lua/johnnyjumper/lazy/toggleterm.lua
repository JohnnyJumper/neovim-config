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
		function _lazygit_toggle()
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true,
				dir = vim.fn.getcwd(),
				direction = "float",
				display_name = "lazygit",
				float_opts = opts["float_opts"],
			})

			lazygit:toggle()
		end

		function _dual_term_toggle()
			local cwd = vim.fn.getcwd()

			local tc = Terminal:new({
				cmd = "pnpm typecheck",
				dir = cwd,
				hidden = true,
				direction = "horizontal",
				auto_scroll = true,
				close_on_exit = false,
				display_name = "Typecheck",
			})
			tc:toggle(15, "horizontal")

			vim.cmd("wincmd j")
			local es = Terminal:new({
				cmd = "pnpm eslint --quiet",
				dir = cwd,
				hidden = true,
				direction = "vertical",
				auto_scroll = true,
				close_on_exit = false,
				display_name = "ESLint",
			})
			es:toggle(15, "horizontal")
			vim.cmd("wincmd k")
		end

		vim.api.nvim_set_keymap("n", "<leader>g/", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>t/",
			"<cmd> lua _dual_term_toggle()<cr>",
			{ noremap = true, silent = true }
		)
	end,
}
