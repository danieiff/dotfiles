vim.opt.winblend = 0
vim.opt.termguicolors = true
vim.opt.winfixheight = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.number = true
vim.opt.signcolumn = 'number'
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "⇥ ", trail = '·' }
vim.opt.scrolloff = 2
vim.opt.splitkeep = 'screen'

require 'vim._extui'.enable {}

K('M', '<cmd>if &ft == "msgmore" | q | else | mes | endif<cr>')

require 'nightfox'.setup {}
vim.cmd.colorscheme 'nordfox'

require 'satellite'.setup()

require 'ibl'.setup()

require 'ui.statusline'
require 'ui.tabline'
require 'ui.window-layout'

local win_bufname_ns = vim.api.nvim_create_namespace 'win_bufname'
AUC({ 'WinEnter', 'WinScrolled', 'WinResized', 'VimResized' }, {
  callback = function()
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local win_bufname_extmark_id = win_bufname_ns + bufnr
      if vim.bo[bufnr].buflisted then
        if winnr == vim.api.nvim_get_current_win() then
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
