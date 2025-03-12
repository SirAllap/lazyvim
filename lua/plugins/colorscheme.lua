return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				variant = "dark",
				transparent = false, -- Slightly opaque for better readability
				italic_comments = true,
				hide_fillchars = true,
				borderless_pickers = true,
				terminal_colors = true,

				colors = {
					-- Muted cyberpunk palette
					bg = "#0a0a1a", -- Soft dark navy instead of pure black
					fg = "#80ffdf", -- Pastel cyan-green
					green = "#60c0a0", -- Muted matrix green
					magenta = "#c080ff", -- Soft purple-pink
					blue = "#66b3ff", -- Sky blue
					red = "#ff6666", -- Coral red
					yellow = "#ffd966", -- Gold yellow
					orange = "#ffb366", -- Peach
					pink = "#ff80bf", -- Bubblegum pink
					purple = "#a066ff", -- Lavender
					cyan = "#66ffff", -- Pale cyan
					violet = "#9466ff", -- Periwinkle
					teal = "#66ffcc", -- Mint teal
					white = "#e0e0e0", -- Off-white
					gray = "#606060", -- Medium gray
				},

				highlights = {
					Visual = { bg = "#3a3a5a" }, -- Softer visual selection
					Search = { bg = "#2a4a6a" }, -- Less intense search highlight
				},

				overrides = function(colors)
					return {
						-- UI elements
						Normal = { bg = colors.bg, fg = colors.fg },
						StatusLine = { bg = colors.bg, fg = colors.cyan, bold = true },
						VertSplit = { fg = colors.purple },
						Pmenu = { bg = colors.bg, fg = colors.fg },
						PmenuSel = { bg = colors.bg, fg = colors.bg },
						PmenuSbar = { bg = colors.bg, fg = colors.fg },
						PmenuThumb = { bg = colors.fg, fg = colors.bg },
						LineNr = { fg = colors.gray, bg = colors.bg },
						CursorLineNr = { fg = colors.teal, bg = colors.bg },

						-- Snacks highlights
						SnacksTitle = { fg = colors.cyan, bold = true },
						SnacksPath = { fg = colors.gray },
						SnacksBorder = { fg = colors.purple, bg = colors.bg },
						SnacksDirectory = { fg = colors.teal },
						SnacksFile = { fg = colors.fg },
						SnacksSymlink = { fg = colors.purple },
						SnacksSelection = { bg = colors.selection },

						-- Syntax elements
						["@function"] = { fg = colors.blue, bold = true },
						["@keyword"] = { fg = colors.purple, italic = true },
						["@string"] = { fg = colors.teal },
						["@number"] = { fg = colors.orange },
						["@boolean"] = { fg = colors.yellow, bold = true },
						["@operator"] = { fg = colors.magenta },
						["@type"] = { fg = colors.cyan },
						["@tag"] = { fg = colors.blue },

						-- Diagnostics
						DiagnosticError = { fg = colors.red },
						DiagnosticWarn = { fg = colors.yellow },
						DiagnosticInfo = { fg = colors.blue },
						DiagnosticHint = { fg = colors.cyan },

						-- Diff
						DiffAdd = { fg = colors.green, bg = "#1a3a1a" },
						DiffDelete = { fg = colors.red, bg = "#3a1a1a" },
						DiffChange = { fg = colors.yellow, bg = "#3a3a1a" },

						-- Comments
						Comment = { fg = "#708090", italic = true }, -- Slate gray comments
					}
				end,

				extensions = {
					telescope = {
						style = "dark",
						highlights = {
							border = "TelescopeBorder",
							prompt_title = "TelescopeTitle",
						},
					},
					notify = true,
					mini = true,
				},
			})
			vim.cmd("colorscheme cyberdream")
		end,
	},
}
