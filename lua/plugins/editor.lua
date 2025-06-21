return {
  {
    enabled = false,
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require("catppuccin.hsl")
            --- @type string, string, string
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<Leader>gb",
        browse = "<Leader>go",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
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

          local cp = require("catppuccin.palettes").get_palette(flavour)

          vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = cp.base, fg = cp.text })
          vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = cp.base, fg = cp.mauve })
          vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = cp.mantle, fg = cp.text })
          vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = cp.mantle, fg = cp.mauve })
          vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = cp.mantle, fg = cp.teal })
          vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = cp.base, fg = cp.text })
          vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = cp.base, fg = cp.mauve })
          vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = cp.base, fg = cp.sky })
          vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = cp.base, fg = cp.text })
          vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = cp.base, fg = cp.mauve })
          vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = cp.surface2, fg = cp.text })
          vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = cp.blue })
        end,
      })

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
          },
        },
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      })

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }

      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
          mappings = {
            ["n"] = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(bufnr)
                for _ = 1, 10 do
                  actions.move_selection_previous(bufnr)
                end
              end,
              ["<C-d>"] = function(bufnr)
                for _ = 1, 10 do
                  actions.move_selection_next(bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }

      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },

  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>th",
        function()
          require("close_buffers").delete({ type = "hidden" })
        end,
        "Close Hidden Buffers",
      },
      {
        "<leader>tu",
        function()
          require("close_buffers").delete({ type = "nameless" })
        end,
        "Close Nameless Buffers",
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          winblend = vim.o.pumblend,
        },
      },
      signature = {
        window = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },
}
