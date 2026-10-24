-- Telescope: Fuzzy Finder

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    })

    -- Load extensions
    pcall(telescope.load_extension, "fzf")

    -- Keymaps
    local keymap = vim.keymap
    local builtin = require("telescope.builtin")

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor" })
    keymap.set("n", "<leader>ft", builtin.git_files, { desc = "Git files" })
    keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
  end,
}
