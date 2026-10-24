return {
    'wsdjeg/hop.nvim',
    version = "*",
    config = function()
        local hop = require('hop')
        hop.setup()

        local function map(lhs, fn, desc)
            vim.keymap.set({ "n", "v" }, lhs, fn, { desc = desc })
        end

        map("<leader>hw", function() hop.hint_words() end, "Hop to word")
        map("<leader>hs", function() hop.hint_patterns() end, "Hop to string pattern")
        map("<leader>hc", function() hop.hint_char1() end, "Hop to char")
        map("<leader>h2", function() hop.hint_char2() end, "Hop to 2-char sequence")
        map("<leader>hl", function() hop.hint_lines_skip_whitespace() end, "Hop to line")
        map("<leader>ha", function() hop.hint_anywhere() end, "Hop anywhere")
    end,
}
