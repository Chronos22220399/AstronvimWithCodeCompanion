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
            ["deepseek-ai/DeepSeek-V3"] = {},
          },
        },
      },
    })

    -- Qwen 适配器配置（用于快速响应）
    local qwen = adapters.extend("openai_compatible", {
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
        parameters = {
          temperature = 0.7,
          top_p = 0.7,
          max_tokens = 512,
          stream = true  -- 启用流式响应加速输出
        }
      }
    })
    
    require("codecompanion").setup({
      adapters = {
        siliconflow_r1 = function() return siliconflow_r1 end,
        qwen = function() return qwen end,
      },

      -- 策略配置
      strategies = {
        -- 默认代码操作使用 Qwen（快速）
        inline = {
          adapter = "qwen",
          parameters = {
            model = "Qwen/QwQ-32B",
          }
        },

        -- 聊天对话使用 DeepSeek（逻辑推理）
        chat = {
          adapter = "siliconflow_r1",
          parameters = {
            model = "deepseek-ai/DeepSeek-R1",
            temperature = 0.3,  -- 更低温度增强确定性
            max_tokens = 1024
          }
        }
      },
      
      opts = {
        language = "Chinese",
      },

      prompt_library = {
        ["DeepSeek Explain In Chinese"] = {
          strategy = "chat",
          description = "中文解释代码",
          opts = {
            index = 5,
            is_default = true,
            is_slash_cmd = false,
            modes = { "v" },
            short_name = "explain in chinese",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
            adapter = {
              name = "siliconflow_r1",
              model = "deepseek-ai/DeepSeek-R1",
            }
          },
          prompts = {
            {
              role = "system",
              content = [[当被要求解释代码时，请遵循以下步骤：

1. 识别编程语言。
2. 描述代码的目的，并引用该编程语言的核心概念。
3. 解释每个函数或重要的代码块，包括参数和返回值。
4. 突出说明使用的任何特定函数或方法及其作用。
5. 如果适用，提供该代码如何融入更大应用程序的上下文。]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local input = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return string.format(
                  [[请解释 buffer %d 中的这段代码:

```%s
%s
```]],
                  context.bufnr,
                  context.filetype,
                  input
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        
        ["快速代码建议"] = {
          strategy = "inline",
          description = "Qwen 快速代码建议",
          opts = {
            modes = { "n", "v" },
            auto_submit = true,
            adapter = {
              name = "qwen",
              model = "Qwen/QwQ-32B"
            }
          },
          prompts = {
            {
              role = "system",
              content = "你是一个高效的代码助手，请用最简洁的方式给出代码建议",
              opts = { visible = false }
            }
          }
        },
      },

    })

    -- 快捷键设置
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 主输入框（顶部弹出输入栏）
    map("n", "<leader>at", "<cmd>CodeCompanion<CR>", {
      desc = "Open CodeCompanion input (main UI)",
    })

    -- Chat 聊天界面
    map("n", "<leader>aj", "<cmd>CodeCompanionChat<CR>", {
      desc = "Open CodeCompanion Chat UI",
    })

    -- Actions 动作面板
    map("n", "<leader>aa", "<cmd>CodeCompanionActions<CR>", {
      desc = "Open CodeCompanion Actions UI",
    })

    -- Cmd 模式（自然语言 Vim 命令）
    map("n", "<leader>ax", "<cmd>CodeCompanionCmd<CR>", {
      desc = "Run natural language Vim command",
    })
  end,
}
