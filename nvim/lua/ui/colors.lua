-- Credits: https://github.com/folke/dot/blob/master/nvim/lua/util/stuff/colors.lua
local M = {}

M.ns = vim.api.nvim_create_namespace 'lsp.colors'

---@type table<string,true>
M.hl = {}

---@param hex string
function M.get_hl(hex)
  local hl = "LspColor" .. hex:sub(2)
  if not M.hl[hl] then
    M.hl[hl] = true
    vim.api.nvim_set_hl(0, hl, { bg = hex })
  end
  return hl
end

function M.update(buf)
  local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
  vim.lsp.buf_request(buf, "textDocument/documentColor", params, function(err, colors)
    if err then return end

    for _, c in ipairs(colors) do
      local color = c.color
      color.red = math.floor(color.red * 255 + 0.5)
      color.green = math.floor(color.green * 255 + 0.5)
      color.blue = math.floor(color.blue * 255 + 0.5)
      local hex = string.format("#%02x%02x%02x", color.red, color.green, color.blue)

      vim.api.nvim_buf_set_extmark(buf, M.ns, c.range.start.line,
        vim.lsp.util._get_line_byte_from_position(buf, c.range.start, 'utf-8'), {
          end_row = c.range["end"].line,
          end_col = vim.lsp.util._get_line_byte_from_position(buf, c.range["end"], 'utf-8'),
          hl_group = M.get_hl(hex),
          priority = 5000,
        })
    end
  end)
end

M.c = 1

function M.buf_attach(bufnr)
  M.update(bufnr)
  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      M.c = M.c + 1
      vim.print(bufnr .. ' ' .. M.c)
      M.update(bufnr)
    end
  })
end

return M
