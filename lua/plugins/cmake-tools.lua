return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap"  -- 调试依赖（可选）
    },
    config = function()
      require("cmake-tools").setup {
        -- 基础配置
      }
    end
  },
}
