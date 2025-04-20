return {
	"crnvl96/lazydocker.nvim",
	event = "VeryLazy",
	opts = {
		window = {
			settings = {
				width = 0.9, -- 90% of the editor's width
				height = 0.9, -- 90% of the editor's height
				border = "rounded", -- Optional: set the border style
				relative = "editor", -- Optional: set the window's position relative to the editor
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
}
