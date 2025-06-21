local M = {}

function M.get_colors()
  local theme_path = vim.fn.expand("~/.config/hypr/themes/theme.conf")
  local colors = {}

  local file = io.open(theme_path, "r")
  if not file then
    return colors
  end

  for line in file:lines() do
    local key, rgba1 = line:match("^%s*([%w_.:-]+)%s*=%s*rgba%(([%x]+)%)")
    if key and rgba1 and #rgba1 >= 6 then
      local r, g, b = rgba1:sub(1, 2), rgba1:sub(3, 4), rgba1:sub(5, 6)
      colors[key] = "#" .. r .. g .. b
    end
  end

  file:close()
  return colors
end

return M
