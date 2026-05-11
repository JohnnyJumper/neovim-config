return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"amansingh-afk/milli.nvim",
	},
	config = function()
		vim.opt.termguicolors = true

		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local milli = require("milli")

		local splash_name = "dancer"
		local splash = milli.load({ splash = splash_name })

		local plugin_count = #require("lazy").plugins()
		local datetime = os.date("%x %H:%M:%S")
		local version = vim.version().build

		-- Important:
		-- Alpha must render the first frame first.
		-- milli.nvim then finds this frame and animates over it.
		dashboard.section.header.val = splash.frames[1]

		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			dashboard.button(
				"s",
				"  > Settings",
				":e $HOME/.config/nvim/lua/johnnyjumper/init.lua | :cd %:p:h | pwd<CR>"
			),
			dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),

			{
				type = "text",
				val = " ------------------- Projects --------------------",
				opts = { position = "center" },
			},
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
