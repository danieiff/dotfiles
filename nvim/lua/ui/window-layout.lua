local function edgy_help_win_filter(pos)
  return function(bufnr)
    if vim.fn.bufname(bufnr) == '_FzfLuaHelp' then
      return false
    end

    local is_only_win = #vim.tbl_filter(function(win)
      return CHECK_FILE_MODIFIABLE(vim.api.nvim_win_get_buf(win))
    end, vim.api.nvim_tabpage_list_wins(0)) >= 1
    local has_width = (pos == 'top' and vim.o.columns < 180) or (pos ~= 'top' and vim.o.columns >= 180)
    return is_only_win and has_width
  end
end

local edgy_opts = {
  top = {
    { title = 'Overseer List', ft = 'OverseerList',     size = { width = 0.2, height = 0.5 } },
    { title = 'Overseer task', ft = '',                 filter = function(buf) return vim.b[buf].overseer_task ~= nil end },
    { ft = "help",             size = { height = 0.5 }, filter = edgy_help_win_filter 'top' },
    { ft = "man",              size = { height = 0.5 } },
  },
  bottom = {
    "Trouble",
    { title = "QuickFix",       ft = "qf" },
    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
    'iron'
  },
  left = {
    { title = 'Undo Tree',       ft = 'undotree',       open = 'UndoTreeToggle' },
    { title = 'Undo diff',       ft = 'diff',           filter = function(buf) return vim.b[buf].isUndotreeBuffer end },
    { title = "Neotest Summary", ft = "neotest-summary" },
    { title = 'Avante',          ft = 'Avante',         size = { width = 0.4 } }, 'AvanteInput',
    { ft = "help", size = { width = 78 }, filter = edgy_help_win_filter 'left' },
  },
  right = {
    { title = 'Aerial',   ft = 'aerial',   pinned = true,         open = require 'aerial'.toggle },
    { title = 'NvimTree', ft = 'NvimTree', pinned = true,         open = require 'nvim-tree.api'.tree.toggle },
    { title = 'Grug Far', ft = 'grug-far', size = { width = 0.4 } },
  },
  options = {
    left = { size = 20 },
    right = { size = 0.2 },
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
K(';;', require 'edgy'.toggle)

AUC('WinEnter', {
  nested = true,
  desc = 'auto resize non-edgy windows',
  callback = function(ev)
    if vim.b[ev.buf].edgy_keys or vim.api.nvim_win_get_config(0).relative ~= '' then return end

    local editor_width, editor_height = vim.o.columns, vim.o.lines - 2

    local current_win = vim.api.nvim_get_current_win()
    local current_win_line_start, current_win_col_start = unpack(vim.api.nvim_win_get_position(current_win))
    local current_win_line_end = current_win_line_start + vim.api.nvim_win_get_height(current_win)
    local current_win_col_end = current_win_col_start + vim.api.nvim_win_get_width(current_win)

    local edgy_sizes = { top = 0, bottom = 0, left = 0, right = 0 }
    local horizontal_splits, vertical_splits = {}, {}

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local win_cfg = vim.api.nvim_win_get_config(win)
      if win_cfg.relative == '' then
        local edgy_win = require 'edgy'.get_win(win)

        if edgy_win and edgy_sizes[edgy_win.view.edgebar.pos] == 0 then
          edgy_sizes[edgy_win.view.edgebar.pos] =
              (edgy_win.view.edgebar.vertical and edgy_win.width or edgy_win.height) + 1
        else
          local win_line_start, win_col_start = unpack(vim.api.nvim_win_get_position(win))
          local win_line_end, win_col_end = win_line_start + win_cfg.height, win_col_start + win_cfg.width

          if win_cfg.height < editor_height then
            if not (win_col_end < current_win_col_start or current_win_col_end < win_col_start) then
              table.insert(horizontal_splits, win)
            end
          end
          if win_cfg.width < editor_width then
            if not (win_line_end < current_win_line_start or current_win_line_end < win_line_start) then
              table.insert(vertical_splits, win)
            end
          end
        end
      end
    end

    local other_horizontal_splits_cnt = #horizontal_splits - 1
    if other_horizontal_splits_cnt > 0 then
      local non_edgy_height = editor_height - other_horizontal_splits_cnt - edgy_sizes.top - edgy_sizes.bottom
      local new_current_win_height = math.floor(non_edgy_height * 2 / 3)
      local rest_distributed_height = math.floor((non_edgy_height - new_current_win_height) / other_horizontal_splits_cnt)
      local rest_distributed_remainder_height = (non_edgy_height - new_current_win_height) % other_horizontal_splits_cnt
      new_current_win_height = new_current_win_height + rest_distributed_remainder_height

      for _, win in ipairs(horizontal_splits) do
        vim.api.nvim_win_set_height(win, win == current_win and new_current_win_height or rest_distributed_height)
      end
    end

    local other_vertical_splits_cnt = #vertical_splits - 1
    if other_vertical_splits_cnt > 0 then
      local non_edgy_width = editor_width - other_vertical_splits_cnt - edgy_sizes.left - edgy_sizes.right
      local new_current_win_width = math.floor(non_edgy_width * 2 / 3)
      local rest_distributed_width = math.floor((non_edgy_width - new_current_win_width) / other_vertical_splits_cnt)
      local rest_distributed_remainder_width = (non_edgy_width - new_current_win_width) % other_vertical_splits_cnt
      new_current_win_width = new_current_win_width + rest_distributed_remainder_width

      for _, win in ipairs(vertical_splits) do
        vim.api.nvim_win_set_width(win, win == current_win and new_current_win_width or rest_distributed_width)
      end
    end
  end
})
