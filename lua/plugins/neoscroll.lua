return {
	"karb94/neoscroll.nvim",
	event = "WinScrolled",
	config = function()
		local neoscroll = require("neoscroll")

		neoscroll.setup({
			-- Basic config
			hide_cursor = true, -- Hide cursor while scrolling
			stop_eof = true, -- Stop at EOF when scrolling down
			respect_scrolloff = true, -- Use scrolloff margin
			cursor_scrolls_alone = true, -- Allow cursor to move independently

			-- Predefined easing functions: "linear", "quadratic", "cubic", "quartic", "quintic", "circular", "sine"
			easing_function = "quadratic",
		})

		local t = {}
		-- Scroll <C-d> and <C-u> by half a page, and <C-f>/<C-b> by full pages
		t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "120" } }
		t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "120" } }
		t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
		t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }

		-- Scroll one line up/down
		t["<C-y>"] = { "scroll", { "-0.10", "false", "80" } }
		t["<C-e>"] = { "scroll", { "0.10", "false", "80" } }

		-- Recenter screen with smooth scroll
		t["zz"] = { "zt", { "150" } }
		t["zt"] = { "zt", { "150" } }
		t["zb"] = { "zb", { "150" } }

		require("neoscroll.config").set_mappings(t)
	end,
}
