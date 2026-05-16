return {
	"JohnnyJumper/neotypist.nvim",
	enabled = false,
	opts = {
		notify_interval = 60 * 1000, -- one minute
		high = 80,
		low = 20,
		show_virt_text = true,
		notify = true,
		update_time = 300,
		virt_text = function(wpm)
			return ("🚀 WPM: %.0f"):format(wpm)
		end,
		virt_text_pos = "right_align",
	},
}
