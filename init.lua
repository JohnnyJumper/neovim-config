if vim.g.vscode then
	-- VSCode Neovim
	require("user.vscode_keymaps")
else
	-- Personal Config
	require("johnnyjumper")

	if vim.g.neovide then
		vim.g.neovide_opacity = 1
		vim.g.neovide_normal_opacity = 1
	end
end
