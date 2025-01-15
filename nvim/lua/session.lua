vim.opt.sessionoptions:remove { 'blank' }

local function get_session_path()
  local branch = vim.fn.systemlist { 'git', 'branch', '--show-current' }[1]
  return vim.fn.stdpath 'data' .. '/'
      .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h'):gsub('/', '!')
      .. (vim.v.shell_error == 0 and '-' .. branch or '')
      .. '.vim'
end

local function mksession()
  vim.cmd('silent mksession! ' .. get_session_path())
end

AUC('VimEnter', {
  nested = true,
  callback = function()
    local vim_argv = vim.fn.argv()
    if type(vim_argv) == 'string' then vim_argv = { vim_argv } end

    if pcall(vim.api.nvim_exec2, 'silent source ' .. get_session_path(), {}) then
      AUC('VimLeave', { callback = mksession })
    end

    for _, path in ipairs(vim_argv) do vim.cmd.tabedit(path) end
  end
})

CMD('MkSession', mksession, {})

CMD('DeleteSession', function() os.remove(get_session_path()) end, {})
