local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values
local M = {}

local live_multigrep = function(opts)
	opts = opts or {}
	opts.separator = opts.separator or " @"
	opts.cwd = opts.cwd or vim.uv.cwd()

	vim.print(vim.inspect(opts))
	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, opts.separator)
			local args = { "rg" }

			if pieces[1] then
				vim.list_extend(args, { "-e", pieces[1] })
			end

			if pieces[2] then
				vim.list_extend(args, { "-g", pieces[2] })
			end

			local final = vim.iter({
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
			})
				:flatten()
				:totable()

			return final
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Grep >",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		---@diagnostic disable-next-line: undefined-field
		:find()
end

M.setup = function()
	vim.keymap.set("n", "<leader>fmg", live_multigrep)
end

return M
