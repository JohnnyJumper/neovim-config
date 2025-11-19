return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		picker = {
			enabled = true,
			matcher = {
				frecency = true,
				cwd_bonus = true,
				ignorecase = true,
				fuzzy = true,
			},
			ui_select = true,
		},
		quickfile = { enabled = false },
		notifier = { enabled = false },
		scope = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		rename = { enabled = true },
		zen = { enabled = false },
		gh = { enabled = false },
		lazygit = { enabled = true },
		dim = {
			enabled = true,
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				easing = "outQuad",
				duration = {
					step = 20, -- ms per step
					total = 300, -- maximum duration
				},
			},
			scope = {
				min_size = 5,
				max_size = 20,
				siblings = true,
			},
			filter = function(buf)
				return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
			end,
		},
	},
  -- stylua: ignore start
	keys = {
		{ "<leader>g/", function() Snacks.lazygit() end, desc = "Open lazygit" },
		{ "<leader>en", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find config file" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },

		{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>fgw", function() Snacks.picker.grep_word() end, desc = "Grep selected word", mode = { "n", "x" } },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fn", function() Snacks.picker.notifications() end, desc = "notifications" },
		-- LSP
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
		{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
		{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

    { "<leader>sd", function()
      if Snacks.dim.enabled then
        Snacks.dim.disable()
      else
        Snacks.dim.enable()
      end
    end, desc = "Toggle dim"}

	},
	-- stylua: ignore end
	config = function(_, opts)
		require("snacks").setup(opts)
	end,
}
