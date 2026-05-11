require("johnnyjumper.set")
require("johnnyjumper.jqit")
require("johnnyjumper.utils")
require("johnnyjumper.lazy_init")
require("johnnyjumper.remap")
require("johnnyjumper.autocmd")

local theme = require("johnnyjumper.theme")
theme.setup()
theme.load()

require("johnnyjumper.neovide")

vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {})
