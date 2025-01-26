-- vim.opt.winblend = 30
vim.opt.termguicolors = true
vim.opt.winfixheight = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.signcolumn = 'number'
vim.opt.cursorline = true
vim.opt.splitkeep = 'screen'
vim.opt.list = true
vim.opt.listchars = { tab = "⇥ ", trail = '·' }

require 'nightfox'.setup {}
vim.cmd.colorscheme 'nordfox'

require 'nvim-web-devicons'.set_icon { help = { icon = "", color = "#61afef", name = "help" } }
require 'nvim-web-devicons'.set_icon_by_filetype { help = 'help' }

require 'satellite'.setup {}

require 'ibl'.setup()

require 'fidget'.setup { notification = { override_vim_notify = true } }
K(',M', function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win].message_history then
      return vim.api.nvim_win_close(win, true)
    end
  end
  vim.cmd "below new | put=execute('messages \\| Fidget history')"
  vim.bo.buftype = 'nofile'
  vim.bo.ft = 'log'
  vim.w.message_history = true
end)

vim.lsp.handlers["window/showMessage"] = function(_, method, params)
  vim.notify(method.message, vim.diagnostic.severity[params.params.type])
end

require 'ui.statusline'
require 'ui.tabline'
require 'ui.window-layout'

local win_bufname_ns = vim.api.nvim_create_namespace 'win_bufname'
AUC({ 'WinEnter', 'WinScrolled', 'WinResized', 'VimResized' }, {
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
