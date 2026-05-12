local M = {}

local ok, projects = pcall(require, "local.projects")

if not ok then
	projects = {}
end

function M.pick_project(on_select)
	local labels = {}

	for label, _ in pairs(projects) do
		table.insert(labels, label)
	end

	table.sort(labels)

	vim.ui.select(labels, {
		prompt = "Projects",
	}, function(label)
		if not label then
			return
		end

		local path = vim.fn.expand(projects[label])
		on_select(label, path)
	end)
end

return M
