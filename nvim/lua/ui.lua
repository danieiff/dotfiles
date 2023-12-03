require 'nightfox'.setup { options = { transparent = true, inverse = { search = true } } }
vim.cmd 'colorscheme nordfox'

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }


local function draw_statusline()
  local vim_mode_hl = ({
    ['n']                                                       = 'MiniStatuslineModeNormal',
    ['v']                                                       = 'MiniStatuslineModeVisual',
    ['V']                                                       = 'MiniStatuslineModeVisual',
    [vim.api.nvim_replace_termcodes('<C-V>', true, true, true)] = 'MiniStatuslineModeVisual',
    ['i']                                                       = 'MiniStatuslineModeInsert',
    ['R']                                                       = 'MiniStatuslineModeReplace',
    ['c']                                                       = 'MiniStatuslineModeCommand'
  })[vim.fn.mode()] or 'MiniStatuslineModeOther'
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

  local file_modified_hl = vim.o.modified and 'NvimTreeModifiedFile' or ''

  vim.o.statusline = vim.fn.join(vim.tbl_filter(function(item) return item end, {
    githead_vimmode,
    diff_status,
    diagnostic_status,
    ((search.total or 0) > 0 and ('%s/%s'):format(search.current, search.total) or ''),
    '%=',
    ('%%#%s#%s%%*'):format(file_modified_hl, vim.fn.fnamemodify(vim.fn.expand '%', ':.')),
    '%P',
    os.date '%H:%M'
  }), '  ')
end

HL(0, 'Statusline', { bg = 'NONE' })

AUC(
  { 'WinEnter', 'BufEnter', 'SessionLoadPost', 'FileChangedShellPost', 'VimResized', 'Filetype', 'CursorMoved',
    'CursorMovedI', 'ModeChanged' },
  { callback = draw_statusline }
)
vim.fn.timer_start(2000, draw_statusline, { ['repeat'] = -1 })

-- local progress_token_to_title, progress_title_to_order, clients_title_progress, timerid_to_winbuf, spinner_frames = {},
--     {}, {}, {}, { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷", index = 1 }
--
-- local function update_progress_notif(timer_id)
--   spinner_frames.index = spinner_frames.index % #spinner_frames + 1
--
--   local lines = {}
--   for client_id, title_to_prog_info in pairs(clients_title_progress) do
--     local spinner = (next(clients_title_progress[client_id]) and spinner_frames[spinner_frames.index] or '󰄬')
--     local client_name = vim.tbl_get(vim.lsp.get_client_by_id(client_id) or {}, 'name')
--     if not client_name then return end
--     table.insert(lines, spinner .. ' ' .. client_name)
--
--     local t = vim.tbl_values(title_to_prog_info)
--     table.sort(t, function(a, b) return a.order - b.order > 0 end)
--     vim.list_extend(lines, vim.tbl_map(function(v) return v.progress_info end, t))
--   end
--
--   if not vim.tbl_contains(vim.api.nvim_list_wins(), timerid_to_winbuf[timer_id].win) then
--     return vim.fn.timer_stop(timer_id)
--   end
--   if not next(progress_token_to_title) and #lines == 0 then
--     return vim.api.nvim_win_close(timerid_to_winbuf[timer_id].win, false)
--   end
--
--   vim.api.nvim_win_set_height(timerid_to_winbuf[timer_id].win, #lines)
--   vim.api.nvim_buf_set_lines(timerid_to_winbuf[timer_id].buf, 0, -1, false, lines)
-- end
--
-- local _progress_handler = vim.lsp.handlers['$/progress']
-- vim.lsp.handlers['$/progress'] = function(_, result, ctx)
--   _progress_handler(_, result, ctx)
--   local token, val, client_id = result.token, result.value, ctx.client_id
--   local title                 = val.title or vim.tbl_get(progress_token_to_title, client_id, token)
--   local message_maybe_prev    = val.message or vim.tbl_get(clients_title_progress, client_id, title, 'message') or ''
--   local percentage            = val.kind == 'end' and 'Complete' or val.percentage and val.percentage .. '%' or ''
--
--   if val.kind == "begin" then
--     progress_token_to_title[client_id] = vim.tbl_deep_extend('error', progress_token_to_title[client_id] or {},
--       { [token] = title })
--     progress_title_to_order[client_id] = vim.tbl_deep_extend('keep', progress_title_to_order[client_id] or {},
--       { [title] = #vim.tbl_keys(progress_title_to_order[client_id] or {}) + 1 })
--
--     if not next(clients_title_progress) then
--       local timer_id = vim.fn.timer_start(100, update_progress_notif, { ['repeat'] = -1 })
--       local buf = vim.api.nvim_create_buf(false, true)
--       timerid_to_winbuf[timer_id] = {
--         buf = buf,
--         win = vim.api.nvim_open_win(buf, false,
--           {
--             relative = 'win',
--             anchor = 'NE',
--             width = 45,
--             height = 1,
--             row = 0,
--             col = vim.fn.winwidth(0),
--             style = 'minimal',
--             focusable = false
--           })
--       }
--     end
--   elseif val.kind == "end" then
--     progress_token_to_title[client_id][token] = nil
--     if not next(progress_token_to_title[client_id]) then progress_token_to_title[client_id] = nil end
--
--     vim.defer_fn(function()
--       (clients_title_progress[client_id] or {})[title] = nil
--       if not next(clients_title_progress[client_id] or {}) then clients_title_progress[client_id] = nil end
--     end, 1000)
--   end
--
--   clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
--     {
--       [title] = {
--         progress_info = ('%s %s %s'):format(title, message_maybe_prev, percentage),
--         message = message_maybe_prev,
--         order = progress_title_to_order[client_id][title]
--       }
--     })
-- end
