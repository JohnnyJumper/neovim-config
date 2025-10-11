return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		},
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				hidden = false,
				file_ignote_patterns = {
					"node_modules",
				},
			},
			pickers = {
				live_grep = {
					theme = "dropdown",
				},
				search_string = {
					theme = "dropdown",
				},
				buffers = {
					theme = "dropdown",
				},
			},
			extensions = {
				fzf = {},
			},
		})
		require("johnnyjumper.config.telescope.multigrep").setup()

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope find help tag" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>en", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end, { desc = "Search through neovim config" })

		vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Grab from within git files" })
		vim.keymap.set("n", "<leader>fw", function()
			local word = vim.fn.expand("<cword>")
			builtin.live_grep({
				debounce = 100,
				default_text = word,
			})
		end)
		vim.keymap.set("n", "<leader>fW", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.live_grep({
				default_text = word,
			})
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.search_string({
				search = vim.fn.input("Grep > "),
			})
		end)
		vim.keymap.set("n", "<leader>fn", function()
			vim.cmd("Telescope notify")
		end)
		vim.keymap.set("n", "<leader>fb", function()
			builtin.buffers()
		end)
	end,
}
