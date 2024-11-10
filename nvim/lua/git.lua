K('<leader>gC', require 'telescope.builtin'.git_commits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits)
K('<leader>gc', require 'telescope.builtin'.git_bcommits_range, { mode = { 'x' } })
K('<leader>gb', require 'telescope.builtin'.git_branches)
K('<leader>gs', require 'telescope.builtin'.git_stash)

require 'gitsigns'.setup {
  signcolumn = false,
  numhl = true,
  word_diff = true,
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

    K('Hs', ':Gitsigns stage_hunk<cr>', { mode = { 'n', 'v' } })
    K('Hr', ':Gitsigns reset_hunk<cr>', { mode = { 'n', 'v' } })
    K('Hu', gs.undo_stage_hunk)
    K('Hp', gs.preview_hunk)
    K('Hb', function() gs.blame_line { full = true } end)
    K('Hd', gs.toggle_deleted)
    K('ih', '<cmd>Gitsigns select_hunk<cr>', { mode = { 'o', 'v' } })
  end
}

require "octo".setup {}

CMD('GHGet', function()
  local repo_id = vim.fn.input 'Enter github {user/repo} to get the latest release from: '
  if repo_id == '' then return vim.notify 'no input' end

  local latest_release_data = vim.fn.system('curl -s "https://api.github.com/repos/' .. repo_id .. '/releases/latest"')

  local ok, latest_release_feed = pcall(vim.fn.json_decode, latest_release_data)
  if not ok then return vim.notify('not valid json: ' .. latest_release_data) end

  local releases = vim.tbl_map(function(item) return item.browser_download_url end, latest_release_feed.assets)

  vim.ui.select(releases, { prompt = 'Select release' }, function(choice)
    local cmd = 'curl -o %s'
    if choice:find 'tar%.gz$' then cmd = 'curl -fSL %s | tar xz' end
    vim.system({ cmd:format(choice) }, { text = true }, function(res)
      vim.notify('Request for ' .. choice .. ' settled: ' .. res.stdout .. res.stderr)
    end)
  end)
end, {})

CMD('Gistget', function()
  local gist_id = vim.fn.input 'Enter github {user/gist} to get: '
  if gist_id == '' then return vim.notify 'no input' end

  vim.system({ 'curl', '-s', ("https://api.github.com/gists/%s"):format(gist_id) }, { text = true }, function(res)
    if res.code ~= 0 then return vim.notify(res.stderr) end
    local ok, gist_json = pcall(vim.json.decode, res.stdout)
    if not ok then return vim.notify('not valid json: ' .. res.stdout) end
    for fname, fdata in pairs(gist_json.files) do
      vim.schedule(function()
        vim.cmd 'tabe'
        vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(fdata.content, '\n'))
        vim.api.nvim_buf_set_name(0, fname)
        vim.filetype.match { buf = 0, filename = fname }
      end)
    end
  end)
end, {})

