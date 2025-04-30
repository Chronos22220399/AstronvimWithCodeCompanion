-- plugins.lua
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap").adapters.cpp = {
        type = "executable",
        command = "path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      }
    end
  },
}
