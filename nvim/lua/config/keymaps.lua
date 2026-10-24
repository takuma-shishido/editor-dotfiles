-- Keymaps Configuration

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- mode(s), key or list of keys, rhs, description
local keymaps = {
  -- General
  { "n", "<leader>w", "<cmd>w<cr>", "Save file" },
  { "n", "<leader>q", "<cmd>q<cr>", "Close window" },
  { "n", "<leader>x", "<cmd>x<cr>", "Save and quit" },
  { "i", "jk", "<Esc>", "Leave insert mode" },

  -- Window navigation
  { "n", { "<A-h>", "<A-Left>" }, "<C-w>h", "Go to left window" },
  { "n", { "<A-j>", "<A-Down>" }, "<C-w>j", "Go to lower window" },
  { "n", { "<A-k>", "<A-Up>" }, "<C-w>k", "Go to upper window" },
  { "n", { "<A-l>", "<A-Right>" }, "<C-w>l", "Go to right window" },

  -- Window resizing
  { "n", { "<A-=>", "<A-+>" }, "<cmd>resize +2<bar>vertical resize +2<cr>", "Increase window size" },
  { "n", "<A-->", "<cmd>resize -2<bar>vertical resize -2<cr>", "Decrease window size" },

  -- Buffer navigation
  { "n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer" },
  { "n", "<S-l>", "<cmd>bnext<cr>", "Next buffer" },
  { "n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer" },

  -- Clear search highlight
  { "n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight" },

  -- Better indenting
  { "v", "<", "<gv", "Indent left" },
  { "v", ">", ">gv", "Indent right" },

  -- Better paste
  { "v", "p", '"_dP', "Paste without yanking" },

  -- Split windows
  { "n", "<leader>sv", "<cmd>vsplit<cr>", "Split vertically" },
  { "n", "<leader>sh", "<cmd>split<cr>", "Split horizontally" },
  { "n", "<leader>se", "<C-w>=", "Make splits equal size" },
  { "n", "<leader>sx", "<cmd>close<cr>", "Close current split" },

  -- Diagnostics. [d and ]d are provided by Neovim.
  { "n", "<leader>le", vim.diagnostic.open_float, "Show diagnostic error messages" },
  { "n", "<leader>dl", vim.diagnostic.setloclist, "Open diagnostic location list" },
}

for _, keymap in ipairs(keymaps) do
  local mode, lhs, rhs, description = keymap[1], keymap[2], keymap[3], keymap[4]
  for _, key in ipairs(type(lhs) == "table" and lhs or { lhs }) do
    vim.keymap.set(mode, key, rhs, { desc = description })
  end
end

-- Built-in completion popup and LSP snippets (no completion plugin).
-- key, key sent while the popup is open, snippet jump direction
local completion_keymaps = {
  { "<Tab>", "<C-n>", 1, "Next completion item or snippet stop" },
  { "<S-Tab>", "<C-p>", -1, "Previous completion item or snippet stop" },
}

for _, keymap in ipairs(completion_keymaps) do
  local lhs, popup_key, direction, description = keymap[1], keymap[2], keymap[3], keymap[4]
  vim.keymap.set("i", lhs, function()
    if vim.fn.pumvisible() == 1 then
      return popup_key
    elseif vim.snippet.active({ direction = direction }) then
      return ("<cmd>lua vim.snippet.jump(%d)<cr>"):format(direction)
    end
    return lhs
  end, { expr = true, desc = description })
end

vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept completion" })
