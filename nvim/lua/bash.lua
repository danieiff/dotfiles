REQUIRE({
    {
      type = 'bin',
      arg =
      'curl -fsSL https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.x86_64.tar.xz | tar xJv',
      path = 'shellcheck-latest/shellcheck'
    }, {
    type = 'npm',
    arg = 'bash-language-server'
  }, {
    type = 'bin',
    arg =
    'curl -fsSL https://github.com/rogalmic/vscode-bash-debug/releases/download/untagged-438733f35feb8659d939/bash-debug-0.3.9.vsix -o bash-debug.zip && unzip $_ -d bash-debug',
    path = 'bash-debug/extension/out/bashDebug.js'
  }
  },
  function(_, ls, db)
    local function start_bash_ls() vim.lsp.start { name = ls, cmd = { ls, 'start' } } end
    AUC('FileType', { pattern = 'sh', callback = start_bash_ls })
    start_bash_ls()

    local dap = require 'dap'

    dap.adapters.bashdb = {
      type = 'executable',
      name = 'bashdb',
      command = 'node',
      args = { db }
    }
    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = DEPS_DIR.bin .. '/extension/bashdb_dir/bashdb',
        pathBashdbLib = DEPS_DIR.bin .. '/extension/bashdb_dir',
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
)
