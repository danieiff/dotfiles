vim.api.nvim_set_hl(0, 'TabLineSel', { underdotted = true })

local hl_tabline = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false })
local hl_tabline_sel = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false })
local hl_file_modified = vim.api.nvim_get_hl(0, { name = 'NvimTreeModifiedFileHL', link = false })

vim.api.nvim_set_hl(0, 'TabLineModified', { fg = hl_file_modified.fg, bg = hl_tabline.bg })
vim.api.nvim_set_hl(0, 'TabLineModifiedSel', { fg = hl_file_modified.fg, bg = hl_tabline_sel.bg })

local icon_default, icon_color_default = require 'nvim-web-devicons'.get_icon_color_by_filetype 'txt'

local function get_icon_hl(icon_ft)
  local icon, icon_color = require 'nvim-web-devicons'.get_icon_color_by_filetype(icon_ft)
  icon, icon_color = icon or icon_default, icon_color or icon_color_default
  local hl_icon = icon_ft .. 'Tab'
  if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = hl_icon, link = false })) then
    vim.api.nvim_set_hl(0, hl_icon, { fg = icon_color, bg = hl_tabline.bg })
    vim.api.nvim_set_hl(0, hl_icon .. 'Sel', { fg = icon_color, bg = hl_tabline_sel.bg })
  end
  return icon, hl_icon
end

local tabnr_icons = { '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹', over = '⁺' }

local win_cnt_icons = { '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉', over = '₊' }

local dir_colors = { '#88c0d0', '#a3be8c', '#ebcb8b', '#81a1c1', '#b48ead', '#bf616a', '#e7ecf4' }

local tabline_dir_hl_tbl = {}
local function get_dir_hl(dir)
  local dir_index
  for i, found_dir in ipairs(tabline_dir_hl_tbl) do
    if dir == found_dir then
      dir_index = i
      break
    end
  end
  if not dir_index then
    table.insert(tabline_dir_hl_tbl, dir)
    dir_index = #tabline_dir_hl_tbl
    vim.api.nvim_set_hl(0, 'TabLineDir' .. dir_index, { fg = dir_colors[dir_index], bg = hl_tabline.bg })
    vim.api.nvim_set_hl(0, 'TabLineDir' .. dir_index .. 'Sel', { fg = dir_colors[dir_index], bg = hl_tabline_sel.bg })
  end
  return 'TabLineDir' .. dir_index
end

function _G.tabline()
  local maxwidth, width, shorter_width = vim.o.columns, 0, 0
  local tabs = {}

  for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local bufnm_label, bufnm_label_shorter, hl = ' ', ' ', 'TabLine'
    local icon, hl_icon                        = '', ''

    local wins                                 = vim.tbl_filter(
      function(win) return vim.api.nvim_win_get_config(win).split ~= nil end, vim.api.nvim_tabpage_list_wins(tabnr))
    local win_cnt_icon, hl_dir                 = win_cnt_icons[#wins] or win_cnt_icons.over, ''

    for _, win in ipairs({ vim.api.nvim_tabpage_get_win(tabnr), unpack(wins) }) do
      local bufnr = vim.api.nvim_win_get_buf(win)
      if vim.bo[bufnr].modified and not hl:find 'Modified' then hl = hl .. 'Modified' end

      if CHECK_FILE_MODIFIABLE(bufnr, true) then
        local _tabnr, winnr = unpack(vim.fn.win_id2tabwin(win))
        local win_scoped_cwd = vim.fn.getcwd(winnr, _tabnr) or ''
        hl_dir = get_dir_hl(win_scoped_cwd)

        bufnm_label = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':p:r:s?' .. win_scoped_cwd .. '/??')
        bufnm_label_shorter = vim.fn.pathshorten(bufnm_label, 1)
        icon, hl_icon = get_icon_hl(vim.bo[bufnr].ft)
        break
      elseif vim.bo[bufnr].ft == 'help' then
        bufnm_label = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t:r')
        bufnm_label_shorter = bufnm_label
        icon, hl_icon = get_icon_hl 'doc'
      end
    end

    width = width + bufnm_label:len() + 3
    shorter_width = shorter_width + bufnm_label_shorter:len() + 3

    table.insert(tabs,
      {
        hl = hl,
        nr = tabnr,
        tabnr_icon = tabnr_icons[i] or tabnr_icons.over,
        label = bufnm_label,
        hl_icon = hl_icon,
        icon = icon,
        hl_dir = hl_dir,
        win_cnt_icon = win_cnt_icon
      })
  end

  local is_shorter, is_shortest = maxwidth < width, maxwidth < shorter_width
  local selected_tabnr = vim.api.nvim_get_current_tabpage()

  return vim.fn.join(vim.tbl_map(function(tab)
    local maybe_selected = tab.nr == selected_tabnr and 'Sel' or ''
    local label = is_shortest and vim.fn.fnamemodify(tab.label, ':t')
        or is_shorter and vim.fn.pathshorten(tab.label, 1)
        or tab.label
    local hl = tab.hl .. maybe_selected
    local hl_icon = tab.hl_icon .. maybe_selected
    local hl_dir = tab.hl_dir .. maybe_selected
    return ('%%#%s#%%%sT%%#%s#%s%%*%%#%s#%s%%*%%#%s#%s%%*%%#%s#%s%%*'):format(hl, tab.nr, hl_dir, tab.tabnr_icon, hl_icon,
      tab.icon, hl_dir, tab.win_cnt_icon, hl, label)
  end, tabs), '') .. '%#TabLineFill#%T'
end

vim.o.tabline = '%!v:lua.tabline()'
