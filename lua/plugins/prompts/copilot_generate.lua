return {
  strategy = "inline", -- 适用于代码生成和补全
  description = "使用 Copilot 生成代码或注释（Oxygen 风格）",
  opts = {
    is_slash_cmd = false,
    modes = { "n", "v" }, -- 支持普通模式和可视模式
    short_name = "generate with copilot",
    auto_submit = true,
    user_prompt = false,
    stop_context_insertion = true,
    adapter = {
      name = "copilot",
      model = "claude-3.7-sonnet", -- 使用 Copilot 的默认模型
    },
  },
  prompts = {
    -- 系统提示：告诉 Copilot 如何生成代码或注释
    {
      role = "system",
      content = [[当被要求生成代码或注释时，请遵守以下规则：

1. 如果是生成代码，请根据用户提供的上下文补全代码。
2. 如果是生成注释，请使用 Oxygen 注释风格。
3. 注释必须简单明了，描述函数的功能、参数和返回值。
4. 对于注释，格式如下：
   /**
    * 描述函数的目的。
    *
    * @param 参数名 参数的描述。
    * @return 返回值的描述。
    */
5. 如果代码不完整，请智能补全。
6. 始终根据用户上下文生成最相关的结果。
]],
      opts = {
        visible = false, -- 系统提示不会显示给用户
      },
    },
    -- 用户提示：生成代码或注释
    {
      role = "user",
      content = function(context)
        local input = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

        return string.format(
          [[请根据以下上下文生成代码或注释（Oxygen 风格）:]],
          context.filetype,
          input
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
