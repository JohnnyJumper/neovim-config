return {
	{
		"rcarriga/nvim-notify",
		opts = {
			merge_duplicates = false,
			top_down = false,
			render = "minimal",
			timeout = 1200,
		},
		config = function(_, opts)
			local actual_stage = vim.g.neovide and "slide" or "static"
			local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
			vim.print(actual_stage)
			vim.tbl_deep_extend("force", opts, {
				stages = actual_stage,
				background_colour = bg_color and string.format("#%06x", bg_color) or "#000000",
			})
			require("notify").setup(opts)
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
					require("notify").setup({
						background_colour = bg and string.format("#%06x", bg) or "#000000",
					})
				end,
			})
			vim.notify = require("notify")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				views = {
					cmdline_popup = {
						position = {
							row = 15,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},

					signature = {
						enabled = true,
					},
					messages = {
						enabled = true,
						view = "notify",
						view_error = "notify",
						view_warn = "notify",
						view_history = "split",
						view_search = "virtualtext",
					},
				},
				popupmenu = {
					enabled = true,
					backend = "nui",
				},
				cmdline = {
					enabled = true,
					view = "cmdline_popup",
				},
				notify = {
					enabled = true,
					view = "notify",
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},
}
