function _G.jqit()
	local width = 80
	local height = 20

	vim.cmd('normal! "zy') -- yank the selection into z registry

	local json = vim.fn.getreg("z")
	if not json or json == "" then
		return
	end
	local lines = vim.split(json, "\n", { trimempty = true })

	if #lines == 0 then
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local ui = vim.api.nvim_list_uis()[1]

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((ui.width / 2) - (width / 2)),
		row = math.floor((ui.height / 2) - (height / 2)),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local closingKeys = { "<Esc>" }

	for _, key in ipairs(closingKeys) do
		vim.api.nvim_buf_set_keymap(buf, "n", key, ":close<CR>", { silent = true, nowait = true, noremap = true })
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_set_current_win(win)
	vim.cmd("%!jq")
end

vim.api.nvim_create_user_command("Jqit", jqit, { range = true })
