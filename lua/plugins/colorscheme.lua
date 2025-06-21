return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,

    config = function()
      -- Default fallback in case the file doesn't exist
      local flavour = "mocha"

      -- Attempt to read the current theme from HyDE
      local file = io.open(vim.fn.expand("~/.cache/hyde/current_theme"), "r")
      if file then
        local line = file:read("*l")
        if line and #line > 0 then
          flavour = line
        end
        file:close()
      end

      -- Sanitize invalid values (fallback if needed)
      local valid_flavours = { latte = true, frappe = true, macchiato = true, mocha = true }
      if not valid_flavours[flavour] then
        flavour = "mocha"
      end

      require("catppuccin").setup({
        flavour = flavour,
        transparent_background = true,
        integrations = {
          lualine = false,
          telescope = {
            enabled = true,
            style = "nvchad",
          },
          bufferline = true,
        },
      })

      vim.cmd.colorscheme("catppuccin-" .. flavour)
    end,
  },
}
