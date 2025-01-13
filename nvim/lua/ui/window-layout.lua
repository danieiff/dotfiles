-- require 'focus'.setup { ui = { signcolumn = false } }
-- AUC('WinEnter', { callback = function(_) vim.w.focus_disable = vim.wo.winfixwidth or vim.wo.winfixheight end })

local function edgy_help_win_filter(pos)
  return function(_)
    -- local is_vimhelp = vim.bo[buf].buftype == 'help' -- don't open help files in edgy that we're editing
    local is_only_win = #vim.tbl_filter(function(win)
      return CHECK_FILE_MODIFIABLE(vim.api.nvim_win_get_buf(win))
    end, vim.api.nvim_tabpage_list_wins(0)) >= 1
    local has_width = (pos == 'top' and vim.o.columns < 180) or (pos ~= 'top' and vim.o.columns >= 180)
    return is_only_win and has_width
  end
end

local edgy_opts = {
  top = {
    { title = 'Overseer List', ft = 'OverseerList' },
    { title = 'Overseer task', ft = '',                 filter = function(buf) return vim.b[buf].overseer_task ~= nil end },
    { ft = "help",             size = { height = 0.4 }, filter = edgy_help_win_filter 'top' },
  },
  bottom = {
    "Trouble",
    { title = "QuickFix",       ft = "qf" },
    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
  },
  left = {
    { title = 'Git Log',         ft = 'git',            size = { width = 0.3 },                                       pinned = true, open = 'G reflog', },
    { title = 'Undo Tree',       ft = 'undotree',       open = 'UndoTreeToggle' },
    { title = 'Undo diff',       ft = 'diff',           filter = function(buf) return vim.b[buf].isUndotreeBuffer end },
    { title = "Neotest Summary", ft = "neotest-summary" },
    { title = 'Avante',          ft = 'Avante',         size = { width = 0.4 } }, 'AvanteInput',
    { title = "DiffviewFiles", ft = "DiffviewFiles",  size = { width = 0.2 } },
    { ft = "help",             size = { width = 78 }, filter = edgy_help_win_filter 'right' },
  },
  right = {
    { title = 'Aerial',     ft = 'aerial',   pinned = true,          open = require 'aerial'.toggle },
    { title = 'NvimTree',   ft = 'NvimTree', pinned = true,          open = require 'nvim-tree.api'.tree.toggle },
    { title = 'Git Status', ft = 'fugitive', size = { width = 0.3 }, pinned = true,                             open = 'G', wo = { number = false }, },
    { title = 'Grug Far',   ft = 'grug-far', size = { width = 0.4 } },
  },
  options = {
    left = { size = 20 },
    right = { size = 0.2 },
  },
  wo = {
    winfixheight = true
  },
  keys = {
    ['<a-l>'] = function(win) win:resize('width', 2) end,
    ['<a-h>'] = function(win) win:resize('width', -2) end,
    ['<a-k>'] = function(win) win:resize('height', 2) end,
    ['<a-j>'] = function(win) win:resize('height', -2) end,
  },
}

for _, pos in ipairs { 'top', 'bottom', 'left', 'right' } do
  edgy_opts[pos] = edgy_opts[pos] or {}
  table.insert(edgy_opts[pos], {
    ft = 'trouble',
    filter = function(_, win)
      return vim.w[win].trouble
          and vim.w[win].trouble.position == pos
          and vim.w[win].trouble.type == "split"
          and vim.w[win].trouble.relative == "editor"
          and not vim.w[win].trouble_preview
    end,
  })
end
require 'edgy'.setup(edgy_opts)
K(';', require 'edgy'.toggle)
