return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "copilot",
    copilot = {
      -- Recommended Copilot settings for Avante
      temperature = 0,     -- Lower temperature for more deterministic responses
      max_tokens = 8192,   -- Large token limit for comprehensive answers
      show_prompt = false, -- Hide prompts in UI for cleaner experience
      -- Set these if you want to customize the Copilot experience
      -- model = "copilot-gpt-4o",  -- If you have access to GPT-4o with your subscription
    },
    -- UI customization
    window = {
      border = "rounded",
      width = 0.8,  -- 80% of editor width
      height = 0.7, -- 70% of editor height
    },
    -- For better performance when making model requests
    request_timeout = 60000, -- 60 seconds
    -- Keyboard shortcut customization
    keymaps = {
      toggle = "<leader>at", -- Toggle Avante sidebar
      ask = "<leader>aa",    -- Ask AI about current code
      chat = "<leader>ac",   -- Start a chat session
      focus = "<leader>af",  -- Focus on Avante window
      stop = "<leader>as",   -- Stop generation
      clear = "<leader>ax",  -- Clear chat history
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua", -- Required for Copilot integration
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
