return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"famiu/bufdelete.nvim",
		},
		config = function()
			local colors = require("cyberdream.colors")

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
					background = { bg = "NONE", fg = colors.base01 },

					buffer_selected = {
						bg = "NONE",
						fg = colors.yellow,
						bold = true,
						italic = false,
					},
					buffer_visible = { bg = "NONE", fg = colors.base00 },

					modified = { fg = colors.magenta, bg = "NONE" },
					modified_selected = { fg = colors.magenta, bg = "NONE", bold = true },

					indicator_selected = { fg = colors.blue, bg = "NONE" },

					separator = { fg = colors.base02, bg = "NONE" },
					separator_selected = { fg = colors.base02, bg = "NONE" },
					separator_visible = { fg = colors.base02, bg = "NONE" },

					error = { fg = colors.red, bg = "NONE" },
					error_diagnostic = { fg = colors.red, bg = "NONE" },
					warning = { fg = colors.orange, bg = "NONE" },
					warning_diagnostic = { fg = colors.orange, bg = "NONE" },
					info_diagnostic = { fg = colors.blue, bg = "NONE" },
					hint_diagnostic = { fg = colors.cyan, bg = "NONE" },

					duplicate = { bg = "NONE", fg = colors.base01 },
					duplicate_selected = { bg = "NONE", fg = colors.base01 },
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
