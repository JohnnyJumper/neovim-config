function _G.hoverAndDiagnosticWindow()
	local hover_params = vim.lsp.util.make_position_params(0, "utf-8")
	vim.lsp.buf_request_all(0, "textDocument/hover", hover_params, function(results, _)
		-- Filter errors from results
		local results1 = {} --- @type table<integer,lsp.Hover>

		for client_id, resp in pairs(results) do
			local err, result = resp.err, resp.result
			if err then
				vim.lsp.log.error(err.code, err.message)
			elseif result then
				results1[client_id] = result
			end
		end

		local contents = {} --- @type string[]
		local nresults = #vim.tbl_keys(results1)

		for client_id, result in pairs(results1) do
			local client = assert(vim.lsp.get_client_by_id(client_id))
			if nresults > 1 then
				-- Show client name if there are multiple clients
				contents[#contents + 1] = string.format("# %s", client.name)
			end
			if type(result.contents) == "table" and result.contents.kind == "plaintext" then
				if #results1 == 1 then
					contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
				else
					-- Surround plaintext with ``` to get correct formatting
					contents[#contents + 1] = "```"
					vim.list_extend(contents, vim.split(result.contents.value or "", "\n", { trimempty = true }))
					contents[#contents + 1] = "```"
				end
			else
				vim.list_extend(contents, vim.lsp.util.convert_input_to_markdown_lines(result.contents))
			end
			contents[#contents + 1] = "---"
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
			wrap_at = 300,
			max_width = 300,
			focus_id = "pretty-hover-id",
		})
		require("pretty_hover.highlight").apply_highlight(out.highlighting, buf)
	end)
end
