-- LSP: the shared client setup only. No language server is installed here;
-- install one with :Mason and mason-lspconfig enables it automatically.

-- Built-in completion and keymaps. Neovim 0.11+ already provides
-- K, grn, gra, gri, grr, <C-s> (insert) and [d / ]d.
local function on_attach(client, bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

  if client:supports_method("textDocument/completion") then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format buffer")
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Bridge between mason.nvim and nvim-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
  },

  -- nvim-lspconfig: upstream defaults the configurations above extend
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Shared setup runs from LspAttach rather than from a per-server
      -- on_attach, so that a server extending the nvim-lspconfig defaults
      -- cannot drop it.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            on_attach(client, args.buf)
          end
        end,
      })
    end,
  },
}
