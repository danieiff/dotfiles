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

local function get_session_path_helper(selected_label)
  return get_session_path(unpack(vim.split(selected_label, ' ')))
end

CMD('SelectSession', function(ev)
  require 'fzf-lua'.fzf_exec(
    'rg --files ' .. vim.fn.stdpath 'data' .. ' -g session*.vim',
    {
      prompt = 'Sessions> ',
      fn_transform = function(line)
        return vim.fn.fnamemodify(
          line:gsub('^' .. vim.fn.stdpath 'data' .. '/session', ''):gsub('!', '/'):gsub(':', ' '):gsub(
            '%.vim', ''),
          ':~')
      end,
      preview = function(selected)
        local filecontent = vim.fn.system { 'cat', get_session_path_helper(selected[1]) }
        local result = '\n' .. vim.fn.system { 'ls', vim.fn.expand(selected[1]:match '%S+') }
        for bufname in filecontent:gmatch 'badd %+%d+ (%S+)' do
          result = bufname .. '\n' .. result
        end
        return result
      end,
      actions = {
        ['default'] = function(selected)
          vim.cmd.mksession(vim.v.this_session, { bang = true })
          vim.cmd.source(get_session_path_helper(selected[1]))
        end,
        ['ctrl-e'] = function(selected) vim.cmd.tabedit(get_session_path_helper(selected[1])) end,
        ['ctrl-y'] = function(selected) vim.fn.setreg(vim.v.register, get_session_path_helper(selected[1])) end,
        ['ctrl-w'] = function(selected)
          vim.cmd.mksession(get_session_path_helper(selected[1]), { bang = true })
          require 'fzf-lua'.resume()
        end,
        ['ctrl-x'] = function(selected)
          os.remove(get_session_path_helper(selected[1]))
          require 'fzf-lua'.resume()
        end
      },
      winopts = {
        split = ev.bang and 'belowright vnew' or nil
      }
    })
end, { bang = true })

CMD('MkSession', 'mksession! ' .. get_session_path(), {})
CMD('LoadSession', 'source ' .. get_session_path(), {})

AUC('VimEnter', {
  nested = true,
  callback = function()
    local vim_argv = vim.fn.argv()

    local cwd = vim.uv.cwd()
    if cwd == vim.fn.expand '~' or cwd == vim.fn.fnamemodify('/', ':p') then
      return vim.cmd 'e . | SelectSession!'
    end

    local auc_id = AUC('VimLeave', { command = 'silent mksession! ' .. get_session_path() })
    if not pcall(vim.api.nvim_exec2, 'silent source ' .. get_session_path(), {}) then
      vim.api.nvim_del_autocmd(auc_id)
    end

    for _, path in ipairs(type(vim_argv) == 'table' and vim_argv or { vim_argv }) do
      vim.cmd.tabedit(path)
    end
  end
})
