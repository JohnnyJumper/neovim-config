function _G.hoverAndDiagnosticWindow()
	local contents = {}
	local hover_params = vim.lsp.util.make_position_params(0, "utf-8")

	vim.lsp.buf_request(0, "textDocument/hover", hover_params, function(_, result, _, _)
		if result and result.contents then
			local hover_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
			hover_content = vim.split(table.concat(hover_content, "\n"), "\n", { trimempty = true })
			vim.list_extend(contents, hover_content)
		end

		local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		for _, diagnostic in ipairs(line_diagnostics) do
			table.insert(contents, "")
			table.insert(contents, diagnostic.message)
		end

		if vim.tbl_isempty(contents) then
			contents = { "No hover information or diagnostics." }
		end

		local buf, win = vim.lsp.util.open_floating_preview(contents, "markdown", { border = "single" })

		-- Explicitly set buffer options to prevent formatting loss

		vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
		vim.api.nvim_set_option_value("readonly", true, { buf = buf })

		-- Preserve window options explicitly
		vim.api.nvim_set_option_value("wrap", true, { win = win })
		vim.api.nvim_set_option_value("cursorline", false, { win = win })
	end)
end
