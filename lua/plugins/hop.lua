return {
  "smoka7/hop.nvim",
  keys = { "<leader>j", "f", "F" },
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    
    -- Plugin setup
    hop.setup({
      keys = "etovxqpdygfblzhckisuran",
      case_insensitive = true,
      multi_windows = true,
    })
    
    -- Set up key mappings
    local wk = require("which-key")
    wk.add({ { "<leader>j", group = "Jump/Hop" } })

    -- Register individual mappings
    vim.keymap.set("n", "<leader>jw", function() hop.hint_words() end, { desc = "Hop to Word" })
    vim.keymap.set("n", "<leader>jl", function() hop.hint_lines() end, { desc = "Hop to Line" })
    vim.keymap.set("n", "<leader>jp", function() hop.hint_patterns() end, { desc = "Hop to Pattern" })
    vim.keymap.set("n", "<leader>jc", function() hop.hint_char2() end, { desc = "Hop to 2-Char Combo" })
    vim.keymap.set("n", "<leader>jf", function() 
      hop.hint_char1({ direction = directions.AFTER_CURSOR }) 
    end, { desc = "Hop Forward to Char" })
    vim.keymap.set("n", "<leader>jb", function() 
      hop.hint_char1({ direction = directions.BEFORE_CURSOR }) 
    end, { desc = "Hop Backward to Char" })
    vim.keymap.set("n", "<leader>ja", function() hop.hint_anywhere() end, { desc = "Hop Anywhere" })
    vim.keymap.set("n", "<leader>jv", function() hop.hint_vertical() end, { desc = "Hop Vertically" })
    
    -- Basic f/t replacements (optional)
    vim.keymap.set("n", "f", function()
      hop.hint_words()
    end, { remap = true, desc = "Hop to word" })

    vim.keymap.set("n", "F", function()
      hop.hint_char1()
    end, { remap = true, desc = "Hop to char" })
  end,
  dependencies = {
    "folke/which-key.nvim",
  },
}
