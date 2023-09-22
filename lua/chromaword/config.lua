local M = {}


local defaults = {
  colors = {
    "blue", "green", "red", "yellow", "purple", "cyan"
  },
  hl_weight = 0.2,
  hl_args = {
    bg = true,
  }
}

M.options = defaults

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  require("chromaword.highlight").start()
end

return M
