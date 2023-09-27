local config = require("chromaword.config")
local utils = require("chromaword.utils")

local M = {}
M.enabled = false
M.highlights = {}
M.buffers = {}

local NAMESPACE_ID = vim.api.nvim_create_namespace("chromaword")
local HIGHLIGHT_NAME_PREFIX = "chromaword"
local AUGROUP = vim.api.nvim_create_augroup("chromaword", {})

function M.highlight(buf, start_line, end_line)
  buf = buf or vim.api.nvim_get_current_buf();
  start_line = start_line or 0;
  end_line = end_line or -1;
  local buf_lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, true);
  vim.api.nvim_buf_clear_namespace(buf, NAMESPACE_ID, start_line, end_line);

  local hl_start = config.options.highlight.start
  local hl_stop = config.options.highlight.stop
  for line_offset, line in ipairs(buf_lines) do
    regex = "[a-zA-Z]+";
    local start_idx, end_idx = string.find(line, regex);
    while start_idx and end_idx do
      local word = string.sub(line, start_idx, end_idx);
      local sum = 0;
      for idx = 1, #word do
        sum = sum + word:byte(idx) * (idx % 2 + 1);
        sum = sum % #config.options.highlight.colors;
      end
      local highlight_name = HIGHLIGHT_NAME_PREFIX .. sum + 1;

      local new_start_idx = math.floor((start_idx - 1) * (1 - hl_start) + (end_idx - 1) * hl_start);
      local new_end_idx = math.ceil((start_idx) * (1 - hl_stop) + (end_idx) * hl_stop);
      vim.api.nvim_buf_add_highlight(buf, NAMESPACE_ID, highlight_name, start_line + line_offset - 1, new_start_idx, new_end_idx);
      start_idx, end_idx = string.find(line, regex, end_idx + 1);
    end
  end
end

function M.attach(buf)
  if buf == nil or buf == 0 then
    buf = vim.api.nvim_get_current_buf();
  end
  M.highlight(buf, 0, -1)
  if not M.buffers[buf] then
    vim.api.nvim_buf_attach(buf, false, {
      on_lines = function(_event, _buf, _tick, first, _last, last_new)
        if M.enabled == false then
          return true
        end
        M.highlight(buf, first, last_new);
      end,
      on_detach = function()
        M.buffers[buf] = nil;
      end
    })
    M.buffers[buf] = true;
  end
end

function M.start()
  M.enabled = true;
  local bg_color = vim.api.nvim_get_color_by_name("bg")
  -- Create all possible highlight groups
  for i = 1, #config.options.highlight.colors do
    if not M.highlights[i] then
      local highlight_name = HIGHLIGHT_NAME_PREFIX .. i;
      local hl_bg = vim.api.nvim_get_color_by_name(config.options.highlight.colors[i]);
      hl_bg = utils.interpolate_color(bg_color, hl_bg, config.options.highlight.weight);
      hl_opts = config.options.highlight.opts
      for i, k in ipairs({ "fg", "bg", "sp" }) do
        if hl_opts[k] then
          hl_opts[k] = hl_bg
        end
      end
      vim.api.nvim_set_hl(0, highlight_name, hl_opts);
      M.highlights[i] = highlight_name
    end
  end
  M.attach(0);
  vim.api.nvim_create_autocmd({"BufEnter", "BufNew", "BufWinEnter"}, {
    group = AUGROUP,
    callback = function()
      M.attach(0);
    end
  })
end

function M.stop()
  M.enabled = false;
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1);
  vim.api.nvim_clear_autocmds({ group = AUGROUP });
end

function M.reload()
  M.stop()
  M.start()
end

return M
