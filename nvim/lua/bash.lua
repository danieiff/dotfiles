local language_server = 'bash-language-server'
local debug_adapter_dir = vim.fn.stdpath 'config' .. '/vscode-bash-debug'

AUC('FileType', {
  pattern = 'sh',
  once = true,
  callback = function()
    ---@ Deps

    if vim.fn.executable(language_server) ~= 1 then
      vim.fn.jobstart('npm i -g ' .. language_server,
        { on_exit = function(_, code) if code == 0 then vim.print('Downloaded: ' .. language_server) end end })
    end

    if vim.tbl_get(vim.loop.fs_stat(debug_adapter_dir) or {}, 'type') ~= 'directory' then
      vim.fn.jobstart(
        'mkdir -p ' .. debug_adapter_dir .. ' && cd $_ ' ..
        '&& curl -LO https://github.com/rogalmic/vscode-bash-debug/releases/download/untagged-438733f35feb8659d939/bash-debug-0.3.9.vsix && unzip bash-debug-0.3.9.vsix',
        { on_exit = function(_, code) if code == 0 then vim.print 'Downloaded: vscode-bash-debug' end end })
    end

    ---@ Lsp

    local function start_bash_ls() vim.lsp.start { name = language_server, cmd = { language_server, 'start' } } end
    AUC('FileType', { pattern = 'sh', callback = start_bash_ls })
    start_bash_ls()

    ---@ Dap

    local dap = require 'dap'

    dap.adapters.bashdb = {
      type = 'executable',
      name = 'bashdb',
      command = 'node',
      args = { debug_adapter_dir .. '/extension/out/bashDebug.js' }
    }
    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = debug_adapter_dir .. '/extension/bashdb_dir/bashdb',
        pathBashdbLib = debug_adapter_dir .. '/extension/bashdb_dir',
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = '${workspaceFolder}',
        pathCat = "cat",
        pathBash = "/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated",
      }
    }
  end
})
