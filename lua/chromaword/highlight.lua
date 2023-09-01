local config = require("chromaword.config")
local utils = require("chromaword.utils")

local M = {}
M.enabled = true
M.highlights = {}

local NAMESPACE_ID = vim.api.nvim_create_namespace("chromaword")
local HIGHLIGHT_NAME_PREFIX = "chromaword"

function number_to_hex(num)
  return string.format("%x", num)
end

function M.highlight()
  local buf = vim.api.nvim_get_current_buf();
  local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true);

  -- Create all possible highlight groups
  for line_no, line in ipairs(buf_lines) do
    regex = "[a-zA-Z]+";
    local start_idx, end_idx = string.find(line, regex);
    while start_idx and end_idx do
      local word = string.sub(line, start_idx, end_idx);
      local sum = 0;
      for idx = 1, #word do
        sum = sum + word:byte(idx) * (idx % 2 + 1);
        sum = sum % #config.options.colors;
      end
      local highlight_name = HIGHLIGHT_NAME_PREFIX .. sum + 1;
      vim.api.nvim_buf_add_highlight(buf, NAMESPACE_ID, highlight_name, line_no - 1, start_idx - 1, end_idx);
      start_idx, end_idx = string.find(line, regex, end_idx + 1);
    end
  end
end

function M.start()
  M.enabled = true;
  local bg_color = vim.api.nvim_get_color_by_name("bg")
  for i = 1, #config.options.colors do
    if not M.highlights[i] then
      local highlight_name = HIGHLIGHT_NAME_PREFIX .. i;
      local hl_bg = vim.api.nvim_get_color_by_name(config.options.colors[i]);
      hl_bg = utils.interpolate_color(bg_color, hl_bg, config.options.hl_weight);
      vim.api.nvim_set_hl(0, highlight_name,
        { bg = hl_bg }); -- string.format("%06x", (i ^ 10 + 244) % (2 ^ 24))
      M.highlights[i] = highlight_name
    end
  end
  M.highlight();
end

function M.stop()
  M.enabled = false;
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1);
end

return M
