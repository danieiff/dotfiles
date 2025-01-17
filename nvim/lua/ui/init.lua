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
vim.opt.listchars = { tab = "⇥ " }

require 'nightfox'.setup {}
vim.cmd.colorscheme 'nordfox'

local devicons = require 'nvim-web-devicons'
devicons.set_icon { help = { icon = "", color = "#61afef", name = "help" } }
devicons.set_icon_by_filetype { help = 'help' }

require 'satellite'.setup {}

require 'ibl'.setup()

require 'fidget'.setup { notification = { override_vim_notify = true } }
K('M', '<cmd>Fidget history<cr>')

require 'ui.statusline'
require 'ui.tabline'
require 'ui.window-layout'

local win_bufname_ns = vim.api.nvim_create_namespace('win_bufname')
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
