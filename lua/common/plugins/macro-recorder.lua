return {
	"chrisgrieser/nvim-recorder",
	dependencies = "rcarriga/nvim-notify", -- optional
	opts = {
		slots = { "l", "k", "g", "t" },
		clear = true,
	}, -- required even with default settings, since it calls `setup()`
}
