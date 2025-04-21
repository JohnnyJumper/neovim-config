return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {
		border = "rounded",
		wrap = true,
	},
	config = function(_, opts)
		require("pretty_hover").setup(opts)
	end,
}
