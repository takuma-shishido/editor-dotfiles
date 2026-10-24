-- Colorscheme: Nord

return {
  "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nord").setup({
      terminal_colors = true,
      borders = true,
    })
    vim.cmd.colorscheme("nord")
  end,
}
