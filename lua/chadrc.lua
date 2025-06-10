-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "github_light",

  -- Add/Modify the hl_override table
  hl_override = {
    -- Core UI Backgrounds
    Normal = { bg = "NONE" },
    NormalFloat = { bg = "NONE" },
    NormalNC = { bg = "NONE" }, -- Non-current windows
    MsgArea = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    LineNr = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    VertSplit = { bg = "NONE" },
    StatusLine = { bg = "NONE" },
    StatusLineNC = { bg = "NONE" }, -- Non-current status lines
    TabLine = { bg = "NONE" },      -- Tab pages line background
    TabLineFill = { bg = "NONE" },  -- Tab pages line background where no labels
    TabLineSel = { bg = "NONE" },   -- Active tab page label background
    WinSeparator = { bg = "NONE" }, -- Separators between splits
    EndOfBuffer = { bg = "NONE" },  -- Space after last line

    -- Common Plugin Backgrounds (Add others if you find them)
    NvimTreeNormal = { bg = "NONE" },
    TelescopeNormal = { bg = "NONE" },
    WhichKeyFloat = { bg = "NONE" },
  },

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
