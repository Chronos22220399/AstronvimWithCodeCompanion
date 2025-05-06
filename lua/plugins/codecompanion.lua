return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",  -- 可选
    "stevearc/dressing.nvim",         -- 可选
    "echasnovski/mini.diff",          -- 差异显示
    "j-hui/fidget.nvim",
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
            ["deepseek-ai/DeepSeek-V3"] = {},
          },
        },
      },
    })

    -- Qwen 适配器配置（用于快速响应）
    local qwen = adapters.extend("openai", {
      name = "qwen",
      url = "https://api.siliconflow.cn/v1/chat/completions",
      env = {
        api_key = function()
          return os.getenv("DEEPSEEK_API_KEY_S")
        end,
      },
      schema = {
        model = {
          default = "Qwen/QwQ-32B",
          choices = { "Qwen/QwQ-32B" }
        },
      }
    })

    local copilot = adapters.extend("copilot", {
      name = "copilot",
      env = {
        github_token = function()
          return os.getenv("GITHUB_TOKEN")
        end,
      },
      schema = {
        model = {
          default = "claude-3.7-sonnet",
        },
      },
    })
    
    require("codecompanion").setup({
      log_level = "DEBUG",
      
      adapters = {
        siliconflow_r1 = function() return siliconflow_r1 end,
        qwen = function() return qwen end,
      },

      -- 策略配置
      strategies = {
        -- 默认代码操作使用 Qwen（快速）
        inline = {
          adapter = "copilot",
        },

        -- 聊天对话使用 DeepSeek（逻辑推理）
        chat ={
          adapter = "siliconflow_r1",
          -- adapter = "copilot",
        }
      },

      opts = {
        language = "Chinese",
      },

      --------------------------
      
      prompt_library = {
        ["Copilot Generate"] = require("plugins.prompts.copilot_generate"),
      },
    })

    -- 快捷键设置
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 主输入框（顶部弹出输入栏）
    map({ "n", "v", "x" }, "<leader>at", "<cmd>CodeCompanion<CR>", {
      desc = "Open CodeCompanion input (main UI)",
    })
    -- Chat 聊天界面
    map({ "n", "v", "x" }, "<leader>aj", "<cmd>CodeCompanionChat<CR>", {
      desc = "Open CodeCompanion Chat UI",
    })
    -- Actions 动作面板
    map({ "n", "v", "x" }, "<leader>aa", "<cmd>CodeCompanionActions<CR>", {
      desc = "Open CodeCompanion Actions UI",
    })
    -- Cmd 模式（自然语言 Vim 命令）
    map({ "n", "v", "x" }, "<leader>ax", "<cmd>CodeCompanionCmd<CR>", {
      desc = "Run natural language Vim command",
    })

    -- 接受更改
    map({ "n", "v", "i" }, "<leader>ac", "<cmd>CodeCompanionAccept<CR>", {
      desc = "Accept changes",
    })
    -- 拒绝更改
    map({ "n", "v", "i" }, "<leader>ar", "<cmd>CodeCompanionReject<CR>", {
      desc = "Reject changes",
    })
    
    require("plugins.codecompanion.fidget").init()
  end,
}




