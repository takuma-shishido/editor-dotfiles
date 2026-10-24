-- Treesitter: syntax highlighting, indentation, and text objects

-- Only what editing this configuration needs. Add parsers per language
-- with :TSInstall when a project calls for them.
local languages = {
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
}

-- lhs, query, description suffix
local select_textobjects = {
  { "af", "@function.outer", "outer function" },
  { "if", "@function.inner", "inner function" },
  { "ac", "@class.outer", "outer class" },
  { "ic", "@class.inner", "inner class" },
}

-- lhs, move function, query, description
local move_textobjects = {
  { "]m", "goto_next_start", "@function.outer", "Next function start" },
  { "]]", "goto_next_start", "@class.outer", "Next class start" },
  { "]M", "goto_next_end", "@function.outer", "Next function end" },
  { "][", "goto_next_end", "@class.outer", "Next class end" },
  { "[m", "goto_previous_start", "@function.outer", "Previous function start" },
  { "[[", "goto_previous_start", "@class.outer", "Previous class start" },
  { "[M", "goto_previous_end", "@function.outer", "Previous function end" },
  { "[]", "goto_previous_end", "@class.outer", "Previous class end" },
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = { lookahead = true },
          move = { set_jumps = true },
        })

        local select = require("nvim-treesitter-textobjects.select")
        local move = require("nvim-treesitter-textobjects.move")

        for _, spec in ipairs(select_textobjects) do
          local lhs, query, label = spec[1], spec[2], spec[3]
          vim.keymap.set({ "x", "o" }, lhs, function()
            select.select_textobject(query, "textobjects")
          end, { desc = "Select " .. label })
        end

        for _, spec in ipairs(move_textobjects) do
          local lhs, move_to, query, description = spec[1], spec[2], spec[3], spec[4]
          vim.keymap.set({ "n", "x", "o" }, lhs, function()
            move[move_to](query, "textobjects")
          end, { desc = description })
        end
      end,
    },
  },
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(args)
        local language = vim.treesitter.language.get_lang(args.match) or args.match
        if not vim.treesitter.language.add(language) then
          return
        end

        vim.treesitter.start(args.buf, language)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    vim.keymap.set({ "n", "x" }, "<C-space>", function()
      vim.treesitter.select("parent", vim.v.count1)
    end, { desc = "Select parent syntax node" })
    vim.keymap.set("x", "<BS>", function()
      vim.treesitter.select("child", vim.v.count1)
    end, { desc = "Select child syntax node" })
  end,
}
