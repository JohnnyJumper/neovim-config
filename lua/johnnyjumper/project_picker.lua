local M = {}

local ok, projects = pcall(require, "local.projects")

if not ok then
	projects = {}
end

function M.pick_project(on_select)
	local items = {}

	for label, path in pairs(projects) do
		local expanded = vim.fn.expand(path)

		table.insert(items, {
			text = label,
			label = label,
			path = expanded,
			preview = {
				text = expanded,
				ft = "text",
			},
		})

		table.sort(items, function(a, b)
			return a.label < b.label
		end)

		Snacks.picker.pick({
			title = "Personal Projects",
			layout = "select",
			items = items,
			format = "text",
			preview = "preview",

			confirm = function(picker, item)
				if not item then
					return
				end

				picker:close()

				on_select(item.label, item.path)
			end,
		})
	end
end

return M
