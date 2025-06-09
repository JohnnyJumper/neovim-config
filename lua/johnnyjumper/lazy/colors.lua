return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			vim.opt.cmdheight = 0
			require("kanagawa").setup({
				compile = true,
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
				statementStyle = { bold = false },
				undercurl = true,
				functionStyle = {},
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				background = {
					dark = "wave",
					light = "lotus",
				},
				theme = "dragon",
				overrides = function(colors)
					local theme = colors.theme
					local makeDiagnosticColor = function(color)
						local c = require("kanagawa.lib.color")
						return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
					end
					return {
						DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
						DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
						DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
						DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
						NormalFloat = { bg = "none" },
						FloatBorder = { bg = "none" },
						FloatTitle = { bg = "none" },
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptNormal = { bg = theme.ui.bg_p1 },
						TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
						TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					}
				end,
			})
		end,
	},
	{
		"https://github.com/sainnhe/sonokai",
		config = function()
			vim.g.sonokai_enable_italic = false
			vim.g.sonokai_style = "andromeda"
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin" },
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = false,
				bold = true,
				italic = {
					strings = false,
					emphasis = false,
					comments = false,
					operators = false,
					folds = false,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
		end,
	},
}
