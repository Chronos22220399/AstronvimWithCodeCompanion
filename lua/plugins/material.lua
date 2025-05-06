return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- 设置主题风格：可选 "darker", "lighter", "palenight", "deep ocean", "oceanic"
    vim.g.material_style = "darker" -- 推荐 "darker" 或 "deep ocean"

    require("material").setup({
      contrast = {
        terminal = true,
        sidebars = true,
        floating_windows = true,
        cursor_line = true,
        non_current_windows = true,
      },
      plugins = {
        "gitsigns",
        "nvim-cmp",
        "nvim-tree",
        "telescope",
        "trouble",
        "which-key",
        "indent-blankline",
      },
      high_visibility = {
        darker = true, -- 强对比
      },
      disable = {
        background = false,
        borders = false,
        end_of_buffer_lines = false,
        italic_comments = true,
      },
    })

    vim.cmd("colorscheme material")
  end,
}
