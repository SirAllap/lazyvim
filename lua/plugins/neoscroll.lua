return {
	"karb94/neoscroll.nvim",
	event = "WinScrolled",
	config = function()
		local neoscroll = require("neoscroll")

		neoscroll.setup({
			hide_cursor = true,
			stop_eof = true,
			respect_scrolloff = true,
			cursor_scrolls_alone = true,
			easing_function = "quadratic",
			mappings = {}, -- Disable default mappings
		})

		local keymap = {
			["<C-u>"] = function()
				neoscroll.ctrl_u({ duration = 250 })
			end,
			["<C-d>"] = function()
				neoscroll.ctrl_d({ duration = 250 })
			end,
			["<C-b>"] = function()
				neoscroll.ctrl_b({ duration = 450 })
			end,
			["<C-f>"] = function()
				neoscroll.ctrl_f({ duration = 450 })
			end,
			["<C-y>"] = function()
				neoscroll.scroll(-0.10, { move_cursor = false, duration = 100 })
			end,
			["<C-e>"] = function()
				neoscroll.scroll(0.10, { move_cursor = false, duration = 100 })
			end,
			["zz"] = function()
				neoscroll.zz({ duration = 250 })
			end,
			["zt"] = function()
				neoscroll.zt({ duration = 250 })
			end,
			["zb"] = function()
				neoscroll.zb({ duration = 250 })
			end,
		}

		local modes = { "n", "v", "x" }
		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func, { silent = true })
		end
	end,
}
