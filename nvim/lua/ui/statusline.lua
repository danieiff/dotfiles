local mode_hl_tbl = {
  ['n'] = 'MiniStatuslineModeNormal',
  ['v'] = 'MiniStatuslineModeVisual',
  ['V'] = 'MiniStatuslineModeVisual',
  [''] = 'MiniStatuslineModeVisual',
  ['i'] = 'MiniStatuslineModeInsert',
  ['R'] = 'MiniStatuslineModeReplace',
  ['c'] = 'MiniStatuslineModeCommand'
}
function _G.statusline()
  local hl_vim_mode = mode_hl_tbl[vim.fn.mode()] or 'MiniStatuslineModeOther'
  local githead_vimmode = vim.g.gitsigns_head and ('%%#%s# %s %%*'):format(hl_vim_mode, vim.g.gitsigns_head)

  local gs_dict = vim.b.gitsigns_status_dict or {}
  local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
  local diffs =
      ((added or 0) > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
      ((changed or 0) > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
      ((removed or 0) > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

  local diagnostics = vim.fn.join(vim.tbl_map(function(level)
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    return count ~= 0 and ('%%#Diagnostic%s#%s%s%%*'):format(level, string.sub(level, 1, 1), count) or ''
  end, { unpack(vim.diagnostic.severity) }), '')

  local search = vim.fn.searchcount()
  local searchcount = vim.fn.join({ search.current, search.total, vim.fn.getreg '/' }, '/')

  local reg_recording = vim.fn.reg_recording()
  reg_recording = reg_recording ~= '' and ('Rec@%s'):format(reg_recording)

  return vim.fn.join(vim.tbl_filter(function(item) return item and item ~= '' end, {
    githead_vimmode,
    diffs,
    diagnostics,
    searchcount,
    reg_recording,
    '%=%<',
    '%{fnamemodify(getcwd(), ":~")}',
    "%{% &modified ? '%#NvimTreeModifiedFileHL#' : '' %}%f%*",
    '%P',
    "%{ &fenc!='utf-8' && &fenc!='' ? &fenc : '' }",
  }))
end

vim.o.statusline = '%!v:lua.statusline()'
