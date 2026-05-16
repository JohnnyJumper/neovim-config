local M = {}

function M.setup()
	require("custom.jqit")
	require("custom.hoverAndDiagnosticWin")
	local theme = require("custom.theme")
	theme.setup()
	theme.load()
end

return M
