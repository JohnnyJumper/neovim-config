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
		local float_windblend = vim.g.neovide and 30 or 0
		local finalOpts = vim.tbl_deep_extend("force", opts, { float_opts = { winblend = float_windblend } })
		toggleterm.setup(finalOpts)
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
				start_in_insert = true,
				on_open = function(term)
					vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr, noremap = true, silent = true })
				end,
			})
		end
		-- vim.keymap.set("n", "<leader>g/", lazygit_toggle, { noremap = true, silent = true })

		local function dual_ts_toggle()
			local cwd = vim.fn.getcwd()
			local current_win = vim.api.nvim_get_current_win()
			toggle_term("typecheck", {
				cmd = "pnpm typecheck",
				dir = cwd,
				hidden = true,
				direction = "horizontal",
				auto_scroll = true,
				close_on_exit = false,
				display_name = "Typecheck",
			}, 15, "horizontal")
			vim.cmd("wincmd j")
			toggle_term("eslint", {
				cmd = "pnpm lint",
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
			local test_suffixes = { ".test.ts", ".spec.ts" }

			local function has_test_suffix(name)
				for _, suffix in ipairs(test_suffixes) do
					if name:sub(-#suffix) == suffix then
						return true
					end
				end
				return false
			end

			if has_test_suffix(path) == false then
				path = ""
			end

			local function has_script(script_name)
				local package_json_path = vim.fn.getcwd() .. "/package.json"
				if vim.fn.filereadable(package_json_path) == 0 then
					return false
				end

				local package_json = vim.fn.json_decode(vim.fn.readfile(package_json_path))
				return package_json and package_json.scripts and package_json.scripts[script_name] ~= nil
			end

			local test_cmd
			if has_script("test:vitest") then
				test_cmd = "pnpm test:vitest " .. path
			else
				test_cmd = "pnpm test " .. path
			end

			local current_win = vim.api.nvim_get_current_win()
			toggle_term("spec", {
				cmd = test_cmd,
				dir = vim.fn.getcwd(),
				hidden = true,
				direction = "vertical",
				auto_scroll = true,
				close_on_exit = false,
				display_name = vim.fn.expand("%:t"),
			}, 15, "vertical")
			vim.api.nvim_set_current_win(current_win)
		end
		vim.keymap.set("n", "<leader>tf/", spec_toggle, { noremap = true, silent = true })
	end,
}
