-- apply patch for sonokai theme

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
