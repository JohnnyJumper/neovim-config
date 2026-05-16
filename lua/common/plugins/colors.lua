-- When adding new theme ensure the lazy is set to false. After installing use
-- :ThemeList command
return {
	{
		"zefei/cake16",
		name = "cake16",
		lazy = false,
	},
	{
		"sainnhe/everforest",
		name = "everforest",
		lazy = false,
	},
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true,
				commentStyle = { italic = false },
				keywordStyle = { italic = false },
				statementStyle = { bold = false },
				functionStyle = {},
				typeStyle = {},
				undercurl = true,
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				background = {
					dark = "wave",
					light = "lotus",
				},
				theme = "dragon",
				colors = {
					palette = {},
					theme = {
						wave = {},
						lotus = {},
						dragon = {},
						all = {},
					},
				},

				overrides = function(colors)
					local theme = colors.theme

					local function make_diagnostic_color(color)
						local kanagawa_color = require("kanagawa.lib.color")
						return {
							fg = color,
							bg = kanagawa_color(color):blend(theme.ui.bg, 0.95):to_hex(),
						}
					end

					return {
						DiagnosticVirtualTextHint = make_diagnostic_color(theme.diag.hint),
						DiagnosticVirtualTextInfo = make_diagnostic_color(theme.diag.info),
						DiagnosticVirtualTextWarn = make_diagnostic_color(theme.diag.warning),
						DiagnosticVirtualTextError = make_diagnostic_color(theme.diag.error),
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
		name = "sonokai",
		lazy = false,
		priority = 1000,

		init = function()
			vim.g.sonokai_enable_italic = false
			vim.g.sonokai_style = "andromeda"
		end,

		config = function()
			local function patch_sonokai()
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

			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("JohnnySonokaiPatch", { clear = true }),
				pattern = "sonokai",
				callback = patch_sonokai,
			})

			-- Handles the edge case where sonokai is already active before this config runs.
			if vim.g.colors_name == "sonokai" then
				patch_sonokai()
			end
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,

		opts = {
			flavour = "latte",
			integrations = {
				notify = true,
			},
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
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
				inverse = true,
				contrast = "",
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
		end,
	},
}
