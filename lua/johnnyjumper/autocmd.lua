local augroup = vim.api.nvim_create_augroup
local TheJohnnyGroup = augroup("TheJohnny", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", { clear = true })

local lint_group = augroup("Lint", { clear = true })
local conform_group = augroup("conform", {})

autocmd({ "RecordingEnter" }, {
	callback = function()
		vim.opt.cmdheight = 1
	end,
})

autocmd({ "RecordingLeave" }, {
	callback = function()
		vim.opt.cmdheight = 0
	end,
})

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_group,
	callback = function()
		local lint = require("lint")
		lint.try_lint()
	end,
})

autocmd("BufWritePre", {
	group = conform_group,
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			lsp_fallback = true,
			stop_after_first = false,
		})
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd("BufEnter", {
	group = TheJohnnyGroup,
	callback = function()
		if vim.g.neovide then
			vim.cmd.colorscheme("catppuccin-macchiato")
		else
			vim.cmd.colorscheme("tokyonight-moon")
		end
	end,
})

autocmd("BufWritePre", {
	group = TheJohnnyGroup,
	pattern = "*",
	desc = "Removes the trailing whitespaces",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = TheJohnnyGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		local telescope = require("telescope.builtin")
		vim.keymap.set("n", "gd", function()
			telescope.lsp_definitions()
		end, opts)
		vim.keymap.set("n", "gr", function()
			telescope.lsp_references()
		end, opts)
		vim.keymap.set("n", "<leader>d", function()
			hoverAndDiagnosticWindow()
		end, vim.tbl_deep_extend("keep", opts, { noremap = false, silent = true }))
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = -1, float = { bufnr = opts.buffer } })
		end, opts)
	end,
})
