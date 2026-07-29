local servers = {
  "bashls",
  "clangd",
  "gopls",
  "jsonls",
  "lua_ls",
  "omnisharp",
  "pyright",
  "rust_analyzer",
  "vtsls",
  "yamlls",
  "zls",
}

local function setup_buffer(client, bufnr)
  if client:supports_method("textDocument/completion", bufnr) then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  if client:supports_method("textDocument/formatting", bufnr) then
    local group = vim.api.nvim_create_augroup("LspFormat", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
      end,
    })
  end

  if client:supports_method("textDocument/documentHighlight", bufnr) then
    local group = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall" },
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      vim.opt.completeopt = { "menuone", "noinsert", "popup" }

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConfig", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            setup_buffer(client, event.buf)
          end
        end,
      })

      vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
        desc = "Trigger completion",
      })

      local extra = require("mini.extra")
      vim.keymap.set("n", "<leader>cd", function()
        extra.pickers.diagnostic({ scope = "current" })
      end, { desc = "Buffer diagnostics" })
      vim.keymap.set("n", "<leader>cs", function()
        extra.pickers.lsp({ scope = "document_symbol" })
      end, { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>cS", function()
        extra.pickers.lsp({ scope = "workspace_symbol_live" })
      end, { desc = "Workspace symbols" })
      vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format buffer" })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = servers,
      })
    end,
  },
}
