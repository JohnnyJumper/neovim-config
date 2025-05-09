return {
	{
		"rmanocha/linear-nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			require("linear-nvim").setup()
			vim.keymap.set("n", "<leader>lm", function()
				require("linear-nvim").show_assigned_issues()
			end)
			vim.keymap.set("n", "<leader>lc", function()
				require("linear-nvim").create_issue()
			end)
			vim.keymap.set("n", "<leader>ls", function()
				require("linear-nvim").show_issue_details()
			end)
		end,
	},
}
