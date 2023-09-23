local M = {}


local defaults = {
  highlight = {
    colors = {
      "blue", "green", "red", "yellow", "purple", "cyan"
    },
    
    weight = 0.2,
    opts = {
      bg = true,
    }
  }
}

M.options = defaults

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  require("chromaword.highlight").start()
end

return M
