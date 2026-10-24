local function close_oil_window()
  local current_window = vim.api.nvim_get_current_win()
  local current_config = vim.api.nvim_win_get_config(current_window)
  local normal_window_count = 0

  for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(window).relative == "" then
      normal_window_count = normal_window_count + 1
    end
  end

  if current_config.relative ~= "" or normal_window_count > 1 then
    vim.api.nvim_win_close(current_window, false)
    return
  end

  require("oil.actions").close.callback()
end

return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      watch_for_changes = true,
      constrain_cursor = "editable",
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width = 0.75,
        max_height = 0.75,
        border = "rounded",
      },
      keymaps = {
        ["q"] = {
          desc = "Close Oil window",
          callback = close_oil_window,
        },
        ["<CR>"] = "actions.select",
        ["l"] = "actions.select",
        ["h"] = "actions.parent",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = "actions.preview",
        ["-"] = "actions.parent",
        ["g."] = "actions.toggle_hidden",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", {
        desc = "Open filesystem buffer",
      })
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", {
        desc = "Open parent directory",
      })
    end,
  },
}
