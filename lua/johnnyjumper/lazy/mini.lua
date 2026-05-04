return {
	{
		"nvim-focus/focus.nvim",
		version = false,
		config = function()
			require("focus").setup({
				enable = true, -- Enable module
				commands = true, -- Create Focus commands
				autoresize = {
					enable = true, -- Enable or disable auto-resizing of splits
					width = 0, -- Force width for the focused window
					height = 0, -- Force height for the focused window
					minwidth = 0, -- Force minimum width for the unfocused window
					minheight = 0, -- Force minimum height for the unfocused window
					focusedwindow_minwidth = 0, --Force minimum width for the focused window
					focusedwindow_minheight = 0, --Force minimum height for the focused window
					height_quickfix = 10, -- Set the height of quickfix panel
				},
				split = {
					bufnew = false, -- Create blank buffer for new split windows
					tmux = false, -- Create tmux splits instead of Neovim splits
				},
				ui = {
					number = false, -- Display line numbers in the focused window only
					relativenumber = true, -- Display relative line numbers in the focused window only
					hybridnumber = true, -- Display hybrid line numbers in the focused window only
					absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocused windows

					cursorline = true, -- Display a cursorline in the focused window only
					cursorcolumn = false, -- Display cursorcolumn in the focused window only
					colorcolumn = {
						enable = false, -- Display colorcolumn in the focused window only
						list = "+1", -- Set the comma-separated list for the colorcolumn
					},
					signcolumn = true, -- Display signcolumn in the focused window only
					winhighlight = true, -- Auto highlighting for focused/unfocused windows
				},
			})
		end,
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				source = diff.gen_source.none(),
			})
		end,
	},
}
