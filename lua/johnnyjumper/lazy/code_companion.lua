return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim",
		"saghen/blink.cmp",
	},
	opts = {
		paths = {
			cache = vim.fn.stdpath("cache") .. "/codecompanion",
			data = vim.fn.stdpath("data") .. "/codecompanion",
			state = vim.fn.stdpath("state") .. "/codecompanion",
		},
		strategies = {
			chat = {
				adapter = "openai",
				model = "gpt-5-mini-2025-08-07",
				opts = {
					completion_provider = "blink",
				},
			},
			inline = {
				adapter = "openai",
				model = "gpt-5-nano-2025-08-07",
				opts = {
					completion_provider = "blink",
				},
			},
			cmd = {
				adapter = "openai",
				model = "gpt-5-nano-2025-08-07",
				opts = {
					completion_provider = "blink",
				},
			},
		},
		memory = {
			projectRead = {
				description = "Memory files for project read",
				files = {
					"AGENTS.md",
					"GEMINI.md",
					".codecompanion-workspace.json",
				},
				enabled = function()
					return vim.fn.getcwd():find("project-read", 1, true) ~= nil
				end,
			},
			opts = {
				chat = {
					enabled = true,
				},
			},
		},
		adapters = {
			http = {
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						env = {
							api_key = function()
								return os.getenv("CODE_COMPANION_OPENAI_KEY")
							end,
						},
					})
				end,
			},
		},
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ",
				provider = "telescope",
				opts = {
					show_default_actions = true,
					show_default_prompt_library = true,
					title = "CodeCompanion actions",
				},
			},
		},
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_vars = true,
					make_slash_commands = true,
					show_result_in_chat = true,
				},
			},
		},
		opts = {
			log_level = "DEBUG",
		},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)

		vim.keymap.set({ "n", "v" }, "<leader>acc", function()
			vim.fn.feedkeys(":CodeCompanion")
		end, { desc = "Ask code companion", noremap = true, silent = true })

		vim.keymap.set(
			{ "n", "v" },
			"<leader>bcc",
			"<cmd>CodeCompanionChat Toggle<cr>",
			{ desc = "Toggle Chat", noremap = true, silent = true }
		)
	end,
}
