local hl_tabline = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false })
local hl_tabline_sel = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false })

local function get_icon_hl(bufnr)
  local ft = vim.bo[bufnr].ft
  local hl_icon, hl_icon_sel = ft .. 'Tab', ft .. 'TabSel'
  local icon, icon_color = require 'nvim-web-devicons'.get_icon_color_by_filetype(ft)
  if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = hl_icon, link = false })) then
    vim.api.nvim_set_hl(0, hl_icon, { fg = icon_color, bg = hl_tabline.bg })
  end
  if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = hl_icon_sel, link = false })) then
    vim.api.nvim_set_hl(0, hl_icon_sel, { fg = icon_color, bg = hl_tabline_sel.bg })
  end
  return icon, hl_icon, hl_icon_sel
end

function _G.tabline()
  local maxwidth, width, shorter_width = vim.o.columns, 0, 0
  local tabs = {}

  for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    local bufnm_label, bufnm_label_shorter, hl, hl_sel = ' ', ' ', 'TabLine', 'TabLineSel'
    local icon, hl_icon, hl_icon_sel = '', '', ''

    for _, win in ipairs({ vim.api.nvim_tabpage_get_win(tabnr), unpack(vim.api.nvim_tabpage_list_wins(tabnr)) }) do
      local bufnr = vim.api.nvim_win_get_buf(win)
      if CHECK_FILE_MODIFIABLE(bufnr, true) then
        local _tabnr, winnr = unpack(vim.fn.win_id2tabwin(win))
        bufnm_label = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':p:r:s?' .. vim.fn.getcwd(winnr, _tabnr) .. '/??')
        bufnm_label_shorter = vim.fn.pathshorten(bufnm_label, 1)
        icon, hl_icon, hl_icon_sel = get_icon_hl(bufnr)
        break
      elseif vim.bo[bufnr].ft == 'help' then
        bufnm_label = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t:r')
        bufnm_label_shorter = bufnm_label
        icon, hl_icon, hl_icon_sel = get_icon_hl(bufnr)
      end
    end

    width = width + bufnm_label:len() + 3
    shorter_width = shorter_width + bufnm_label_shorter:len() + 3

    table.insert(tabs,
      {
        hl = hl,
        hl_sel = hl_sel,
        nr = tabnr,
        label = bufnm_label,
        hl_icon = hl_icon,
        hl_icon_sel = hl_icon_sel,
        icon = icon
      })
  end

  local is_shorter, is_shortest = maxwidth < width, maxwidth < shorter_width
  local selected_tabnr = vim.api.nvim_get_current_tabpage()

  return vim.fn.join(vim.tbl_map(function(tab)
    local is_selected_tab = tab.nr == selected_tabnr
    local hl_icon = is_selected_tab and tab.hl_icon_sel or tab.hl_icon
    local hl = is_selected_tab and tab.hl_sel or tab.hl
    local label = is_shortest and vim.fn.fnamemodify(tab.label, ':t')
        or is_shorter and vim.fn.pathshorten(tab.label, 1)
        or tab.label
    return ('%%#%s#%%%sT%%#%s#%s%%*%%#%s# %s %%*'):format(hl, tab.nr, hl_icon, tab.icon, hl, label)
  end, tabs), '') .. '%#TabLineFill#%T'
end

vim.o.tabline = '%!v:lua.tabline()'
