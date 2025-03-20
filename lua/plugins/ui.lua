return {
	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with :Noice
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
		keys = {},
	},

	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				-- separator_style = "slant",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},

	-- filename
	{
		"b0o/incline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			local catppuccin = require("catppuccin.palettes").get_palette()

			-- Set custom highlight groups using Catppuccin colors
			vim.api.nvim_set_hl(0, "InclineNormal", { fg = catppuccin.text, bg = catppuccin.base })
			vim.api.nvim_set_hl(0, "InclineBorder", { fg = catppuccin.mauve, bg = catppuccin.base })

			require("incline").setup({
				window = {
					padding = 0,
					margin = { vertical = 0, horizontal = 1 },
					winhighlight = {
						Normal = "InclineNormal",
						FloatBorder = "InclineBorder",
					},
				},
				render = function(props)
					local bufname = vim.api.nvim_buf_get_name(props.buf)
					local filename = vim.fn.fnamemodify(bufname, ":t")
					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					local modified = vim.bo[props.buf].modified and "[+] " or ""
					local readonly = vim.bo[props.buf].readonly and " " or ""
					local branch = git and git.head or ""

					return {
						{ icon, guifg = color },
						{ " " },
						{ modified, guifg = catppuccin.peach }, -- Use peach for modified indicator
						{ readonly, guifg = catppuccin.red }, -- Use red for readonly
						{ filename, guifg = catppuccin.text }, -- Main text color
						{ branch ~= "" and "  " .. branch or "", guifg = catppuccin.mauve }, -- Use mauve for git branch
					}
				end,
				hide = {
					cursorline = true,
					focused_win = false,
					only_win = false,
				},
			})
		end,
	},

	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")

			-- Get Catppuccin colors
			local catppuccin = require("catppuccin.palettes").get_palette()

			-- Custom theme using Catppuccin colors
			local custom_theme = {
				normal = {
					a = { fg = catppuccin.sky, bg = catppuccin.mantle, gui = "bold" },
					b = { fg = catppuccin.text, bg = catppuccin.mantle },
					c = { fg = catppuccin.overlay1, bg = catppuccin.base },
				},
				insert = {
					a = { fg = catppuccin.green, bg = catppuccin.mantle, gui = "bold" },
					b = { fg = catppuccin.text, bg = catppuccin.mantle },
				},
				visual = {
					a = { fg = catppuccin.mauve, bg = catppuccin.mantle, gui = "bold" },
					b = { fg = catppuccin.text, bg = catppuccin.mantle },
				},
				replace = {
					a = { fg = catppuccin.red, bg = catppuccin.mantle, gui = "bold" },
					b = { fg = catppuccin.text, bg = catppuccin.mantle },
				},
				command = {
					a = { fg = catppuccin.peach, bg = catppuccin.mantle, gui = "bold" },
					b = { fg = catppuccin.text, bg = catppuccin.mantle },
				},
				inactive = {
					a = { fg = catppuccin.overlay1, bg = catppuccin.base },
					b = { fg = catppuccin.overlay1, bg = catppuccin.base },
					c = { fg = catppuccin.overlay1, bg = catppuccin.base },
				},
			}

			-- Ensure opts.sections exists
			opts.sections = opts.sections or {}
			opts.sections.lualine_c = opts.sections.lualine_c or {}

			-- Add your custom pretty_path configuration
			opts.sections.lualine_c[4] = {
				LazyVim.lualine.pretty_path({
					length = 0,
					relative = "cwd",
					modified_hl = "MatchParen",
					directory_hl = "",
					filename_hl = "Bold",
					modified_sign = "",
					readonly_icon = " 󰌾 ",
				}),
			}

			-- Merge with additional options
			return vim.tbl_deep_extend("force", opts, {
				options = {
					theme = custom_theme,
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" }, -- Softer separators
					disabled_filetypes = {},
					globalstatus = true,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(str)
								return str:sub(1, 1)
							end,
						}, -- Shorten mode to first letter
					},
					lualine_b = {
						{ "branch", icon = "" }, -- Git branch with icon
						"diff",
					},
					lualine_c = { -- Left-aligned, filename centered
						{ "diagnostics", symbols = { error = " ", warn = " ", info = " " } },
					}, -- pretty_path is already in [4]
					lualine_x = { -- Right-aligned, more compact
						{ "filetype", icon_only = true }, -- Icon only for filetype
						"encoding",
						{ "fileformat", icons_enabled = true },
					},
					lualine_y = {
						{ "progress", separator = " " },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						{
							function()
								return " " .. os.date("%I:%M %p")
							end,
						}, -- 12-hour time with icon
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = true,
				kitty = { enabled = false, font = "+2" },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},

	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⠀⠀⠀⢠⣾⣧⣤⡖⠀⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠋⠀⠉⠀⢄⣸⣿⣿⣿⣿⣿⣥⡤⢶⣿⣦⣀⡀
        ⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡆⠀⠀⠀⣙⣛⣿⣿⣿⣿⡏⠀⠀⣀⣿⣿⣿⡟
        ⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠷⣦⣤⣤⣬⣽⣿⣿⣿⣿⣿⣿⣿⣟⠛⠿⠋⠀
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠋⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⡆⠀⠀
        ⠀⠀⠀⠀⣠⣶⣶⣶⣿⣦⡀⠘⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠈⢹⡏⠁⠀⠀
        ⠀⠀⠀⢀⣿⡏⠉⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡆⠀⢀⣿⡇⠀⠀⠀
        ⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣟⡘⣿⣿⣃⠀⠀⠀
        ⣴⣷⣀⣸⣿⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⠹⣿⣯⣤⣾⠏⠉⠉⠉⠙⠢⠀
        ⠈⠙⢿⣿⡟⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣄⠛⠉⢩⣷⣴⡆⠀⠀⠀⠀⠀
        ⠀⠀⠀⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣀⡠⠋⠈⢿⣇⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ]],
				},
			},
		},
	},
}
