return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	lazy = false,

	opts = {
		integrations = {
			icon = "mini_icons",
		},

		views = {
			finder = {
				close_on_select = true,
				confirm_simple = true,
				default_explorer = true,
				delete_to_trash = false,
				follow_current_file = true,

				watcher = {
					enabled = true,
				},

				columns_order = {
					"permission",
					"size",
					"git",
					"diagnostic",
					"link",
				},

				columns = {
					permission = {
						enabled = true,
					},

					size = {
						enabled = true,
					},

					link = {
						enabled = true,
					},

					git = {
						enabled = true,
						symbols = {
							Untracked = "",
							Added = "",
							Modified = "",
							Deleted = "",
							Renamed = "",
							Copied = "",
							Conflict = "",
							Ignored = "◌",
						},
					},

					diagnostic = {
						enabled = true,
						symbols = {
							Error = "",
							Warn = "",
							Info = "",
							Hint = "󰌵",
						},
					},
				},

				mappings = {
					["q"] = "CloseView",
					["<CR>"] = "Select",
					["<C-t>"] = "SelectTab",
					["|"] = "SelectVSplit",
					["-"] = "GotoParent",
					["="] = "GotoCwd",
					["."] = "GotoNode",
					["#"] = "CollapseAll",
					["<BS>"] = "CollapseNode",
				},

				win = {
					kind = "float",
					border = "rounded",

					kinds = {
						float = {
							width = "80%",
							height = "75%",
							left = "10%",
							top = "10%",
						},
					},
				},
			},
		},
	},

	keys = {
		{
			"-",
			function()
				local bufname = vim.api.nvim_buf_get_name(0)
				local dir = vim.uv.cwd()

				if bufname ~= "" then
					if vim.fn.isdirectory(bufname) == 1 then
						dir = bufname
					elseif vim.fn.filereadable(bufname) == 1 then
						dir = vim.fs.dirname(bufname)
					end
				end

				require("fyler").open({
					dir = dir,
					kind = "float",
				})
			end,
			desc = "Open Fyler",
		},
	},
}
