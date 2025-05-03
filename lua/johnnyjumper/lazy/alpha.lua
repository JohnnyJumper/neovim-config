return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local plugin_count = #require("lazy").plugins()
		local datetime = os.date("%x %H:%M:%S")
		local version = vim.version().build

		dashboard.section.header.val = {
			"                                                      ",
			"      ███████╗██╗   ██╗██████╗ ███████╗██████╗        ",
			"      ██╔════╝██║   ██║██╔══██╗██╔════╝██╔══██╗       ",
			"      ███████╗██║   ██║██████╔╝█████╗  ██████╔╝       ",
			"      ╚════██║██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗       ",
			"      ███████║╚██████╔╝██║     ███████╗██║  ██║       ",
			"      ╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝       ",
			"                                                      ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
			"                                                      ",
		}
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
		vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
    ]])

		vim.keymap.set("n", "<leader><leader>h", "<cmd>Alpha<cr>")
	end,
}
