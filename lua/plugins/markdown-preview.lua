return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && yarn install",
  ft =  { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  init = function() 
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_cloase = 1
    vim.g.mkdp_browser = ""
  end,
}
