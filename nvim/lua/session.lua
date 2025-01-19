vim.opt.sessionoptions:remove { 'blank', 'options' }

local function get_session_path()
  local branch = vim.fn.systemlist { 'git', 'branch', '--show-current' }[1]
  return vim.fn.stdpath 'data' .. '/'
      .. vim.fn.fnamemodify(assert(vim.uv.cwd(), 'should get cwd'), ':p:h'):gsub('/', '!')
      .. (vim.v.shell_error == 0 and '-' .. branch or '')
      .. '.vim'
end

AUC('VimEnter', {
  nested = true,
  callback = function()
    local vim_argv = vim.fn.argv()
    if pcall(vim.api.nvim_exec2, 'silent source ' .. get_session_path(), {}) then
      AUC('VimLeave', { command = 'silent mksession! ' .. get_session_path() })
    end
    for _, path in ipairs(type(vim_argv) == 'table' and vim_argv or { vim_argv }) do
      vim.cmd.tabedit(path)
    end
  end
})

CMD('MkSession', 'silent mksession! ' .. get_session_path(), {})
CMD('LoadSession', 'source ' .. get_session_path(), {})
CMD('SelectSession', '', {})
CMD('DeleteSession', function() os.remove(get_session_path()) end, {})
