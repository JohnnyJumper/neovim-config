require("johnnyjumper.set")
require("johnnyjumper.jqit")
require("johnnyjumper.utils")
require("johnnyjumper.lazy_init")
require("johnnyjumper.remap")
require("johnnyjumper.autocmd")
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
-- vim.cmd.colorscheme("kanagawa")
vim.cmd.colorscheme("sonokai")
if vim.g.colors_name == "sonokai" then
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#99cc33", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#40a6ce", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#40a6ce", undercurl = true })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualText", { fg = "#99cc33", bg = "NONE" })
	vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
		fg = "#fb617e",
		bg = "NONE",
		underdouble = true,
	})
	vim.api.nvim_set_hl(0, "VirtualTextInfo", { fg = "#40a6ce", bg = "NONE" })
end
-- ~/.local/share/pnpm/global/5/.pnpm/typescript@5.7.3/node_modules/typescript/lib/typescript.js do not forget to update defaultMaximumTruncationLength
require("johnnyjumper.neovide")
