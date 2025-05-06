return {
  "j-hui/fidget.nvim",
  tag = "legacy", -- 使用稳定版本
  event = "LspAttach", -- 在 LSP 附加时加载
  config = function()
    require("fidget").setup({})
  end,
}
