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

		local state = {}

		local function toggle_term(name, term_opts, size, direction)
			if state[name] and state[name]:is_open() then
				state[name]:close()
				state[name] = nil
				return
			end
			state[name] = state[name] or Terminal:new(term_opts)
			state[name]:toggle(size, direction)
			vim.cmd("stopinsert")
		end

		local function lazygit_toggle()
			toggle_term("lazygit", {
				cmd = "lazygit",
				hidden = true,
				dir = vim.fn.getcwd(),
				direction = "float",
				display_name = "lazygit",
				close_on_exit = true,
				float_opts = opts["float_opts"],
				start_in_insert = true,
				on_open = function(term)
					vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr, noremap = true, silent = true })
				end,
			})
		end
		vim.keymap.set("n", "<leader>g/", lazygit_toggle, { noremap = true, silent = true })

		local function dual_ts_toggle()
			local cwd = vim.fn.getcwd()
			local current_win = vim.api.nvim_get_current_win()
			toggle_term("typecheck", {
				cmd = "nvm use 22.14.0 && pnpm typecheck",
				dir = cwd,
				hidden = true,
				direction = "horizontal",
				auto_scroll = true,
				close_on_exit = false,
				display_name = "Typecheck",
			}, 15, "horizontal")
			vim.cmd("wincmd j")
			toggle_term("eslint", {
				cmd = "nvm use 22.14.0 && pnpm eslint --quiet",
				dir = cwd,
				hidden = true,
				direction = "vertical",
				auto_scroll = true,
				close_on_exit = false,
				display_name = "ESLint",
			}, 15, "horizontal")
			vim.api.nvim_set_current_win(current_win)
			vim.cmd("stopinsert")
		end
		vim.keymap.set("n", "<leader>t/", dual_ts_toggle, { noremap = true, silent = true })

		local function spec_toggle()
			if state["spec"] and state["spec"]:is_open() then
				toggle_term("spec")
				return
			end

			local path = vim.api.nvim_buf_get_name(0)
			if not path:match("%.spec.ts$") then
				vim.notify("Not a .spec.ts file", vim.log.levels.WARN)
				return
			end

			local current_win = vim.api.nvim_get_current_win()
			toggle_term("spec", {
				cmd = "nvm use 22.14.0 && pnpm test:vitest " .. path,
				dir = vim.fn.getcwd(),
				hidden = true,
				direction = "horizontal",
				auto_scroll = true,
				close_on_exit = false,
				display_name = vim.fn.expand("%:t"),
			}, 15, "horizontal")
			vim.api.nvim_set_current_win(current_win)
		end
		vim.keymap.set("n", "<leader>tf/", spec_toggle, { noremap = true, silent = true })
	end,
}
