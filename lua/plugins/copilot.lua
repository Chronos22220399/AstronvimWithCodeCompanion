return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- 禁用内建 suggestion，交由 cmp 接管
        },
        panel = {
          enabled = false,
        },
      })
    end,
  }
}
