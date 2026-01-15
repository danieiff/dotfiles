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
K('M', '<cmd>if &ft == "pager" | q | else | mes | endif<cr>')

require 'nightfox'.setup {}
vim.cmd.colorscheme 'nordfox'
-- vim.cmd.colorscheme 'vscode'

require 'satellite'.setup()

require 'ibl'.setup()

require 'ui.statusline'
require 'ui.tabline'
require 'ui.window-layout'

AUC({ 'WinEnter', 'WinScrolled', 'WinResized', 'VimResized' }, {
  desc = 'show bufnames on it own non-current windows',
  callback = function()
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local win_scoped_ns = vim.api.nvim_create_namespace('win_bufname' .. winnr)
      vim.api.nvim__ns_set(win_scoped_ns, { wins = { winnr } })

      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local win_scoped_extmark_id = win_scoped_ns
      if vim.bo[bufnr].buflisted then
        if bufnr == vim.api.nvim_get_current_buf() then
          vim.api.nvim_buf_del_extmark(bufnr, win_scoped_ns, win_scoped_extmark_id)
        else
          local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.')
          vim.api.nvim_buf_set_extmark(bufnr, win_scoped_ns, vim.fn.line('w0', winnr) - 1, -1,
            {
              id = win_scoped_extmark_id,
              virt_text = { { bufname, 'Normal' } },
              virt_text_pos = 'right_align'
            })
        end
      end
    end
  end
})
