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
				on_open = function(term)
					vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr, noremap = true, silent = true })
				end,
			})

			lazygit:toggle()
		end

		local typecheck_term, eslint_term

		function _dual_term_toggle()
			if typecheck_term and eslint_term and typecheck_term:is_open() and eslint_term:is_open() then
				typecheck_term:close()
				eslint_term:close()
				typecheck_term = nil
				eslint_term = nil
				return
			end

			local cwd = vim.fn.getcwd()

			if not typecheck_term then
				typecheck_term = Terminal:new({
					cmd = "nvm use 22.14.0 && pnpm typecheck",
					dir = cwd,
					hidden = true,
					direction = "horizontal",
					auto_scroll = true,
					close_on_exit = false,
					display_name = "Typecheck",
				})
			end
			typecheck_term:toggle(15, "horizontal")

			vim.cmd("wincmd j")
			if not eslint_term then
				eslint_term = Terminal:new({
					cmd = "nvm use 22.14.0 && pnpm eslint --quiet",
					dir = cwd,
					hidden = true,
					direction = "vertical",
					auto_scroll = true,
					close_on_exit = false,
					display_name = "ESLint",
				})
			end
			eslint_term:toggle(15, "horizontal")
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
