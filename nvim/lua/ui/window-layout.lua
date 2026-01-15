local ft_layouts = {
  OverseerList = {
    pos = 'top', width = 0.2, height = 0.4,
  },
  overseer_task = {
    pos = 'top'
  },
  iron = {
    pos = 'bottom'
  },
  Avante = {
    pos = 'left'
  },
  AvanteInput = {
    pos = 'left'
  },
  ['neotest-summary'] = {
    pos = 'left'
  },
  ['neotest-output-panel'] = {
    pos = 'bottom', height = 15
  },
  ['time-machine-list'] = {
    pos = 'left'
  },
  help = {
    pos = 'left',
    width = 80,
    filter = function(buf)
      if vim.fn.bufname(buf) == '_FzfLuaHelp' then return false end

      local is_only_win = #vim.tbl_filter(function(win)
        return CHECK_FILE_MODIFIABLE(vim.api.nvim_win_get_buf(win))
      end, vim.api.nvim_tabpage_list_wins(0)) < 1

      return not is_only_win
    end
  },
  man = {
    pos = 'top', filter = function(_, win) return not vim.w[win].fzf_lua_preview end
  },
  aerial = {
    pos = 'right'
  },
  NvimTree = {
    pos = 'right',
    filter = function()
      local is_only_win = #vim.tbl_filter(function(win)
        return CHECK_FILE_MODIFIABLE(vim.api.nvim_win_get_buf(win))
      end, vim.api.nvim_tabpage_list_wins(0)) < 1
      return not is_only_win
    end
  },
  ['grug-far'] = {
    pos = 'right', width = 0.4
  },
  trouble = {
    pos = function(w) return vim.w[w].trouble.position end,
    filter = function(_, w)
      return vim.w[w].trouble.type == 'split' and vim.w[w].trouble.relative == 'editor' and
          not vim.w[w].trouble_preview
    end
  },
  qf = {
    pos = 'bottom',
  }
}

LAYOUTS = {}

local function get_size(size, is_vertical)
  return math.floor(size > 1 and size or ((is_vertical and (vim.o.lines - 2) or vim.o.columns) * size))
end

AUC('WinResized', {
  desc = 'layout side windows',
  group = vim.api.nvim_create_augroup('SideWindowLayout', { clear = true }),
  callback = function(ev)
    if vim.v.exiting ~= vim.NIL or vim.fn.getcmdwintype() ~= "" or vim.bo[ev.buf].filetype == '' then
      return
    end

    local current_tabpage = vim.api.nvim_get_current_tabpage()
    LAYOUTS[current_tabpage] = LAYOUTS[current_tabpage] or { top = {}, bottom = {}, left = {}, right = {} }

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tabpage)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local layout = ft_layouts[vim.bo[buf].filetype]
      if vim.b[buf].overseer_task then
        layout = ft_layouts['overseer_task']
      end
      if layout and not vim.w[win].side_layout and (type(layout.filter) ~= 'function' or layout.filter(buf, win)) then
        local pos = type(layout.pos) == 'function' and layout.pos(win) or layout.pos
        table.insert(LAYOUTS[current_tabpage][pos], { win = win, width = layout.width, height = layout.height })
        vim.w[win].side_layout = pos
      end
    end

    for _, pos in ipairs { 'top', 'bottom', 'left', 'right' } do
      local layouts                 = LAYOUTS[current_tabpage][pos]
      local is_vertical             = pos == 'top' or pos == 'bottom'
      local main_size               = get_size(pos == 'top' and 0.5 or 0.2, is_vertical)
      local main_size_key           = is_vertical and 'height' or 'width'
      local cross_size_key          = is_vertical and 'width' or 'height'
      local available_cross_size    =
          (is_vertical and vim.o.columns or (vim.o.lines - 2)) - (#LAYOUTS[current_tabpage][pos] - 1)
      local rest_distribution_cnt   = #LAYOUTS[current_tabpage][pos]

      local last_side
      LAYOUTS[current_tabpage][pos] = vim.tbl_filter(function(w)
        if vim.api.nvim_win_is_valid(w.win) then
          local layout_success = true
          if not last_side then
            vim.api.nvim_win_call(w.win,
              function() vim.cmd.wincmd(({ left = 'H', right = 'L', top = 'K', bottom = 'J' })[pos]) end)
          else
            layout_success = pcall(vim.fn.win_splitmove, w.win, last_side.win,
              { vertical = pos == 'top' or pos == 'bottom', rightbelow = true })
          end
          if layout_success then
            last_side = w
          else
            vim.notify('Failed to layout ' .. w.win .. ' next to ' .. last_side.win, vim.log.levels.WARN)
          end

          main_size = math.max(main_size, get_size(w[main_size_key] or 0, is_vertical))
          available_cross_size = available_cross_size - get_size(w[cross_size_key] or 0, not is_vertical)
          rest_distribution_cnt = rest_distribution_cnt - (w[cross_size_key] and 1 or 0)

          return true
        end
        return false
      end, layouts)

      local rest_cross_size         = rest_distribution_cnt == 0 and 0 or
          math.floor(available_cross_size / rest_distribution_cnt)

      for i, w in ipairs(LAYOUTS[current_tabpage][pos]) do
        if i == 1 then
          vim.api['nvim_win_set_' .. main_size_key](w.win, main_size)
        end
        vim.api['nvim_win_set_' .. cross_size_key](w.win, get_size(w[cross_size_key] or rest_cross_size, not is_vertical))
      end
    end
  end
})

AUC('WinEnter', {
  desc = 'auto resize windows',
  group = vim.api.nvim_create_augroup('MainWindowLayout', { clear = true }),
  nested = true,
  callback = function(ev)
    local editor_width, editor_height = vim.o.columns, vim.o.lines - 2

    local current_win = vim.api.nvim_get_current_win()
    local current_win_line_start, current_win_col_start = unpack(vim.api.nvim_win_get_position(current_win))
    local current_win_line_end = current_win_line_start + vim.api.nvim_win_get_height(current_win)
    local current_win_col_end = current_win_col_start + vim.api.nvim_win_get_width(current_win)

    local horizontal_splits, vertical_splits = {}, {}

    if vim.api.nvim_win_get_config(0).relative ~= '' or vim.w[current_win].side_layout or ft_layouts[vim.bo[ev.buf].ft] or vim.t.diffview_view_initialized then
      return
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local win_cfg = vim.api.nvim_win_get_config(win)
      if win_cfg.relative == '' and not vim.w[win].side_layout and not ft_layouts[vim.bo[vim.api.nvim_win_get_buf(win)].ft] then
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

    local side_size_top = vim.tbl_get(vim.t, 'side_sizes', 'top') or 0
    local side_size_bottom = vim.tbl_get(vim.t, 'side_sizes', 'bottom') or 0
    local side_size_left = vim.tbl_get(vim.t, 'side_sizes', 'left') or 0
    local side_size_right = vim.tbl_get(vim.t, 'side_sizes', 'right') or 0
    local other_horizontal_splits_cnt = #horizontal_splits - 1
    if other_horizontal_splits_cnt > 0 then
      local main_height = editor_height - other_horizontal_splits_cnt - side_size_top - side_size_bottom
      local new_current_win_height = math.floor(main_height * 2 / 3)
      local rest_distributed_height = math.floor((main_height - new_current_win_height) / other_horizontal_splits_cnt)
      local rest_distributed_remainder_height = (main_height - new_current_win_height) % other_horizontal_splits_cnt
      new_current_win_height = new_current_win_height + rest_distributed_remainder_height

      for _, win in ipairs(horizontal_splits) do
        vim.api.nvim_win_set_height(win, win == current_win and new_current_win_height or rest_distributed_height)
      end
    end

    local other_vertical_splits_cnt = #vertical_splits - 1
    if other_vertical_splits_cnt > 0 then
      local main_width = editor_width - other_vertical_splits_cnt - side_size_left - side_size_right
      local new_current_win_width = math.floor(main_width * 2 / 3)
      local rest_distributed_width = math.floor((main_width - new_current_win_width) / other_vertical_splits_cnt)
      local rest_distributed_remainder_width = (main_width - new_current_win_width) % other_vertical_splits_cnt
      new_current_win_width = new_current_win_width + rest_distributed_remainder_width

      for _, win in ipairs(vertical_splits) do
        vim.api.nvim_win_set_width(win, win == current_win and new_current_win_width or rest_distributed_width)
      end
    end
  end
})
