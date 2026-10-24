-- Neovim Basic Options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- UI: standard cmdline and a single global statusline, rounded floats
opt.laststatus = 3
opt.winborder = "rounded"

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.splitright = true
opt.splitbelow = true
opt.wrap = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "popup" }

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
