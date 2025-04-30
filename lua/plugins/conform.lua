return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      cpp = { "clang-format" },
    },
  },
  cmd = { "ConformInfo", "Format" }, -- 注册命令
  keys = {
    { "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
  },
}
