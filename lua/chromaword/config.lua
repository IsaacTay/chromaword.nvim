local M = {}

M.options = {}

local defaults = {
  colors = {
    "blue", "green", "red", "yellow", "purple", "cyan"
  },
  hl_weight = 0.2
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
