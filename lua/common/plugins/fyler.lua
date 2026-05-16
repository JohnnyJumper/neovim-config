return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	lazy = false,

	opts = {

		hooks = {
			on_delete = function(path)
				vim.notify("Deleted: " .. path)
			end,

			on_rename = function(src, dst)
				vim.notify("Renamed: " .. src .. " -> " .. dst)
			end,
		},

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

				icon = {
					directory_collapsed = "",
					directory_expanded = "",
					directory_empty = "",
				},

				indentscope = {
					enabled = true,
					markers = {
						{ "│", "FylerIndentMarker" },
						{ "└", "FylerIndentMarker" },
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

				-- Fyler preserves the finder instance per directory/tab.
				-- Reset the internal file tree before reopening so it starts fresh.
				local finder = require("fyler.views.finder").instance(dir)
				finder:change_root(dir)

				require("fyler").open({
					dir = dir,
					kind = "float",
				})
			end,
			desc = "Open Fyler",
		},
	},
}
