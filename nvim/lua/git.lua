--[[[

git diff COMMIT_HASH_1 COMMIT_HASH_2 | grep "your_search_term"
Gedit git-obj:filepath
0Gclog
Gclog --name-only
git update-index --skip-worktree
git update-index --no-skip-worktree

new
r! git show branch:file
file filename
filetype detect
set buftype=nowrite

G log --graph --abbrev-commit --format=format:'%C(bold blue)%h%C(reset)%C(red)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto) %C(bold green)(%ar)%C(reset)' --all

git diff-tree --no-commit-id --name-only -r $1

]]

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

    K(']s', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(gs.next_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('[s', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(gs.prev_hunk)
      return '<Ignore>'
    end, { expr = true })

    K('Ss', ':Gitsigns stage_hunk<cr>', { mode = { 'n', 'v' } })
    K('Sr', ':Gitsigns reset_hunk<cr>', { mode = { 'n', 'v' } })
    K('Su', gs.undo_stage_hunk)
    K('Sp', gs.preview_hunk)
    K('Sb', function() gs.blame_line { full = true } end)
    K('Sd', gs.toggle_deleted)
    K('ih', '<cmd>Gitsigns select_hunk<cr>', { mode = { 'o', 'v' } })
  end
}

require "octo".setup {}

CMD('GHGet', function()
  local repo_id = vim.fn.input 'Enter github {user/repo} to get the latest release from: '
  if repo_id == '' then return vim.notify 'no input' end

  local latest_release_data = vim.fn.system('curl -s "https://api.github.com/repos/' .. repo_id .. '/releases/latest"')

  local ok, latest_release_feed = pcall(vim.fn.json_decode, latest_release_data)
  assert(ok, 'should fetch latest release info ' .. latest_release_data)

  local releases = vim.tbl_map(function(item) return item.browser_download_url end, latest_release_feed.assets)

  vim.ui.select(releases, { prompt = 'Select release' }, function(choice)
    local log_gh = vim.schedule_wrap((function(data)
      vim.notify(('Fetch %s %s'):format(choice,
        data.stderr or data.stdout))
    end))

    vim.system({ 'curl', '-sSLO', choice }, { text = true }, function(curl_data)
      assert(curl_data.code == 0, 'should curl ' .. choice)
      local tar_file = choice:match '([^/]+)%.tar%.gz$'
      if tar_file then
        vim.system(
          { 'tar', 'xf', tar_file .. '.tar.gz', '--transform', ('s,^,%s/,'):format(tar_file), '--remove-filies' },
          {}, log_gh)
      else
        log_gh(curl_data)
      end
    end)
  end)
end, {})

CMD('Gistget', function()
  local gist_id = vim.fn.input 'Enter github {user/gist} to get: '
  if gist_id == '' then return vim.notify 'no input' end

  vim.system({ 'curl', '-s', ("https://api.github.com/gists/%s"):format(gist_id) }, { text = true }, function(res)
    local ok, gist_json = pcall(vim.json.decode, res.stdout)
    assert(ok, 'should decode json ' .. (res.stderr or res.stdout))
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

AUC('FileType', {
  pattern = 'gitcommit',
  callback = function(ev)
    local issuekey = vim.fn['fugitive#statusline']():match '[A-Z]+-%d+'
    if not issuekey or vim.api.nvim_buf_get_lines(0, 0, 1, {})[1] ~= '' then return end
    vim.api.nvim_buf_set_text(ev.buf, 0, 0, 0, 0, { issuekey })

    local cmd = ([[
      curl --request GET --url ""
        --user ""
        --header 'Accept: application/json'
    ]]):format(issuekey):gsub('%s+', ' ')
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local ok, res_tbl = pcall(vim.json.decode, vim.fn.join(data, ''))
        if ok then
          vim.api.nvim_buf_set_text(ev.buf, 0, -1, 1, -1, { vim.tbl_get(res_tbl, 'issues', 1, 'fields', 'summary') })
        else
          vim.api.nvim_buf_set_text(ev.buf, 0, 0, 0, -1, { '' })
          vim.api.nvim_buf_delete(ev.buf, { force = true })
          vim.print('No issue found')
        end
      end
    })
  end
})
