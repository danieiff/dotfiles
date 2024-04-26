--[[
@("git.git", "zig.zig", "Neovim.Neovim.Nightly", "BurntSushi.ripgrep.MSVC") | ForEach-Object { winget install $_ }
git clone --depth 1 https://github.com/danieiff/dotfiles -b windows
New-Item -Path $ENV:LOCALAPPDATA/nvim -ItemType SymbolicLink -Value dotfiles/nvim
]]

function K(lhs, rhs, opts)
  opts = opts or {}
  local mode = opts.mode or 'n'
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

local default_group = vim.api.nvim_create_augroup('default', {})
function AUC(ev, opts)
  if not opts.group then opts.group = default_group end
  vim.api.nvim_create_autocmd(ev, opts)
end

local function reload_editor()
  vim.cmd('set runtimepath^=' .. vim.fn.stdpath 'config' .. ' | runtime! plugin/**/*.{vim,lua}')
  dofile(vim.env.MYVIMRC)
  vim.cmd 'helptags ALL | edit'
end

---@Dependencies

local plugin_dir, plugins =
    vim.fn.stdpath 'config' .. [[\pack\my\start\]],
    {
      'https://github.com/EdenEast/nightfox.nvim',
      'https://github.com/NvChad/nvim-colorizer.lua',
      'https://github.com/MunifTanjim/nui.nvim',
      'https://github.com/nvim-lua/plenary.nvim',

      'https://github.com/nvim-telescope/telescope.nvim',
      'https://github.com/jackMort/ChatGPT.nvim',
      'https://github.com/nvim-neo-tree/neo-tree.nvim',
      'https://github.com/mbbill/undotree',
      'https://github.com/lewis6991/gitsigns.nvim',
      'https://github.com/tpope/vim-fugitive',

      'https://github.com/nvim-treesitter/nvim-treesitter',
      'https://github.com/nvim-treesitter/nvim-treesitter-context',
      'https://github.com/lukas-reineke/indent-blankline.nvim',
      'https://github.com/RRethy/vim-illuminate',
      'https://github.com/numToStr/Comment.nvim',
      'https://github.com/kylechui/nvim-surround',
      'https://github.com/danieiff/nvim-ts-autotag',
      'https://github.com/windwp/nvim-autopairs',
      'https://github.com/Wansmer/treesj',
      'https://github.com/ziontee113/syntax-tree-surfer',
      'https://github.com/folke/flash.nvim',
      'https://github.com/chrisgrieser/nvim-spider',

      'https://github.com/hrsh7th/nvim-cmp',
      'https://github.com/hrsh7th/cmp-nvim-lsp',
      'https://github.com/hrsh7th/cmp-buffer',
      'https://github.com/saadparwaiz1/cmp_luasnip',
      'https://github.com/L3MON4D3/LuaSnip',
      'https://github.com/danieiff/friendly-snippets',
      'https://github.com/danieiff/nvim-dbee', -- 'https://github.com/kndndrj/nvim-dbee',
      'https://github.com/MattiasMTS/cmp-dbee',

      'https://github.com/mfussenegger/nvim-dap',
      'https://github.com/rcarriga/nvim-dap-ui',
      'https://github.com/theHamsta/nvim-dap-virtual-text',
      'https://github.com/nvim-neotest/neotest',

      'https://github.com/neovim/nvim-lspconfig',
      'https://github.com/ray-x/lsp_signature.nvim',
      'https://github.com/danieiff/lsp-lens.nvim',
      'https://github.com/nvimtools/none-ls.nvim',
      'https://github.com/pmizio/typescript-tools.nvim',
      'https://github.com/nvim-neotest/neotest-jest',
    }

vim.fn.jobstart('dir /B ' .. plugin_dir, {
  stdout_buffered = true,
  on_stdout = function(_, data)
    for i, plugin in ipairs(plugins) do
      local cache_name = vim.fn.fnamemodify(plugin, ':t')
      if vim.tbl_contains(vim.tbl_map(vim.trim, data), cache_name) then
        plugins[i] = nil
      else
        vim.fn.jobstart(('git clone %s %s'):format(plugin, plugin_dir .. cache_name), {
          on_exit = function(_, code)
            plugins[i] = nil
            vim.print((code == 0 and 'Installed ' or 'Install Failed ') .. cache_name)
          end
        })
      end
    end
    if not next(plugins) then return end
    local timer = vim.uv.new_timer()
    timer:start(1000, 500, function()
      if next(plugins) then return end
      timer:stop()
      vim.schedule(reload_editor)
    end)
  end
})

---@Editor

vim.fn.setenv('LANG', 'en')
vim.fn.setenv('PATH', os.getenv 'PATH' .. ';' .. os.getenv 'PROGRAMFILES' .. [[\Git\usr\bin;]])

for k, v in pairs {
  autowriteall = true, undofile = true,
  ignorecase = true, smartcase = true,
  tabstop = 2, shiftwidth = 0, expandtab = true, fixeol = false,
  pumblend = 30, winblend = 30,
  laststatus = 3, cmdheight = 0, number = true, signcolumn = 'number',
  foldenable = false, foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()', foldtext = 'v:lua.vim.treesitter.foldtext()',
  grepprg = 'rg\\ --vimgrep', grepformat = '%f:%l:%c:%m'
} do vim.opt[k] = v end -- Reset :set [option]&

vim.fn.digraph_setlist { { 'eh', '✨' }, { 'ej', '🔧' }, { 'ek', '♻' }, { 'el', '🐛' }, { 'e;', '🩹' } }

vim.g.mapleader = ' '

K('<up>', '<C-w>w')
K('<down>', '<cmd>tabe %<cr>')
K('<left>', '<cmd>tabprevious<cr>', { silent = true, mode = { 'n', 't' } })
K('<right>', '<cmd>tabnext<cr>', { silent = true, mode = { 'n', 't' } })
K('<leader>w', vim.cmd.write)
K('<Leader>z', '<cmd>qa<cr>')
K('<Leader>Z', '<cmd>noautocmd qa<cr>')
K('<Leader>,', '<cmd>tabnew $MYVIMRC<cr>')
K('<Leader>.,', reload_editor)
K('<Leader>s', ':%s///g' .. ('<Left>'):rep(3))
K('<Leader>s', ':s///g' .. ('<Left>'):rep(3), { mode = 'v' })
K('<leader>S', ':%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>')
K('Y', 'y$')
K('vP', '`[v`]')
K('<cr>', '<cmd>call append(".", "")<cr>j')
K('<bs>', '<cmd>call append(line(".")-1, "")<cr>k')
K('<leader>tt', function()
  local cword = vim.fn.expand '<cword>'
  for a, b in pairs { ['true'] = 'false' } do
    local change = cword == a and b or cword == b and a
    if change then return vim.cmd('normal ciw' .. change) end
  end
  local sub_pair = cword:find '_' and
      { [[\v_(.)]], [[\u\1]] } or
      { [[\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)]], [[\l\1_\l\2]] }
  vim.cmd('normal ciw' .. vim.fn.substitute(cword, sub_pair[1], sub_pair[2], 'g'))
end)

K('[q', '<cmd>silent cprevious<cr>')
K(']q', '<cmd>silent cnext<cr>')
K('[[q', '<cmd>silent cfirst<cr>')
K(']]q', '<cmd>silent clast<cr>')
K('[Q', '<cmd>silent colder<cr>')
K(']Q', '<cmd>silent cnewer<cr>')
K('qq', '<cmd>if empty(filter(getwininfo(), "v:val.quickfix")) | copen | else | cclose | endif<cr>')

K('[l', '<cmd>silent lprevious<cr>')
K(']l', '<cmd>silent lnext<cr>')
K('[[l', '<cmd>silent lfirst<cr>')
K(']]l', '<cmd>silent llast<cr>')
K(']L', '<cmd>silent lolder<cr>')
K(']L', '<cmd>silent lnewer<cr>')
K('ql', '<cmd>if empty(filter(getwininfo(), "v:val.loclist")) | lopen | else | lclose | endif<cr>')
-- set modifiable
-- set errorformat=%f\|%l\ col\ %c\|\ %m | cbuffer
-- :cc :ll

K('<leader>op', function()
  vim.cmd [[let urls = filter(map(getline(1,'$'), {_,v->matchstr(v,"https\\?:\/\/[^[:space:]'\"]\\+")}), {_,v->v!=''})]]
  vim.cmd 'tabnew | call append(line(".")-1,urls)'
end)

AUC('InsertLeave', {
  callback = function(ev)
    if vim.api.nvim_get_option_value('modifiable', { buf = ev.buf })
        and vim.api.nvim_get_option_value('buftype', { buf = ev.buf }) == ''
        and not vim.api.nvim_get_option_value('readonly', { buf = ev.buf })
        and vim.api.nvim_get_option_value('filetype', { buf = ev.buf }) ~= ''
        and vim.api.nvim_buf_get_name(ev.buf) ~= '' then
      vim.cmd.write()
    end
  end,
  nested = true
})

OPEN_FILES = {}
local n = 0
AUC('BufEnter', {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_get_option_value('modifiable', { buf = bufnr })
          and vim.api.nvim_get_option_value('buftype', { buf = bufnr }) == ''
          and not vim.api.nvim_get_option_value('readonly', { buf = bufnr })
          and vim.api.nvim_get_option_value('filetype', { buf = bufnr }) ~= ''
          and vim.api.nvim_buf_get_name(bufnr) ~= ''
          and OPEN_FILES[bufnr] == nil then
        n = n + 1
        OPEN_FILES[bufnr] = {
          n = n,
          bufname = vim.fn.pathshorten(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.'))
        }
        K(n .. 'g', function() vim.api.nvim_win_set_buf(0, bufnr) end)
        K(n .. 'd', function() vim.api.nvim_win_set_buf(0, bufnr) end)
      end
    end
  end
})

vim.cmd 'set sessionoptions-=curdir,blank'
local session_path = vim.fn.stdpath 'data' .. '\\' .. vim.fn.fnamemodify(vim.uv.cwd(), ':p:h'):gsub('[:\\]', '-')
AUC('VimEnter', {
  callback = function()
    local vim_argv = vim.fn.argv()
    if #vim_argv > 0 and vim_argv[1]:find '.git\\COMMIT_EDITMSG' then return end
    vim.cmd('silent! source ' .. session_path)
    vim.schedule(function() vim.cmd 'silent! tabdo windo edit' end)
    for _, path in ipairs(vim_argv) do vim.cmd.tabedit(path) end
  end
})
AUC('VimLeave', { command = 'mksession! ' .. session_path })

require 'neo-tree'.setup {
  sources = { 'filesystem', 'document_symbols' },
  filesystem = { follow_current_file = { enabled = true } },
  document_symbols = { follow_cursor = true, window = { mappings = { l = 'toggle_node' } } }
}
K('<C-t>', '<cmd>Neotree toggle right reveal<cr>')
K('<C-s>', '<cmd>Neotree toggle document_symbols right show<cr>')

K('<leader>u', '<cmd>UndotreeToggle<cr>')

require 'telescope'.setup {}
K('<leader> ', require 'telescope.builtin'.resume)
K('<leader>f', require 'telescope.builtin'.find_files)
K('<leader>b', require 'telescope.builtin'.buffers)

K('<leader>r', require 'telescope.builtin'.registers)
K('<leader>m', require 'telescope.builtin'.marks)
K('<leader>j', require 'telescope.builtin'.jumplist)
K('<leader>c', require 'telescope.builtin'.commands)
K('<leader>C', require 'telescope.builtin'.command_history)
K('<leader>k', require 'telescope.builtin'.keymaps)
K('<Leader>h', require 'telescope.builtin'.help_tags)

K('<leader>q', require 'telescope.builtin'.quickfix)
K('<leader>Q', require 'telescope.builtin'.quickfixhistory)
K('<leader>l', require 'telescope.builtin'.loclist)

K('<leader>g', require 'telescope.builtin'.live_grep)
K('<leader>/', require 'telescope.builtin'.grep_string)
K('<leader>?', require 'telescope.builtin'.search_history)

K('<leader>e', require 'telescope.builtin'.diagnostics)
K('<leader>ld', require 'telescope.builtin'.lsp_definitions)

---@Git

K('<leader>gC', require 'telescope.builtin'.git_commits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits_range, { mode = { 'x' } })
K('<leader>gb', require 'telescope.builtin'.git_branches)
K('<leader>gs', require 'telescope.builtin'.git_stash)

K('g;', '<cmd>G<cr>')
K('<leader>gl', [[<cmd>G log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all --max-count 30<cr>]])

require 'neogit'.setup {}

require 'gitsigns'.setup {
  signcolumn = false,
  numhl = true,
  word_diff = true,
  current_line_blame = true,
  on_attach = function()
    local gs = package.loaded.gitsigns

    K(']h', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(gs.next_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(gs.prev_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('Hs', ':Gitsigns stage_hunk<cr>', { mode = { 'n', 'v', 'x' } })
    K('Hr', '<cmd>Gitsigns reset_hunk<cr>', { mode = { 'n', 'v' } })
    K('Hu', gs.undo_stage_hunk)
    K('Hp', gs.preview_hunk)
    K('Hb', function() gs.blame_line { full = true } end)
    K('Hd', gs.toggle_deleted)
    K('Hv', '<cmd>Gitsigns select_hunk<cr>')
  end
}

AUC('FileType', {
  pattern = 'gitcommit',
  callback = function(ev) vim.api.nvim_buf_set_lines(ev.buf, 0, 1, false, { vim.g.gitsigns_head:match('[A-Z]+-%d+') }) end
})

---@TreeSitter

require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'javascript', 'typescript', 'html', 'css', 'scss', 'python', 'php', 'lua', 'java', 'sql', 'bash',
    'json', 'markdown', 'markdown_inline', 'gitcommit', 'git_rebase', 'vimdoc'
  },
  highlight = { enable = true }
}

require 'ibl'.setup()
require 'treesitter-context'.setup()

require 'ts_context_commentstring'.setup { enable_autocmd = false }
require 'Comment'.setup { pre_hook = require 'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook() }

require 'nvim-surround'.setup()
require 'nvim-ts-autotag'.setup { enable_close_on_slash = false, }
require 'nvim-autopairs'.setup { disable_in_visualblock = true, fast_wrap = { map = '<C-]>' } } -- <C-h> to delete only '('

require 'treesj'.setup { use_default_keymaps = false }
K('L', require 'treesj'.toggle)

K("w", "<cmd>lua require 'spider' .motion 'w' <cr>", { mode = { "n", "o", "x" } })
K("e", "<cmd>lua require 'spider' .motion 'e' <cr>", { mode = { "n", "o", "x" } })
K("b", "<cmd>lua require 'spider' .motion 'b' <cr>", { mode = { "n", "o", "x" } })
K("ge", "<cmd>lua require 'spider' .motion 'ge' <cr>", { mode = { "n", "o", "x" } })

require 'flash'.setup { label = { uppercase = false }, modes = { search = { enabled = false } } }
K('f', require 'flash'.jump, { mode = { "n", "x", "o" } })
K('r', require 'flash'.remote, { mode = { "o" } })
K('t', require 'flash'.treesitter, { mode = { "n", "x", "o" } })
K('T', require 'flash'.treesitter_search, { mode = { "n", "x", "o" } })
vim.api.nvim_set_hl(0, 'FlashLabel', { link = 'LeapLabelPrimary' })

require 'syntax-tree-surfer'.setup()
K("vV", '<cmd>STSSelectMasterNode<cr>')
K("vv", '<cmd>STSSelectCurrentNode<cr>')
K("J", '<cmd>STSSelectNextSiblingNode<cr>', { mode = 'x' })
K("K", '<cmd>STSSelectPrevSiblingNode<cr>', { mode = 'x' })
K("H", '<cmd>STSSelectParentNode<cr>', { mode = 'x' })
K("L", '<cmd>STSSelectChildNode<cr>', { mode = 'x' })

K("vs", "<cmd>STSSwapOrHold<cr>")
K("vs", "<cmd>STSSwapOrHoldVisual<cr>", { mode = { "x" } })
K("vu", function()
  vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vd", function()
  vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vn", '<cmd>STSSwapNextVisual<cr>', { mode = { "x" } })
K("vn", function()
  vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"; return "g@l"
end, { silent = true, expr = true })
K("vp", '<cmd>STSSwapPrevVisual<cr>', { mode = { "x" } })
K("vp", function()
  vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"; return "g@l"
end, { expr = true, silent = true })

K('vI',
  function() require "syntax-tree-surfer".go_to_top_node_and_execute_commands(false, { "normal! O", "startinsert" }) end)

---@Editing

local openai_api_key_cmd =
'powershell (Import-Clixml -Path "$env:USERPROFILE\\OPENAI_API_KEY").GetNetworkCredential().Password'
vim.fn.jobstart(openai_api_key_cmd, {
  stdout_buffered = true,
  on_stdout = function(_, data)
    if (#data == 1 and data[1] == '') then
      vim.fn.jobstart(
        [[powershell "Get-Credential | Export-Clixml -Path \"$env:USERPROFILE\OPENAI_API_KEY\"]])
    end
  end
})
require 'chatgpt'.setup {
  api_key_cmd = openai_api_key_cmd,
  popup_input = { submit = '<cr>' },
  openai_params = { model = "gpt-3.5-turbo", max_tokens = 2048 },
  openai_edit_params = { model = "gpt-3.5-turbo" }
}
K('<C-c>', '<cmd>ChatGPT<cr><cmd>startinsert!<cr>')

local luasnip = require 'luasnip'
require 'luasnip.loaders.from_vscode'.lazy_load()
for _, dir in ipairs(vim.split(vim.fn.globpath('.', '*.code-snippets'), '\n')) do
  require "luasnip.loaders.from_vscode".load_standalone({ path = dir:gsub('^%./', '') })
end

local cmp = require 'cmp'

cmp.setup {
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert {
    ['<C-u>'] = cmp.mapping.scroll_docs(-1),
    ['<C-d>'] = cmp.mapping.scroll_docs(1),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      elseif luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      elseif luasnip.expand_or_jumpable() then
        PREPARING_LUASNIP_JUMP = true
        luasnip.expand_or_jump()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        PREPARING_LUASNIP_JUMP = true
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      PREPARING_LUASNIP_JUMP = true
      if vim.fn.mode() == 'c' then
        vim.api.nvim_feedkeys(require 'cmp.utils.keymap'.t(vim.fn.pumvisible() == 0 and '<C-z>' or '<C-n>'), 'in', true)
      else
        if not cmp.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace } then fallback() end
      end
    end, { 'i', 's', 'c' }),
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'rg',      keyword_length = 3 },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function() return vim.tbl_map(vim.api.nvim_win_get_buf, vim.api.nvim_list_wins()) end,
        indexing_interval = 1500
      }
    }
  },
}

cmp.setup.cmdline({ '/', '?' }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
cmp.event:on('confirm_done', require 'nvim-autopairs.completion.cmp'.on_confirm_done())
cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, { sources = cmp.config.sources { { name = 'vim-dadbod-completion' } } })

---@LSP

vim.api.nvim_create_user_command('LspLog', 'tabe ' .. vim.lsp.get_log_path(), {}) -- vim.lsp.set_log_level 'DEBUG'
vim.api.nvim_create_user_command('LspRestart', 'lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd"edit"',
  {})
vim.api.nvim_create_user_command('LspHelp',
  'tabe https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/server_configurations/<args>.lua'
  , { nargs = 1 })
vim.api.nvim_create_user_command('LspCapa', function()
  local clients = vim.lsp.get_clients()
  vim.ui.select(vim.tbl_map(function(item) return item.name end, clients), {},
    function(_, idx)
      vim.cmd 'tabnew'
      vim.api.nvim_buf_set_lines(0, 0, 1, false,
        vim.split(
          '# config.capabilities: Config passed to vim.lsp.start_client()\n' ..
          vim.inspect(clients[idx].config.capabilities) .. '\n\n' ..
          '# server_capabilities:\n' .. vim.inspect(clients[idx].server_capabilities),
          "\n"))
      K('q', '<cmd>q!<cr>', { buffer = 0 })
    end)
end, {})

require 'lsp_signature'.setup {}
require 'lsp-lens'.setup {}

local augroup_lsp = vim.api.nvim_create_augroup('UserLspGroup', {})

AUC('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- if client and client.server_capabilities.documentFormattingProvider then
    --   vim.api.nvim_clear_autocmds { group = augroup_lsp, buffer = ev.buf }
    --   AUC('BufWritePre', {
    --     group = augroup_lsp,
    --     buffer = ev.buf,
    --     callback = function()
    --       if not PREPARING_LUASNIP_JUMP then vim.lsp.buf.format { bufnr = ev.buf } end
    --       PREPARING_LUASNIP_JUMP = false
    --     end
    --   })
    -- end
    K('=', vim.lsp.buf.format ) -- Try async_format?

    K('[d', vim.diagnostic.goto_prev)
    K(']d', vim.diagnostic.goto_next)
    K('[D', function() vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } } end)
    K(']D', function() vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } } end)
    K('<leader>d', vim.diagnostic.open_float)
    K('<leader>D', vim.diagnostic.setloclist)
    K('<leader>dq', vim.diagnostic.setqflist)

    K('gd', vim.lsp.buf.definition)
    K('gt', vim.lsp.buf.type_definition)
    K('gl', vim.lsp.buf.declaration)
    K('gr', vim.lsp.buf.references)
    K('gi', vim.lsp.buf.implementation)
    K('<leader>sh', vim.lsp.buf.signature_help)
    K('<Leader>ci', vim.lsp.buf.incoming_calls)
    K('<Leader>co', vim.lsp.buf.outgoing_calls)
    K('cv', function()
      vim.lsp.buf.rename(nil, {
        filter = function(_client)
          local deprioritised = { 'typescript-tools' }
          return not vim.tbl_contains(deprioritised, _client.name) or
              #vim.lsp.get_clients { method = 'textDocument/rename' } < 1
        end
      })
    end)
    K('<space>rf', vim.lsp.util.rename)
    K('<space>ca', vim.lsp.buf.code_action)
    K('<space>pa', vim.lsp.buf.add_workspace_folder)
    K('<space>pr', vim.lsp.buf.remove_workspace_folder)
    K('<space>pl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end)
  end
})

---@DAP

local dap, dapui, dap_widgets = require 'dap', require 'dapui', require 'dap.ui.widgets'
-- :help dap-adapter dap-configuration dap.txt dap-mapping dap-api dap-widgets
K("<Leader>di", dap.toggle_breakpoint)
K("<Leader>dI", function() dap.set_breakpoint(vim.fn.input "Breakpoint condition: ") end)
K("<Leader>dp", function() dap.set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end)
K("<Leader>ds", dap.continue)
K("<Leader>dl", dap.run_to_cursor)
K("<Leader>dS", dap.disconnect)
K("<Leader>dn", dap.step_over)
K("<Leader>dN", dap.step_into)
K("<Leader>do", dap.step_out)
K("<Leader>dww", function() dap.toggle() end)
K("<Leader>dw[", function() dap.toggle(1) end)
K("<Leader>dw]", function() dap.toggle(2) end)
K('<Leader>dr', dap.repl.open)
K('<Leader>dl', dap.run_last)
K('<Leader>dh', dap_widgets.hover, { mode = { 'n', 'v' } })
K('<Leader>dH', dap_widgets.preview, { mode = { 'n', 'v' } })
K('<Leader>dm', function() dap_widgets.centered_float(dap_widgets.frames) end)
K('<Leader>dM', function() dap_widgets.centered_float(dap_widgets.scopes) end)
K('<leader>dk', require 'dap.ui.widgets'.hover, { silent = true })

vim.api.nvim_create_user_command("DapRunWithArgs", function(t)
  local args = vim.split(vim.fn.expand(t.args), '\n')
  if vim.fn.confirm(("Will try to run:\n%s %s %s\n? "):format(vim.bo.filetype, vim.fn.expand '%', t.args)) == 1 then
    dap.run {
      type = vim.bo.filetype == 'javascript' and 'pwa-node' or vim.bo.filetype == 'typescript' and 'pwa-node',
      request = 'launch',
      name = 'Launch file with custom arguments (adhoc)',
      program = '${file}',
      args = args,
    }
  end
end, { nargs = '*' })

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

require 'nvim-dap-virtual-text'.setup {}

AUC('FileType', {
  pattern = 'dap-repl',
  callback = function()
    cmp.setup.buffer { enabled = false }
    require "dap.ext.autocompl".attach()
  end
})

-- require 'dap.ext.vscode'.load_launchjs(nil, {
--   ["pwa-node"] = { "javascript", "typescript" },
--   ["node"] = { "javascript", "typescript" },
--   ["pwa-chrome"] = { 'typescript', 'javascript' },
--   ["chrome"] = { 'typescript', 'javascript' }
-- })

local neotest = require 'neotest'
neotest.setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = "jest --watch ",
      jestConfigFile = function() -- monorepo
        local file = vim.fn.expand '%:p'
        if file:find "/packages/" then
          return file:match "(.-/[^/]+/)src" .. "jest.config.ts"
        end
        return vim.fn.getcwd() .. "/jest.config.ts"
      end,
      cwd = function() -- monorepo
        local file = vim.fn.expand '%:p'
        if file:find "/packages/" then return file:match "(.-/[^/]+/)src" end
        return vim.fn.getcwd()
      end,
      env = { CI = true }
    }
  }
}

K('<leader>tr', neotest.run.run)
K('<leadler>tf', function() neotest.run.run(vim.fn.expand '%') end)
K('<leader>td', function() neotest.run.run { strategy = 'dap' } end)
K('<leader>ts', neotest.run.stop)
K('<leader>ta', neotest.run.attach)

---@Languages

local vscode_ext_path, vscode_builtin_ext_path = vim.uv.os_homedir() .. [[\.vscode\extensions\]],
    os.getenv 'LOCALAPPDATA' .. [[\Programs\Microsoft VS Code\resources\app\extensions\]]

local function get_root_dir(mark)
  return vim.fs.dirname(vim.fs.find(mark, {
    upward = true,
    stop = vim.uv.os_homedir(),
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })[1])
end

local exts_js = { 'javascript', 'typescript' }

local capabilities = require 'cmp_nvim_lsp'.default_capabilities()

require 'null-ls'.setup {
  sources = {
    package.loaded['null-ls'].builtins.formatting.prettier,
    package.loaded['null-ls'].builtins.diagnostics.eslint,
    package.loaded['null-ls'].builtins.diagnostics.stylelint,
  }
}

local util = require 'lspconfig.util'
local lsp = vim.lsp

local function fix_all(opts)
  opts = opts or {}

  local eslint_lsp_client = util.get_active_client_by_name(opts.bufnr, 'eslint')
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  end

  local bufnr = util.validate_bufnr(opts.bufnr or 0)
  request(0, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = lsp.util.buf_versions[bufnr],
      },
    },
  })
end

local root_file = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'eslint.config.js',
}

AUC('FileType', { pattern = {
        'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
    },
    callback = function() 

vim.lsp.start{
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
    root_dir = function(fname)
      root_file = util.insert_package_json(root_file, 'eslintConfig', fname)
      return util.root_pattern(unpack(root_file))(fname)
    end,
    -- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
    settings = {
      validate = 'on',
      packageManager = nil,
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = true,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      -- nodePath configures the directory in which the eslint server should start its node_modules resolution.
      -- This path is relative to the workspace folder (root dir) of the server instance.
      nodePath = '',
      -- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
      workingDirectory = { mode = 'location' },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
    on_new_config = function(config, new_root_dir)
      -- The "workspaceFolder" is a VSCode concept. It limits how far the
      -- server will traverse the file system when locating the ESLint config
      -- file (e.g., .eslintrc).
      config.settings.workspaceFolder = {
        uri = new_root_dir,
        name = vim.fn.fnamemodify(new_root_dir, ':t'),
      }

      -- Support flat config
      if vim.fn.filereadable(new_root_dir .. '/eslint.config.js') == 1 then
        config.settings.experimental.useFlatConfig = true
      end

      -- Support Yarn2 (PnP) projects
      local pnp_cjs = util.path.join(new_root_dir, '.pnp.cjs')
      local pnp_js = util.path.join(new_root_dir, '.pnp.js')
      if util.path.exists(pnp_cjs) or util.path.exists(pnp_js) then
        config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd)
      end
    end,
    handlers = {
      ['eslint/openDoc'] = function(_, result)
        if not result then
          return
        end
        local sysname = vim.loop.os_uname().sysname
        if sysname:match 'Windows' then
          os.execute(string.format('start %q', result.url))
        elseif sysname:match 'Linux' then
          os.execute(string.format('xdg-open %q', result.url))
        else
          os.execute(string.format('open %q', result.url))
        end
        return {}
      end,
      ['eslint/confirmESLintExecution'] = function(_, result)
        if not result then
          return
        end
        return 4 -- approved
      end,
      ['eslint/probeFailed'] = function()
        vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
        return {}
      end,
      ['eslint/noLibrary'] = function()
        vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
        return {}
      end,
    },
  commands = {
    EslintFixAll = {
      function()
        fix_all { sync = true, bufnr = 0 }
      end,
      description = 'Fix all eslint problems for this buffer',
    },
  },

  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end
}
end 
})

AUC('FileType', {
  pattern = 'html',
  callback = function()
    vim.lsp.start {
      name = 'html-ls',
      root_dir = get_root_dir { 'package.json', '.git' },
      cmd = { 'node', ([["%shtml-language-features\server\dist\node\htmlServerMain.js"]]):format(vscode_builtin_ext_path), '--stdio' },
      capabilities = capabilities,
      settings = {},
      init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { 'html', 'css', 'javascript' },
      }
    }
  end
})

AUC('FileType', {
  pattern = { 'css', 'scss' },
  callback = function()
    vim.lsp.start {
      name = 'css-ls',
      root_dir = get_root_dir { 'package.json', '.git' },
      cmd = { 'node', ([["%scss-language-features\server\dist\node\cssServerMain.js"]]):format(vscode_builtin_ext_path), '--stdio' },
      settings = { css = { validate = true }, scss = { validate = true } },
      capabilities = capabilities
    }
  end
})

AUC('FileType', {
  pattern = 'lua',
  callback = function()
    vim.lsp.start {
      name = 'lua-ls',
      root_dir = get_root_dir { '.git' },
      cmd = { vscode_ext_path .. [[sumneko.lua-3.7.3-win32-x64\server\bin\lua-language-server.exe]] },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      }
    }
  end
})

require 'dap'.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vscode_ext_path .. [[xdebug.php-debug-1.34.0\out\phpDebug.js]] }
}
require 'dap'.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    pathMappings = { ['/var/www/html'] = vim.fn.getcwd() }
  }
}
AUC('FileType', {
  pattern = 'php',
  callback = function()
    vim.lsp.start {
      name = 'intelephense',
      root_dir = get_root_dir { 'composer.json', '.git' },
      cmd = { 'node', vscode_ext_path .. [[bmewburn.vscode-intelephense-client-1.10.2\node_modules\intelephense\lib\intelephense.js]], '--stdio' },
    }
  end
})

AUC('FileType', {
  pattern = 'python',
  callback = function()
    -- https:\\github.com\mtshiba\pylyzer
    -- pip install pylyzer
    require 'lspconfig'.pylyzer.setup {}

    -- https:\\github.com\python-lsp\python-lsp-server\blob\develop\CONFIGURATION.md
    -- pip install python-lsp-server
    -- pip install "python-lsp-server[all]"
    -- pip install pylsp-rope
    require 'lspconfig'.pylsp.setup {
      settings = {
        pylsp = {
          plugins = {
            ruff = { -- pip install python-lsp-ruff
              enabled = true,
              extendSelect = { "I" },
            },
            pycodestyle = {
              ignore = { 'W391' },
              maxLineLength = 100
            },
            black = { -- pip install pylsp-black
              enabled = true
            }
          }
        }
      }
    }
  end
})

-- AUC('FileType', {
--   pattern = exts_js,
--   callback = function()
require 'typescript-tools'.setup {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  capabilities = capabilities,
  settings = {
    tsserver_file_preferences = {
      -- includeInlayParameterNameHints = "none",
      -- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      -- includeInlayFunctionParameterTypeHints = false,
      -- includeInlayVariableTypeHints = false,
      -- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      -- includeInlayPropertyDeclarationTypeHints = false,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      -- includeCompletionsForModuleExports = true,
    },
    tsserver_format_options = {
      -- allowIncompleteCompletions = false,
      -- allowRenameOfImportPath = false,
    },
    importModuleSpecifierPreference = "non-relative",
  }
}
--   end
-- })

for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
  require 'dap'.adapters[adapter] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = { command = "node", args = { ([["%sms-vscode.js-debug\src\extension.js"]]):format(vscode_builtin_ext_path), "${port}" } }
  }
end
for _, ext in ipairs(exts_js) do
  require 'dap'.configurations[ext] = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      cwd = "${workspaceFolder}",
      program = "${file}",
      outFiles = { [[${workspaceFolder}\dist\**\*.js]], [[!**\node_modules\**]] },
      resolveSourceMapLocations = { [[${workspaceFolder}\**]], [[!**\node_modules\**]] },
      trace = true,
    },
    {
      name = "Launch Current File (pwa-node with ts-node)",
      type = "pwa-node",
      request = "launch",
      cwd = "${workspaceFolder}",
      runtimeExecutable = "node",
      runtimeArgs = { [[--loader=\usr\local\lib\node_modules\ts-node\esm.mjs]] },
      args = { "${file}" },
      skipFiles = { [[<node_internals>\**]], [[node_modules\**]] },
      resolveSourceMapLocations = { [[${workspaceFolder}\**]], [[!**\node_modules\**]] },
    },
    {
      name = "Debug Jest Tests",
      type = "pwa-node",
      request = "launch",
      runtimeExecutable = "node",
      runtimeArgs = { [[.\node_modules\jest\bin\jest.js]] }, -- "--runInBand" },
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
    {
      name = "Attach Program (pwa-node, select pid)",
      type = "pwa-node",
      request = "attach",
      processId = require 'dap.utils'.pick_process,
      skipFiles = { [[<node_internals>\**]] },
      -- restart = true, -- https:\\code.visualstudio.com\docs\nodejs\nodejs-debugging#_restarting-debug-sessions-automatically-when-source-is-edited use with nodemon
    },
    {
      name = 'Launch chrome',
      type = "pwa-chrome",
      request = "launch",
      program = "${file}",
      url = function() return 'http://localhost:' .. vim.fn.input('Select port: ', 8080) end,
      port = 9222
    },
    {
      name = 'Attach chrome',
      type = "pwa-chrome",
      request = "attach",
      program = "${file}",
      port = 9222
    }
  }
end

AUC('FileType', {
  pattern = vim.list_extend(exts_js, { 'html' }),
  callback = function()
    vim.lsp.start {
      name = 'ng-ls',
      root_dir = get_root_dir { 'package.json', '.git' },
      cmd = { 'node', vscode_ext_path .. [[angular.ng-template-14.0.0\server\index.js]], "--stdio", "--tsProbeLocations", [[node_modules\typescript\lib\tsserverlibrary.js]],
        "--ngProbeLocations", [[node_modules\@angular\language-server\bin]] }
    }
  end
})

K("<leader>at", function()
  vim.lsp.buf_request(0, 'angular/isAngularCoreInOwningProject', vim.lsp.util.make_position_params(0),
    function(_, result) vim.print(result) end)

  vim.lsp.buf_request(0, 'angular/getTemplateLocationForComponent', vim.lsp.util.make_position_params(0),
    function(_, result)
      vim.lsp.util.jump_to_location(result, 'utf-8')
    end)
end)

K("<leader>ac", function()
  vim.lsp.buf_request(0, 'angular/getComponentsWithTemplateFile', vim.lsp.util.make_position_params(0),
    function(_, result)
      if #result == 1 then
        vim.lsp.util.jump_to_location(result[1], 'utf-8') -- TODO: check encoding
      else
        vim.fn.setqflist({}, ' ', {
          title = 'Language Server',
          items = vim.lsp.util.locations_to_items(result, 'utf-8'),
        })
        vim.cmd.copen()
      end
    end)
end)

local buffer, _uri, ns
K("<leader>aT", function()
  vim.lsp.buf_request(0, 'angular/getTcb', vim.lsp.util.make_position_params(0), function(_, result)
    if not result then return end
    local uri, content, ranges = result.uri, result.content, result.selections

    if not buffer or not vim.api.nvim_buf_is_loaded(buffer) then
      buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buffer, 'buftype', 'nofile')
      ns = vim.api.nvim_create_namespace('ng.nvim')
    end

    uri = tostring(uri):gsub('file:///', 'ng:///')
    if _uri ~= uri then
      _uri = uri
      vim.api.nvim_buf_set_name(buffer, uri)
      vim.api.nvim_buf_set_option(buffer, 'filetype', 'typescript')
    end

    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.fn.split(content, '\n'))
    vim.api.nvim_buf_set_option(buffer, 'modified', false)

    vim.cmd.tabnew(uri)
    if ranges and #ranges ~= 0 then
      for _, range in ipairs(ranges) do
        vim.highlight.range(
          buffer,
          ns,
          'Visual',
          { range.start.line, range.start.character },
          { range['end'].line, range['end'].character }
        )
      end

      vim.api.nvim_win_set_cursor(0, { ranges[1].start.line + 1, ranges[1].start.character })
    end
  end)
end)

---@UI

require 'nightfox'.setup { options = { transparent = true, inverse = { search = true } } }
vim.cmd 'colorscheme nordfox'

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

vim.api.nvim_set_hl(0, 'Statusline', { bg = 'NONE' })

local function draw_statusline()
  local vim_mode_hl = ({
    ['n']                                                       = 'MiniStatuslineModeNormal',
    ['v']                                                       = 'MiniStatuslineModeVisual',
    ['V']                                                       = 'MiniStatuslineModeVisual',
    [vim.api.nvim_replace_termcodes('<C-V>', true, true, true)] = 'MiniStatuslineModeVisual',
    ['i']                                                       = 'MiniStatuslineModeInsert',
    ['R']                                                       = 'MiniStatuslineModeReplace',
    ['c']                                                       = 'MiniStatuslineModeCommand'
  })[vim.fn.mode()] or 'MiniStatuslineModeOther'
  local githead_vimmode = ('%%#%s# %s %%*'):format(vim_mode_hl, vim.fn['fugitive#statusline']():sub(6,-3))

  local gs_dict = vim.b.gitsigns_status_dict or {}
  local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
  local diff_status =
      (added and added > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
      (changed and changed > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
      (removed and removed > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

  local diagnostic_status
  for _, level in ipairs(vim.diagnostic.severity) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    if count ~= 0 then
      diagnostic_status = (diagnostic_status or '') ..
          ('%%#Diagnostic%s#%s%s%%*'):format(level, level:sub(1, 1), count)
    end
  end

  local search = vim.fn.searchcount()

  vim.o.statusline = vim.fn.join(vim.tbl_filter(function(item) return item end, {
    githead_vimmode,
    diff_status,
    diagnostic_status,
    ((search.total or 0) > 0 and ('%s/%s'):format(search.current, search.total) or ''),
    '%=',
    ('%%#%s#%s%%*'):format(vim.o.modified and 'NeoTreeModified' or '', vim.fn.fnamemodify(vim.fn.expand '%', ':.')),
    '%P',
    os.date '%H:%M'
  }), ' ')
end

AUC(
  { 'WinEnter', 'BufEnter', 'SessionLoadPost', 'FileChangedShellPost', 'VimResized', 'Filetype', 'CursorMoved',
    'CursorMovedI', 'ModeChanged' },
  { callback = draw_statusline }
)
vim.fn.timer_start(2000, draw_statusline, { ['repeat'] = -1 })

local progress_token_to_title, progress_title_to_order, clients_title_progress, timerid_to_winbuf, spinner_frames = {},
    {}, {}, {}, { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷", index = 1 }

local function update_progress_notif(timer_id)
  spinner_frames.index = spinner_frames.index % #spinner_frames + 1

  local lines = {}
  for client_id, title_to_prog_info in pairs(clients_title_progress) do
    local spinner = (next(clients_title_progress[client_id]) and spinner_frames[spinner_frames.index] or '󰄬')
    local client_name = vim.tbl_get(vim.lsp.get_client_by_id(client_id) or {}, 'name')
    if not client_name then return end
    table.insert(lines, spinner .. ' ' .. client_name)

    local t = vim.tbl_values(title_to_prog_info)
    table.sort(t, function(a, b) return a.order - b.order > 0 end)
    vim.list_extend(lines, vim.tbl_map(function(v) return v.progress_info end, t))
  end

  if not vim.tbl_contains(vim.api.nvim_list_wins(), timerid_to_winbuf[timer_id].win) then
    return vim.fn.timer_stop(timer_id)
  end
  if not next(progress_token_to_title) and #lines == 0 then
    return vim.api.nvim_win_close(timerid_to_winbuf[timer_id].win, false)
  end

  vim.api.nvim_win_set_height(timerid_to_winbuf[timer_id].win, #lines)
  vim.api.nvim_buf_set_lines(timerid_to_winbuf[timer_id].buf, 0, -1, false, lines)
end

local _progress_handler = vim.lsp.handlers['$/progress']
vim.lsp.handlers['$/progress'] = function(_, result, ctx)
  _progress_handler(_, result, ctx)
  local token, val, client_id = result.token, result.value, ctx.client_id
  local title                 = val.title or vim.tbl_get(progress_token_to_title, client_id, token)
  local message_maybe_prev    = val.message or vim.tbl_get(clients_title_progress, client_id, title, 'message') or ''
  local percentage            = val.kind == 'end' and 'Complete' or val.percentage and val.percentage .. '%' or ''

  if val.kind == "begin" then
    progress_token_to_title[client_id] = vim.tbl_deep_extend('error', progress_token_to_title[client_id] or {},
      { [token] = title })
    progress_title_to_order[client_id] = vim.tbl_deep_extend('keep', progress_title_to_order[client_id] or {},
      { [title] = #vim.tbl_keys(progress_title_to_order[client_id] or {}) + 1 })

    if not next(clients_title_progress) then
      local timer_id = vim.fn.timer_start(100, update_progress_notif, { ['repeat'] = -1 })
      local buf = vim.api.nvim_create_buf(false, true)
      timerid_to_winbuf[timer_id] = {
        buf = buf,
        win = vim.api.nvim_open_win(buf, false,
          {
            relative = 'win',
            anchor = 'NE',
            width = 45,
            height = 1,
            row = 0,
            col = vim.fn.winwidth(0),
            style = 'minimal',
            focusable = false
          })
      }
    end
  elseif val.kind == "end" then
    progress_token_to_title[client_id][token] = nil
    if not next(progress_token_to_title[client_id]) then progress_token_to_title[client_id] = nil end

    vim.defer_fn(function()
      (clients_title_progress[client_id] or {})[title] = nil
      if not next(clients_title_progress[client_id] or {}) then clients_title_progress[client_id] = nil end
    end, 1000)
  end

  clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
    {
      [title] = {
        progress_info = ('%s %s %s'):format(title, message_maybe_prev, percentage),
        message = message_maybe_prev,
        order = progress_title_to_order[client_id][title]
      }
    })
end

K('<leader>1', '<cmd>tab term npm run start:bff<cr><cmd>sp | term npm run start:ssr<cr><cmd>vsp | term npm run start<cr>')
K('<leader>2', ':!TortoiseGitProc /command:log /path:.')
K('<leader>3', function () vim.ui.input({}, function(ans)
    if not ans then return end
    vim.cmd("put =strftime('%H:%M').' " .. ans .. " ' | .w! >> ~\\" .. os.date('%m%d'))
    vim.cmd"undo"
  end)
end)
K('<leader>4', [[<cmd>!rm -rf C:\Users\sugimoto-hi\AppData\Local\nvim-data\swap<cr>]])
K('<leader>5', '<cmd>set tabstop=2<cr><cmd>set noexpandtab<cr><cmd>%retab!<cr>')
