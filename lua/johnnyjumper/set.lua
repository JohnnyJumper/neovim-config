vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.textwidth = 80
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 16
vim.opt.isfname:append("@-@")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99

vim.opt.updatetime = 20

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

-- codecompanion support
local cache = vim.fn.stdpath("cache") -- ~/.cache/nvim
local state = vim.fn.stdpath("state") -- ~/.local/state/nvim
local data = vim.fn.stdpath("data") -- ~/.local/share/nvim
local run = cache .. "/run"
local tmp = cache .. "/tmp"

vim.fn.mkdir(run, "p", "0o700")
vim.fn.mkdir(run, "p", "0o700")

vim.env.XDG_RUNTIME_DIR = run
vim.env.TMPDIR = tmp
