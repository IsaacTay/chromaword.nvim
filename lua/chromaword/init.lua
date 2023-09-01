local config = require("chromaword.config")

local M = {}

M.setup = config.setup

function M.enable()
  M.setup();
  require("chromaword.highlight").start()
end

function M.disable()
  require("chromaword.highlight").stop()
end

function M.toggle()
  local highlight = require("chromaword.highlight")
  if highlight.enabled then
    M.disable()
  else
    M.enable()
  end
end

return M
