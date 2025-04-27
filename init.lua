if vim.g.vscode then
	-- VSCode Neovim
	require("user.vscode_keymaps")
else
	-- Personal Config
	require("johnnyjumper")

	if vim.g.neovide then
		vim.g.neovide_opacity = 1
		vim.g.neovide_normal_opacity = 1

		vim.g.neovide_cursor_vfx_mode = "torpedo"
		vim.g.neovide_cursor_animation_length = 0.150
		vim.g.neovide_cursor_animate_in_insert_mode = true
		vim.g.neovide_cursor_trail_size = 1.0

		-- terminal colors took from tokyo-night theme
		vim.g.terminal_color_0 = "#a1a1a1"
		vim.g.terminal_color_1 = "#f7768e"
		vim.g.terminal_color_2 = "#73daca"
		vim.g.terminal_color_3 = "#e0af68"
		vim.g.terminal_color_4 = "#7aa2f7"
		vim.g.terminal_color_5 = "#bb9af7"
		vim.g.terminal_color_6 = "#7dcfff"
		vim.g.terminal_color_7 = "#c0caf5"
		vim.g.terminal_color_8 = "#adadad"
		vim.g.terminal_color_9 = "#f7768e"
		vim.g.terminal_color_10 = "#73daca"
		vim.g.terminal_color_11 = "#e0af68"
		vim.g.terminal_color_12 = "#7aa2f7"
		vim.g.terminal_color_13 = "#bb9af7"
		vim.g.terminal_color_14 = "#7DCFFF"
		vim.g.terminal_color_15 = "#C0CaF5"
	end
end
