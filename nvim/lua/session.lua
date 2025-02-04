vim.opt.sessionoptions:remove { 'buffers', 'blank', 'options' }

local function get_session_path(dir, branch)
  dir = dir or assert(vim.uv.cwd(), 'should get cwd')
  branch = branch or vim.fn.systemlist { 'git', 'branch', '--show-current' }[1]
  return vim.fn.stdpath 'data' .. '/'
      .. 'session'
      .. vim.fn.fnamemodify(dir, ':p:h'):gsub('/', '!')
      .. (vim.v.shell_error == 0 and branch and (':' .. branch) or '')
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

CMD('MkSession', 'mksession! ' .. get_session_path(), {})
CMD('LoadSession', 'source ' .. get_session_path(), {})
CMD('DeleteSession', function() os.remove(get_session_path()) end, {})
