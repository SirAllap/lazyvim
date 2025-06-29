return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Set the default adapter for different actions
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
    },

    adapters = {
      -- Explicitly disable the copilot adapter to prevent it from loading
      copilot = {
        enabled = false,
      },

      -- Your gemini adapter setup
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = os.getenv("GEMINI_API_KEY"),
          },
        })
      end,
    },
  },
}
