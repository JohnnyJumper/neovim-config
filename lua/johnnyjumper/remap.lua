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

-- Fun command for easy fast and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "s", "<C-w>", { desc = "override s to C-w for window operations" })

vim.keymap.set("n", "<leader>xr", "<cmd>Rest run<cr>")
vim.keymap.set("v", "<leader>jq", "<cmd>Jqit<cr>")

vim.keymap.set("n", "<M-j>", "<cmd>lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "<M-k>", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<cr>")
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
