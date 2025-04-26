return {
	"echasnovski/mini.pairs",
	event = "VeryLazy",
	opts = {
		mappings = {
			-- disable if a matching character is in an adjacent position (eg. fixes
			-- markdown triple ticks) neigh_pattern: a pattern for *two* neighboring
			-- characters (before and after). Use dot `.` to allow any character.
			-- Here, we disable the functionality instead of inserting a matching quote
			-- if there is an adjacent non-space character
			["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^%S][^%S]", register = { cr = false } },
			['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^%S][^%S]", register = { cr = false } },
			["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%S][^%S]", register = { cr = false } },
		},
	},
}
