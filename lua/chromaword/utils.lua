local M = {}

function M.num_to_color(num)
  return { num % 256, (num / 256) % 256, num / 256 ^ 2 };
end

function M.interpolate_color(color1, color2, weight)
  color1 = M.num_to_color(color1);
  color2 = M.num_to_color(color2);
  local color = {};
  for i = 1, 3 do
    color[i] = (1 - weight) * color1[i] + weight * color2[i];
  end
  return string.format("#%02x%02x%02x", color[1], color[2], color[3]);
end

return M
