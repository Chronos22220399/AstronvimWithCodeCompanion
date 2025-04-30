return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- 必须禁用懒加载
    priority = 1000, -- 优先级需高于其他主题插件
    config = function()
      require("tokyonight").setup({
        -- 推荐配置参数
        style = "storm",        -- 可选 storm | night | day
        transparent = false,    -- 透明背景模式
        terminal_colors = true,  -- 终端色彩支持
        styles = {
          comments = { italic = true },  -- 注释斜体
          keywords = { italic = false }, -- 关键字不斜体
          functions = { bold = true }   -- 函数名粗体
        },
        -- 窗口组件增强
        sidebars = { "qf", "vista_kind", "terminal", "packer" },
        hide_inactive_statusline = true -- 隐藏非活动状态栏
      })
    end
  }
}
