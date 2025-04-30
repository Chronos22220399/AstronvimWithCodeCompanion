return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",  -- 可选
    "stevearc/dressing.nvim",         -- 可选
  },
  config = function()
    local adapters = require("codecompanion.adapters")

    local siliconflow_r1 = adapters.extend("deepseek", {
      name = "siliconflow_r1",
      url = "https://api.siliconflow.cn/v1/chat/completions",
      env = {
        api_key = function()
          return os.getenv("DEEPSEEK_API_KEY_S")
        end,
      },
      schema = {
        model = {
          default = "deepseek-ai/DeepSeek-R1",
          choices = {
            ["deepseek-ai/DeepSeek-R1"] = { opts = { can_reason = true } },
            "deepseek-ai/DeepSeek-V3",
          },
        },
      },
    })

    require("codecompanion").setup({
      adapters = {
        siliconflow_r1 = function() return siliconflow_r1 end,
      },
      strategies = {
        chat = { adapter = "siliconflow_r1" },
        inline = {
          adapter = "siliconflow_r1",
          parameters = {
            model = "deepseek-ai/DeepSeek-V3",
          },
        },
        agent = { adapter = "siliconflow_r1" },
      },
      opts = {
        language = "Chinese",
      },
    })

    -- 快捷键设置（注意位置必须在 setup() 调用之后）
    vim.keymap.set({ "n", "v", "x" }, "<leader>aa", function()
      require("codecompanion").toggle()
    end, { desc = "Toggle CodeCompanion (UI)" })

    vim.keymap.set({ "n", "v", "x" }, "<leader>ap", "<cmd>CodeCompanionActions<CR>", {
      desc = "Open CodeCompanion Actions (UI)",
    })

    vim.keymap.set({ "n", "v", "x" }, "<leader>ai", function()
      require("codecompanion.inline").chat()
    end, { desc = "Inline Chat (CodeCompanion)" })

    vim.keymap.set({ "n", "v", "x" }, "<leader>ah", function()
      require("codecompanion.inline").explain()
    end, { desc = "Explain Code (Inline)" })
  end,
}
