return {
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" }, -- 明确声明依赖
    opts = {
      keywords = {
        MARK = {
          icon = " ",        -- 图标后加空格更美观
          color = "info",
          alt = { "SECTION", "NOTE" },
        },
      },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },
}
