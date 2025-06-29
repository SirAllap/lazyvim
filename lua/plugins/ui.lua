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
      bigfile = { enabled = false },
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
      local hyde_colors = require("plugins.util.hyde_colors").get_colors()

      -- Set custom highlight groups using Catppuccin colors
      vim.api.nvim_set_hl(0, "InclineNormal", { fg = hyde_colors.text, bg = hyde_colors.base })
      vim.api.nvim_set_hl(0, "InclineBorder", { fg = hyde_colors.mauve, bg = hyde_colors.base })

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
            { modified, guifg = hyde_colors.peach }, -- Use peach for modified indicator
            { readonly, guifg = hyde_colors.red }, -- Use red for readonly
            { filename, guifg = hyde_colors.text }, -- Main text color
            { branch ~= "" and "  " .. branch or "", guifg = hyde_colors.mauve }, -- Use mauve for git branch
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local LazyVim = require("lazyvim.util")

      -- Get flavour from ~/.cache/hyde/current_theme
      local flavour = "mocha"
      local f = io.open(vim.fn.expand("~/.cache/hyde/current_theme"), "r")
      if f then
        flavour = f:read("*l") or "mocha"
        f:close()
      end
      local valid = { latte = true, frappe = true, macchiato = true, mocha = true }
      if not valid[flavour] then
        flavour = "mocha"
      end

      -- Get Catppuccin palette
      local hyde_colors = require("plugins.util.hyde_colors").get_colors()

      local custom_theme = {
        normal = {
          a = { fg = hyde_colors.sky, bg = hyde_colors.mantle, gui = "bold" },
          b = { fg = hyde_colors.text, bg = hyde_colors.mantle },
          c = { fg = hyde_colors.overlay1, bg = hyde_colors.base },
        },
        insert = {
          a = { fg = hyde_colors.green, bg = hyde_colors.mantle, gui = "bold" },
          b = { fg = hyde_colors.text, bg = hyde_colors.mantle },
        },
        visual = {
          a = { fg = hyde_colors.mauve, bg = hyde_colors.mantle, gui = "bold" },
          b = { fg = hyde_colors.text, bg = hyde_colors.mantle },
        },
        replace = {
          a = { fg = hyde_colors.red, bg = hyde_colors.mantle, gui = "bold" },
          b = { fg = hyde_colors.text, bg = hyde_colors.mantle },
        },
        command = {
          a = { fg = hyde_colors.peach, bg = hyde_colors.mantle, gui = "bold" },
          b = { fg = hyde_colors.text, bg = hyde_colors.mantle },
        },
        inactive = {
          a = { fg = hyde_colors.overlay1, bg = hyde_colors.base },
          b = { fg = hyde_colors.overlay1, bg = hyde_colors.base },
          c = { fg = hyde_colors.overlay1, bg = hyde_colors.base },
        },
      }

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
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
            },
          },
          lualine_b = {
            { "branch", icon = "" },
            "diff",
          },
          lualine_c = {
            { "diagnostics", symbols = { error = " ", warn = " ", info = " " } },
            LazyVim.lualine.pretty_path({
              length = 0,
              relative = "cwd",
              modified_hl = "MatchParen",
              directory_hl = "",
              filename_hl = "Bold",
              modified_sign = "",
              readonly_icon = " 󰌾 ",
            }),
          },
          lualine_x = {
            { "filetype", icon_only = true },
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
            },
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
