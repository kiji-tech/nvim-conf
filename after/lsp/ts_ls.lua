-- ~/.config/nvim/lsp/ts_ls.lua

-- This function defines the specific settings for the ts_ls server.
-- Neovim core handles the `setup` equivalent internally.
-- You can customize options here.

vim.lsp.config('ts_ls', {
  -- cmd is automatically sourced from nvim-lspconfig defaults
  -- if not specified here.
  -- cmd = { "typescript-language-server", "--stdio" },

  -- Example of disabling type checking in JavaScript files
  settings = {
    typescript = {
      check = {
        -- disable type checking in .js files
        disableSemanticValidation = true,
      },
    },
    -- other settings...
  },

  -- on_attach function to set up keymaps, etc. (optional but recommended)
  on_attach = function(client, bufnr)
    -- Enable default Neovim LSP keymaps
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Go to Declaration' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to Definition' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documentation' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Go to Implementation' })
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { buffer = bufnr, desc = 'List References' })
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename Symbol' })
    vim.keymap.set({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code Action' })
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = 'Format Buffer' })
    -- Add more keymaps or autocmds here
  end,
})

-- Enable the server for its configured filetypes (ts, tsx, js, jsx)
-- This function replaces the old require('lspconfig').ts_ls.setup{} call.
vim.lsp.enable('ts_ls')

