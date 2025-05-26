return {
	"chrisgrieser/nvim-recorder",
	dependencies = "rcarriga/nvim-notify", -- optional
	opts = {
		slots = { "a", "l", "k", "n" },
		clear = true,
	}, -- required even with default settings, since it calls `setup()`
}
