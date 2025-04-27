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
							use_float = true,
							title = "Neo-tree Preview",
						},
					},
					["oa"] = "avante_add_files",
					["s"] = false,
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_by_name = {
						"node_modules",
					},
				},
				commands = {
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = require("avante.utils").relative_path(filepath)

						local sidebar = require("avante").get()

						local open = sidebar:is_open()
						-- ensure avante sidebar is open
						if not open then
							require("avante.api").ask()
							sidebar = require("avante").get()
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- remove neo tree buffer
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
				},
			},
		})

		vim.keymap.set("n", "<S-e>", "<cmd>Neotree reveal right toggle<CR>")
	end,
}
