return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			local function contains(t, value)
				return vim.tbl_contains(t, value)
			end

			local function get_supported_lang(ft)
				if ft == "" then
					return nil
				end

				local lang = vim.treesitter.language.get_lang(ft) or ft
				if contains(ts.get_available(), lang) then
					return lang
				end

				return nil
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = get_supported_lang(ft)
					if not lang then
						return
					end

					if contains(ts.get_installed(), lang) then
						vim.treesitter.start(args.buf, lang)
						return
					end

					ts.install({ lang }):await(function()
						vim.treesitter.start(args.buf, lang)
					end)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		lazy = false,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ai", function()
				select.select_textobject("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ii", function()
				select.select_textobject("@conditional.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "al", function()
				select.select_textobject("@loop.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "il", function()
				select.select_textobject("@loop.inner", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				move.goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]d", function()
				move.goto_next("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[d", function()
				move.goto_previous("@conditional.outer", "textobjects")
			end)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = false,
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiwindow = false,
				max_lines = 2,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
			})
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = false,
		config = function()
			vim.g.skip_ts_context_commentstring_module = true
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("render-markdown").setup({})
		end,
	},
}
