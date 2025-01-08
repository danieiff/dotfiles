require 'nightfox'.setup {}
vim.cmd.colorscheme 'nordfox'
require 'nvim-web-devicons'.setup {}

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

require 'render-markdown'.setup {}

require 'satellite'.setup {}

require 'ibl'.setup()

local mode_hl_tbl = {
  ['n'] = 'MiniStatuslineModeNormal',
  ['v'] = 'MiniStatuslineModeVisual',
  ['V'] = 'MiniStatuslineModeVisual',
  [''] = 'MiniStatuslineModeVisual',
  ['i'] = 'MiniStatuslineModeInsert',
  ['R'] = 'MiniStatuslineModeReplace',
  ['c'] = 'MiniStatuslineModeCommand'
}
local function statusline()
  local vim_mode_hl = mode_hl_tbl[vim.fn.mode()] or 'MiniStatuslineModeOther'
  local githead_vimmode = vim.g.gitsigns_head and ('%%#%s# %s %%*'):format(vim_mode_hl, vim.g.gitsigns_head)

  local gs_dict = vim.b.gitsigns_status_dict or {}
  local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
  local diff_status =
      (added and added > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
      (changed and changed > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
      (removed and removed > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

  local diagnostic_status = ''
  for _, level in ipairs(vim.diagnostic.severity) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    if count ~= 0 then
      diagnostic_status = diagnostic_status .. ('%%#Diagnostic%s#%s%s%%*'):format(level, string.sub(level, 1, 1), count)
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
  }), ' ')
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

vim.lsp.handlers["window/showMessage"] = function(_, method, params)
  vim.notify(method.message, vim.diagnostic.severity[params.params.type])
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

-- require 'focus'.setup { ui = { signcolumn = false } }

local edgy_opts = {
  top = {
    { title = 'Overseer List', ft = 'OverseerList' },
    {
      title = 'Overseer task',
      ft = '',
      filter = function(buf)
        return vim.b[buf].overseer_task ~= nil
      end
    },
  },
  bottom = {
    "Trouble",
    { title = "QuickFix",       ft = "qf" },
    { ft = "help",              size = { height = 20 },      filter = function(buf) return vim.b[buf].buftype == "help" end }, -- don't open help files in edgy that we're editing
    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
  },
  left = {
    -- { title = 'Git Status', ft = 'fugitive', size = { width = 0.3 }, pinned = true, open = 'G',        wo = { number = false }, },
    { title = 'Git Log',   ft = 'git',      size = { width = 0.3 }, pinned = true, open = 'G reflog', },
    { title = 'Undo Tree', ft = 'undotree', open = 'UndoTreeToggle' },
    {
      title = 'Undo diff',
      ft = 'diff',
      filter = function(buf) return vim.b[buf].isUndotreeBuffer end
    },
    { title = "Neotest Summary", ft = "neotest-summary" },
    { title = 'Avante',          ft = 'Avante',         size = { width = 0.4 } }, 'AvanteInput',
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
