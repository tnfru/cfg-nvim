return {
  "smoka7/hop.nvim",
  lazy = false,
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    
    -- Plugin setup
    hop.setup({
      keys = "etovxqpdygfblzhckisuran",
      case_insensitive = true,
      multi_windows = true,
    })
    
    -- Set up key mappings directly with descriptive labels
    local wk = require("which-key")
    
    -- Register the group prefix for which-key
    -- The format is different for .add() - it expects direct mappings
    wk.add({
      mode = "n",
      prefix = "<leader>j",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = false,
    }, {
      name = "+Jump/Hop"
    })
    
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
      hop.hint_char1({ direction = directions.AFTER_CURSOR })
    end, { remap = true, desc = "Hop forward to char" })
    
    vim.keymap.set("n", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR })
    end, { remap = true, desc = "Hop backward to char" })
  end,
  dependencies = {
    "folke/which-key.nvim",
  },
}
