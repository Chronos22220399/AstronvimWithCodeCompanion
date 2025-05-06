return {
  "wfxr/minimap.vim",
  -- build = "cargo install --locked code-minimap",
  cmd = { "Minimap", "MinimapClose", "MinimapToggle" },
  keys = {
    { "<leader>mm", "<cmd>MinimapToggle<CR>", desc = "Toggle Minimap" },
  },
  init = function()
    vim.g.minimap_width = 10
    vim.g.minimap_auto_start = 1
    vim.g.minimap_auto_start_win_enter = 1
    vim.g.minimap_git_colors = 1
    vim.g.minimap_highlight_range = 1
    vim.g.minimap_block_filetypes = { "fugitive", "neo-tree", "lazy", "mason" }
  end,
  enabled = vim.fn.executable("code-minimap") == 1,
}
