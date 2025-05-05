K('(', '<cmd>exe "tabp" . v:count1<cr>')
K(')', function()
  if vim.v.count == 0 then
    vim.cmd 'tabn'
  else
    local tabpages = vim.api.nvim_list_tabpages()
    vim.api.nvim_set_current_tabpage(tabpages[(vim.v.count - 1) % #tabpages + 1])
  end
end)
K('<leader><tab>', require 'fzf-lua'.tabs)

require 'leap'.create_default_mappings()
K('s', '<Plug>(leap)')
K('gS', require 'leap.remote'.action, { mode = { 'n', 'o' } })
K('S', require 'leap.treesitter'.select, { mode = { 'n', 'x', 'o' } })

require 'fzf-lua'.setup {
  keymap = {
    builtin = { true,
      ['<C-h>'] = 'toggle-help',
    }
  }
}
K('<leader>f', function() require 'fzf-lua'.files { cwd = vim.fs.root(0, '.git') } end)
K('<leader>F', require 'fzf-lua'.oldfiles)
K('<leader>b', require 'fzf-lua'.buffers)
K('<leader>m', require 'fzf-lua'.marks)
K('<leader>j', require 'fzf-lua'.jumps)

K('<leader>h', require 'fzf-lua'.helptags)
K('<leader>M', require 'fzf-lua'.manpages)

K('<leader>g', require 'fzf-lua'.live_grep)
K('<leader>G', require 'fzf-lua'.live_grep_native)
K('<leader>;', require 'fzf-lua'.live_grep_resume)
K('<leader>:', require 'fzf-lua'.live_grep_glob)
K('<leader>/', require 'fzf-lua'.grep)

K('<C-g>', require 'fzf-lua'.grep_last)
K('<C-g>', require 'fzf-lua'.grep_cword)
K('<C-g>', require 'fzf-lua'.grep_cWORD)
K('<C-g>', require 'fzf-lua'.grep_visual)
K('<C-g>', require 'fzf-lua'.grep_project)
K('<C-g>', require 'fzf-lua'.grep_curbuf)
K('<C-g>', require 'fzf-lua'.grep_quickfix)
K('<C-g>', require 'fzf-lua'.grep_loclist)
K('<C-g>', require 'fzf-lua'.lgrep_curbuf)
K('<C-g>', require 'fzf-lua'.lgrep_quickfix)
K('<C-g>', require 'fzf-lua'.lgrep_loclist)

K('<leader>q', require 'fzf-lua'.quickfix)
K('<leader>Q', require 'fzf-lua'.quickfix_stack)
K('<leader>l', require 'fzf-lua'.loclist)
K('<leader>L', require 'fzf-lua'.loclist_stack)
K('[[q', '<cmd>cfirst<cr>')
K(']]q', '<cmd>clast<cr>')
K('[Q', '<cmd>colder<cr>')
K(']Q', '<cmd>cnewer<cr>')
K('<c-q>', '<cmd>if empty(filter(getwininfo(), "v:val.quickfix")) | silent cw | else | cclose | endif<cr>')
K('[[l', '<cmd>lfirst<cr>')
K(']]l', '<cmd>llast<cr>')
K('[L', '<cmd>lolder<cr>')
K(']L', '<cmd>lnewer<cr>')

AUC('BufWinEnter', {
  nested   = true,
  callback = function(ev)
    local root_dir = vim.fs.root(ev.buf, '.git')
    if vim.bo[ev.buf].modifiable and vim.bo[ev.buf].ft and root_dir and root_dir ~= vim.fn.getcwd() then
      vim.cmd.lcd(root_dir)
    end
  end
})

require 'nvim-tree'.setup {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = {
      enable = true
    }
  },
  renderer = { indent_width = 1 },
  actions = {
    expand_all = { exclude = { '.git' } }
  }
}
K('<C-t>', require 'nvim-tree.api'.tree.toggle, { silent = true })
K('<leader>,', function()
  vim.cmd.tabe(vim.fs.root(vim.fn.expand '$MYVIMRC', '.git'))
  require 'nvim-tree.api'.tree.expand_all()
end)

K('g^', function() require 'treesitter-context'.go_to_context(vim.v.count1) end)

require 'trouble'.setup {
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
    test = {
      mode = "diagnostics",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.3,
      },
    },
  },
}

AUC("FileType", {
  group = vim.api.nvim_create_augroup("TroubleQuickfix", { clear = true }),
  pattern = { 'qf' },
  callback = function()
    vim.schedule(function() vim.cmd 'cclose | Trouble qflist open' end)
  end,
})

require 'aerial'.setup { filter_kind = false, autojump = true }
K('<C-s>', require 'aerial'.open)

K('<leader>n', function()
  local title = '## Nav'
  local file_line = '+' .. vim.fn.line '.' .. ' ' .. vim.fn.expand '%'
  vim.cmd.split(vim.uv.os_homedir() .. '/nav.md')
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local insert_index = vim.fn.index(buf_lines, title)
  local new_lines
  if insert_index == -1 then
    insert_index = #buf_lines + 4
    new_lines = { '', title, '', file_line }
  else
    insert_index = insert_index + 2
    new_lines = { file_line }
  end
  vim.api.nvim_buf_set_lines(0, insert_index, insert_index, false, new_lines)
  vim.api.nvim_win_set_cursor(0, { insert_index, 0 })
  vim.cmd 'silent w'
end)

local nav_preview_win, nav_preview_id
local nav_mode_group = vim.api.nvim_create_augroup("NavMode", { clear = true })
AUC('BufEnter', {
  group = nav_mode_group,
  pattern = 'nav.md',
  callback = function(ev)
    K('<leader>n', function()
      local file_line = vim.api.nvim_get_current_line():match '^%+%d+ %S+$'
      if not file_line then return end
      vim.cmd('edit ' .. file_line)
    end, { buffer = ev.buf })

    AUC('CursorMoved', {
      group = nav_mode_group,
      buffer = ev.buf,
      callback = function()
        local line, file = vim.api.nvim_get_current_line():match '^%+(%d+) (%S+)$'
        if not file then
          if nav_preview_win then vim.api.nvim_win_close(nav_preview_win, true) end
          nav_preview_id, nav_preview_win = nil, nil
          return
        end
        local buf = vim.uri_to_bufnr(vim.uri_from_fname(vim.fn.fnamemodify(file, ':p')))
        local id = buf .. '+' .. line
        if nav_preview_id == id then
          return
        end
        if nav_preview_win then vim.api.nvim_win_close(nav_preview_win, true) end
        nav_preview_id, nav_preview_win = id, vim.api.nvim_open_win(buf,
          false,
          {
            win = 0,
            split = 'right',
            vertical = true
          })
        vim.api.nvim_win_set_cursor(nav_preview_win, { tonumber(line), 0 })

        AUC('WinClosed', {
          group = nav_mode_group,
          buffer = buf,
          callback = function() nav_preview_id, nav_preview_win = nil, nil end
        })
      end
    })
  end
})
