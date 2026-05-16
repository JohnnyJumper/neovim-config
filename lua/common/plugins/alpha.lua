return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"amansingh-afk/milli.nvim",
		"folke/snacks.nvim",
	},
	config = function()
		vim.opt.termguicolors = true

		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local milli = require("milli")

		local splash_name = "dancerramp"
		local splash = milli.load({ splash = splash_name })

		local plugin_count = #require("lazy").plugins()
		local datetime = os.date("%x %H:%M:%S")
		local version = vim.version().build

		local projects = require("common.project_picker")
		local project_button = {
			type = "button",
			val = "󰉋  > Projects",
			on_press = function()
				projects.pick_project(function(_, path)
					vim.cmd.cd(vim.fn.fnameescape(path))
					vim.notify("cwd: " .. vim.fn.getcwd())
					require("snacks").picker.files({ cwd = path })
				end)
			end,
			opts = {
				position = "center",
				shortcut = "p",
				cursor = 3,
				width = 50,
				align_shortcut = "right",
				hl_shortcut = "Keyword",
			},
		}
		project_button.opts.keymap = {
			"n",
			"p",
			"",
			{
				noremap = true,
				silent = true,
				nowait = true,
				callback = project_button.on_press,
			},
		}

		-- Important:
		-- Alpha must render the first frame first.
		-- milli.nvim then finds this frame and animates over it.
		dashboard.section.header.val = splash.frames[1]

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", "<cmd>ene <BAR> startinsert<CR>"),
			dashboard.button("f", "  > Find file", "<cmd>lua Snacks.picker.files()<CR>"),
			dashboard.button("r", "  > Recent", "<cmd>lua Snacks.picker.recent()<CR>"),
			project_button,
			dashboard.button("s", "  > Settings", "<cmd>e ~/.config/nvim/init.lua | cd %:p:h | pwd<CR>"),
			dashboard.button(
				"c",
				"  > System Config",
				"<cmd>cd ~/.config | lua Snacks.picker.files({ cwd = vim.fn.getcwd() })<CR>"
			),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		dashboard.section.footer.val = {
			" Super Neovim with " .. plugin_count .. " plugins loaded ",
			"      📅 " .. datetime,
			"              " .. version,
		}

		alpha.setup(dashboard.opts)

		-- Start animation after Alpha renders.
		milli.alpha({
			splash = splash_name,
			loop = true,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
			end,
		})

		vim.keymap.set("n", "<leader><leader>h", "<cmd>Alpha<cr>")
	end,
}
