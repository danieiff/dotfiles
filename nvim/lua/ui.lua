require 'newpaper'.setup {}

require 'nvim-web-devicons'.setup {}

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

require 'render-markdown'.setup {}

local mode_hl_tbl = {
  ['n'] = 'StatuslineModeNormal',
  ['v'] = 'StatuslineModeVisual',
  ['V'] = 'StatuslineModeVisual',
  [''] = 'StatuslineModeVisual',
  ['i'] = 'StatuslineModeInsert',
  ['R'] = 'StatuslineModeReplace',
  ['c'] = 'StatuslineModeCommand'
}
local function statusline()
  local vim_mode_hl = mode_hl_tbl[vim.fn.mode()] or 'StatuslineModeOther'
  local githead_vimmode = vim.g.gitsigns_head and ('%%#%s# %s %%*'):format(vim_mode_hl, vim.g.gitsigns_head)

  local gs_dict = vim.b.gitsigns_status_dict or {}
  local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
  local diff_status =
      (added and added > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
      (changed and changed > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
      (removed and removed > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

  local diagnostic_status
  for _, level in ipairs(vim.diagnostic.severity) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    if count ~= 0 then
      diagnostic_status = (diagnostic_status or '') ..
          ('%%#Diagnostic%s#%s%s%%*'):format(level, level:sub(1, 1), count)
    end
  end

  local search = vim.fn.searchcount()

  local file_modified_hl = vim.bo.modified and 'NvimTreeModifiedFileHL' or ''

  vim.wo.statusline = vim.fn.join(vim.tbl_filter(function(item) return item end, {
    githead_vimmode,
    diff_status,
    diagnostic_status,
    ((search.total or 0) > 0 and ('%s/%s'):format(search.current, search.total) or ''),
    '%=%<',
    '%{fnamemodify(getcwd(), ":~")}',
    ('%%#%s#%%f%%*'):format(file_modified_hl),
    '%P',
    "%{(&fenc!='utf-8'&&&fenc!='')?&fenc:''}",
  }), '  ')
end

AUC({ 'BufEnter', 'FileChangedShellPost', 'CursorMoved', 'ModeChanged', 'DirChanged' }, { callback = statusline })

local win_bufname_ns = vim.api.nvim_create_namespace('win_bufname')
AUC({ 'WinEnter', 'WinScrolled', 'WinResized', 'VimResized' }, {
  nested = false,
  callback = function()
    local current_winnr = vim.api.nvim_tabpage_get_win(0)

    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local win_bufname_extmark_id = win_bufname_ns + bufnr
      if vim.bo[bufnr].buflisted then
        if winnr == current_winnr then
          vim.api.nvim_buf_del_extmark(bufnr, win_bufname_ns, win_bufname_extmark_id)
        else
          local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.')
          vim.api.nvim_buf_set_extmark(bufnr, win_bufname_ns, vim.fn.line('w0', winnr) - 1, -1,
            {
              id = win_bufname_extmark_id,
              virt_text = { { bufname, 'Normal' } },
              virt_text_pos = 'right_align'
            })
        end
      end
    end
  end
})

require 'fidget'.setup {
  notification = { override_vim_notify = true }
}

vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  vim.notify(method.message, vim.diagnostic.severity[params.type])
end

local dap = require 'dap'

dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
  vim.notify((body.percentage and body.percentage or '') .. "%\t" .. body.message, vim.log.levels.INFO,
    { title = session.config.type .. (body.title and ": " .. body.title or ""), group = body.progressId })
end
