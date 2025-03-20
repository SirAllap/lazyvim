return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"famiu/bufdelete.nvim",
		},
		config = function()
			local catppuccin = require("catppuccin.palettes").get_palette()

			require("bufferline").setup({
				options = {
					mode = "buffers",
					numbers = "none",
					close_command = "Bdelete! %d",
					show_buffer_close_icons = false,
					show_close_icon = false,
					max_name_length = 18,
					truncate_names = true,
					tab_size = 20,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icons = { error = " ", warning = " ", info = " " }
						return " " .. (icons[level:lower()] or "") .. count
					end,
					offsets = {
						{ filetype = "NvimTree", text = "Files", highlight = "Directory", text_align = "left" },
					},
					separator_style = "thin",
					hover = { enabled = true, delay = 200 },
					always_show_bufferline = false,
				},
				highlights = {
					fill = { bg = "NONE" },
					background = { bg = "NONE", fg = catppuccin.overlay1 },

					buffer_selected = {
						bg = "NONE",
						fg = catppuccin.text,
						bold = true,
						italic = false,
					},
					buffer_visible = { bg = "NONE", fg = catppuccin.overlay0 },

					modified = { fg = catppuccin.mauve, bg = "NONE" },
					modified_selected = { fg = catppuccin.mauve, bg = "NONE", bold = true },

					indicator_selected = { fg = catppuccin.blue, bg = "NONE" },

					separator = { fg = catppuccin.surface1, bg = "NONE" },
					separator_selected = { fg = catppuccin.surface1, bg = "NONE" },
					separator_visible = { fg = catppuccin.surface1, bg = "NONE" },

					error = { fg = catppuccin.red, bg = "NONE" },
					error_diagnostic = { fg = catppuccin.red, bg = "NONE" },
					warning = { fg = catppuccin.peach, bg = "NONE" },
					warning_diagnostic = { fg = catppuccin.peach, bg = "NONE" },
					info_diagnostic = { fg = catppuccin.blue, bg = "NONE" },
					hint_diagnostic = { fg = catppuccin.sky, bg = "NONE" },

					duplicate = { bg = "NONE", fg = catppuccin.overlay1 },
					duplicate_selected = { bg = "NONE", fg = catppuccin.overlay1 },
				},
			})
			-- Key mappings
			vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
			vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
			vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLinePick<CR>")
			vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLinePickClose<CR>")
			vim.keymap.set("n", "<leader>bd", "<Cmd>Bdelete!<CR>")

			-- Close current buffer without closing window
			vim.keymap.set("n", "<leader>bc", "<Cmd>Bdelete!<CR>", { noremap = true, silent = true })
		end,
	},
}
