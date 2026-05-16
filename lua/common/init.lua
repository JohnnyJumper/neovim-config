local M = {}

function M.setup()
	require("common.set")
	require("common.remap")
	require("common.autocmd")

	vim.api.nvim_create_user_command("LspInfo", function()
		vim.cmd("checkhealth vim.lsp")
	end, {})
end

return M
