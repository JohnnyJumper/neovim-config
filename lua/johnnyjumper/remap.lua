local opts = { noremap = true, silent = true }
-- Yank/paste to/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)

vim.keymap.set("n", "<leader>r", "ciw<C-r>0<ESC>")
vim.keymap.set("v", "<leader>r", "c<C-r>0<ESC>")

-- Better Indenting
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- remove highlights on Esc
vim.keymap.set("n", "<Esc>", "<Esc>:noh<cr>", opts)

-- to paste normally
vim.keymap.set("v", "p", '"_dP', opts)

-- So we can move selection freely
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Pressing J will not move the cursor away
vim.keymap.set("n", "J", "mzJ`z")

-- When jumping with C-d and C-u cursor stays in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Fun command for easy search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("x", "z/", "<C-\\><C-n>`</\\%V", { desc = "Search forward within visual selection" })
vim.keymap.set("x", "z?", "<C-\\><C-n>`>?\\%V", { desc = "Search backward within visual selection" })

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "s", "<C-w>", { desc = "override's to C-w for window operations" })

vim.keymap.set("n", "<leader>xr", "<cmd>Rest run<cr>")
vim.keymap.set("v", "<leader>jq", "<cmd>Jqit<cr>")

local pos_equal = function(p1, p2)
	local r1, c1 = unpack(p1)
	local r2, c2 = unpack(p2)
	return r1 == r2 and c1 == c2
end

local goto_error_then_hint = function(count)
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity.ERROR, wrap = true })
	local pos2 = vim.api.nvim_win_get_cursor(0)
	if pos_equal(pos, pos2) then
		vim.diagnostic.jump({ count = count, wrap = true })
	end
end
vim.keymap.set("n", "<M-j>", function()
	goto_error_then_hint(1)
end)

vim.keymap.set("n", "<M-k>", function()
	goto_error_then_hint(-1)
end)
-- vim.keymap.set("n", "<M-j>", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<cr>zz")
-- vim.keymap.set("n", "<M-k>", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<cr>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<cr>zz")
vim.keymap.set("n", "<leader>bd", function()
	local current = vim.fn.bufnr()
	local closed = 0
	for _, bufnr in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if bufnr.bufnr ~= current then
			vim.cmd("bdelete! " .. bufnr.bufnr)
			closed = closed + 1
		end
	end
	vim.notify("Closed " .. closed .. " buffer(s)")
end, { desc = "Close all buffers except current" })

vim.keymap.set("n", "<leader>bb", "<cmd>edit#<cr>", { desc = "go to last edited buffer" })

-- QuickFixList shortcuts

vim.keymap.set("n", "<leader>qfc", function()
	vim.fn.setqflist({})
end, { desc = "Send Error to quickfix" })

vim.keymap.set("n", "<leader>qfe", function()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Send Error to quickfix" })

vim.keymap.set("n", "<leader>qfw", function()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Send Warnings to quickfix" })

vim.keymap.set("n", "<leader>qfh", function()
	vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.HINT })
end, { desc = "Send hints to quickfix" })

vim.keymap.set("n", "<leader>qc", "<cmd>:cclose<cr>", { desc = "Close quickfix window" })
vim.keymap.set("n", "<leader>qo", "<cmd>:copen<cr>", { desc = "Open quickfix window" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

vim.keymap.set("n", "<leader>cc", function()
	local current = vim.opt.colorcolumn:get()
	if vim.tbl_contains(current, "80") then
		vim.opt.colorcolumn = ""
	else
		vim.opt.colorcolumn = "80"
	end
end, { desc = "Toggle colorcolumn=80" })

vim.keymap.set("n", "<C-g>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "n", false)

	local path = vim.fn.expand("%:.")
	if path == "" then
		vim.notify("[No file]", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", path)
	vim.fn.setreg('"', path)
end, { desc = "Show file info and copy file path" })
