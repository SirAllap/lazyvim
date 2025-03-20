return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = "BufReadPost",
		config = function()
			local bracketed = require("mini.bracketed")
			bracketed.setup({
				file = { suffix = "" },
				window = { suffix = "" },
				quickfix = { suffix = "" },
				yank = { suffix = "" },
				treesitter = { suffix = "n" },
			})
		end,
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true, -- Automatically show suggestions as you type
				debounce = 75, -- Delay in milliseconds before showing suggestions
				keymap = {
					accept = "<C-l>", -- Accept suggestion with Ctrl+l
					accept_word = "<M-w>", -- Accept a single word with Alt+w
					accept_line = "<M-l>", -- Accept the entire line with Alt+l
					next = "<M-]>", -- Cycle to the next suggestion with Alt+]
					prev = "<M-[>", -- Cycle to the previous suggestion with Alt+[
					dismiss = "<C-]>", -- Dismiss the current suggestion with Ctrl+]
				},
			},
			panel = {
				enabled = true,
				auto_refresh = true, -- Automatically refresh the panel
				keymap = {
					open = "<M-p>", -- Open the Copilot panel with Alt+p
				},
			},
			filetypes = {
				-- Enable Copilot for specific filetypes
				["*"] = true, -- Enable for all filetypes
				markdown = true,
				help = true,
				gitcommit = true,
				text = true,
			},
			-- Customize Copilot's behavior for specific filetypes
			ft_disable = {
				-- Disable Copilot for certain filetypes
				["neo-tree"] = true, -- Disable in NeoTree
				["NvimTree"] = true, -- Disable in NvimTree
			},
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			-- Customize Copilot suggestion colors to make them stand out
			vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#ff80bf", italic = true, bold = true }) -- Bubble pink for suggestions
			vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#a066ff", bold = true }) -- Lavender for annotations

			-- Keybindings to toggle Copilot on/off
			vim.keymap.set("n", "<leader>cp", function()
				require("copilot").toggle()
			end, { desc = "Toggle Copilot" })

			-- Keybindings to open the Copilot panel
			vim.keymap.set("n", "<leader>co", function()
				require("copilot.panel").open()
			end, { desc = "Open Copilot Panel" })

			-- Copilot chat
			vim.keymap.set("n", "<C-S-i>", function()
				require("CopilotChat").toggle()
			end, { desc = "Toggle Copilot Chat" })
		end,
	},
}
