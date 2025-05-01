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
      },
    })

    -- 快捷键设置
    vim.keymap.set({ "n", "v", "x" }, "<leader>aa", function()
      require("codecompanion").toggle()
    end, { desc = "Toggle CodeCompanion (UI)" })

    vim.keymap.set({ "n", "v", "x" }, "<leader>ap", "<cmd>CodeCompanionActions<CR>", {
      desc = "Open CodeCompanion Actions (UI)",
    })
  end,
}
