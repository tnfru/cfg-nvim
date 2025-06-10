return {
  "tnfru/nvim-venv-detector",
  event = "VimEnter",
  dependencies = { "rcarriga/nvim-notify" },
  config = function()
    require("venv_detector").setup()
  end,
}

