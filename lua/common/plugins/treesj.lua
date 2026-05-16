return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		require("treesj").setup({
			use_default_keymaps = false,
		})
		vim.keymap.set("n", "<leader>t", function()
			require("treesj").toggle()
		end)
		vim.keymap.set("n", "<leader>T", function()
			require("treesj").toggle({ split = { recursive = true } })
		end)
		vim.keymap.set("n", "<leader>n", function()
			require("treesj").split()
		end)
		vim.keymap.set("n", "<leader>j", function()
			require("treesj").join()
		end)
	end,
}
