function _G.hoverAndDiagnosticWindow()
	local contents = {}
	local hover_params = vim.lsp.util.make_position_params(0, "utf-8")

	vim.lsp.buf_request(0, "textDocument/hover", hover_params, function(_, result, _, _)
		local hover_lines = {}
		if result and result.contents then
			hover_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
			hover_lines = vim.split(table.concat(hover_lines, "\n"), "\n", { trimempty = true })
			vim.list_extend(contents, hover_lines)
		end

		local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		local seen = {}
		for _, line in ipairs(contents) do
			seen[line] = true
		end

		local msg_rows = {}
		for _, d in ipairs(line_diagnostics) do
			if not seen[d.message] then
				if #contents > 0 then
					table.insert(contents, "")
				end
				table.insert(contents, d.message)
				local msg_row = #contents - 1 -- zero based index
				table.insert(msg_rows, { row = msg_row, sev = d.severity })

				if d.code then
					table.insert(contents, tostring(d.code))
					table.insert(msg_rows, { row = #contents - 1, sev = vim.diagnostic.severity.HINT })
				end
				seen[d.message] = true
			end
		end

		if vim.tbl_isempty(contents) then
			contents = { "No hover information or diagnostics." }
		end

		local parser = require("pretty_hover.parser")
		local out = parser.parse(contents)
		local buf, win = vim.lsp.util.open_floating_preview(out.text, "markdown", {
			border = "rounded",
			focusable = true,
			wrap = true,
			wrap_at = 100,
			max_width = 100,
			focus_id = "pretty-hover-id",
		})
		require("pretty_hover.highlight").apply_highlight(out.highlighting, buf)

		-- Explicitly set buffer options to prevent formatting loss
		vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
		vim.api.nvim_set_option_value("readonly", true, { buf = buf })

		local ns = vim.api.nvim_create_namespace("hover_diagnostics")
		local hl_map = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		}

		for _, info in ipairs(msg_rows) do
			local group = hl_map[info.sev] or "DiagnosticInfo"
			vim.api.nvim_buf_add_highlight(buf, ns, group, info.row, 0, -1)
		end
	end)
end
