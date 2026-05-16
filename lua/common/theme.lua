local M = {}

local state_path = vim.fn.stdpath("state") .. "/theme.txt"
local fallback_theme = "sonokai"

local function read_theme()
	local ok, lines = pcall(vim.fn.readfile, state_path)

	if not ok or not lines[1] or lines[1] == "" then
		vim.notify("Failed to read the theme file, falling back to sonokai theme", vim.log.levels.ERROR)
		return fallback_theme
	end

	return lines[1]
end

local function write_theme(theme)
	vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")
	vim.fn.writefile({ theme }, state_path)
end

function M.apply(theme)
	local ok, err = pcall(vim.cmd.colorscheme, theme)

	if not ok then
		vim.notify("Failed to load colorscheme: " .. theme .. "\n" .. err, vim.log.levels.ERROR)
		return
	end

	write_theme(theme)
	vim.notify("Theme applied: " .. theme)
end

function M.load()
	vim.cmd.colorscheme(read_theme())
end

function M.pick()
	local themes = vim.fn.getcompletion("", "color")

	table.sort(themes)

	vim.ui.select(themes, {
		prompt = "Select colorscheme",
	}, function(theme)
		if theme then
			M.apply(theme)
		end
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("ThemeList", function()
		M.pick()
	end, {})

	vim.api.nvim_create_user_command("ThemeSet", function(opts)
		M.apply(opts.args)
	end, {
		nargs = 1,
		complete = function()
			return vim.fn.getcompletion("", "color")
		end,
	})

	vim.api.nvim_create_user_command("ThemeCurrent", function()
		vim.notify("Current theme: " .. (vim.g.colors_name or "none"))
	end, {})
end

return M
