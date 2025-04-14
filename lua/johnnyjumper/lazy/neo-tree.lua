return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- { "3rd/image.nvim", opts = {} }, -- Optional image support in preview window: See `# Preview Mode` for more information
		{
			"s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},

	-- lazy = false, -- neo-tree will lazily load itself
	config = function()
		require("neo-tree").setup({
			close_if_last_window = false,
			enable_git_status = true,
			enable_diagnostics = true,
			popup_border_style = "rounded",
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
			window = {
				mappings = {
					["P"] = {
						"toggle_preview",
						config = {
							use_float = false,
							title = "Neo-tree Preview",
						},
					},
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_by_name = {
						"node_modules",
					},
				},
			},
		})

		vim.keymap.set("n", "<S-e>", "<cmd>Neotree reveal right toggle<CR>")
	end,
}
