return {
  {
    "LazyVim/LazyVim",
    opts = function()
      local function rgba_to_hex(rgba)
        if not rgba then
          return nil
        end
        local hex = rgba:match("rgba%(([%x]+)%)")
        if hex and #hex >= 6 then
          return "#" .. hex:sub(1, 6)
        end
        return nil
      end

      local function apply_hyde_cursorline_highlight()
        local colors = require("plugins.util.hyde_colors").get_colors()

        -- Extract from HyDE theme values or use fallback
        local row_bg = rgba_to_hex(colors["col.inactive_border"]) or "#3a3a3a"
        local linenr_fg = rgba_to_hex(colors["col.active_border"]) or "#88c0d0"

        vim.api.nvim_set_hl(0, "CursorLine", {
          bg = row_bg,
        })

        vim.api.nvim_set_hl(0, "CursorLineNr", {
          fg = linenr_fg,
          bold = true,
        })
      end

      -- Apply once at startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = apply_hyde_cursorline_highlight,
      })

      -- Reapply on theme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = apply_hyde_cursorline_highlight,
      })
    end,
  },
}
