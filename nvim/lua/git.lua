--[[[
git diff COMMIT_HASH_1 COMMIT_HASH_2 | grep "your_search_term"
git update-index --skip-worktree
git update-index --no-skip-worktree

new
r! git show branch:file
file filename
filetype detect
set buftype=nowrite

git diff-tree --no-commit-id --name-only -r $1

blame gitsigns
hunk gitsigns
view other versions of file gitsigns

git fetch origin 'refs/heads/ft_d*:refs/remotes/origin/ft_d*'

git branch --list 'o*' | xargs -r git branch -d

github octo
pr octo
issue octo
pr review octo

diff diffview
file history diffview

status
log
log filter
stash
stage
commit
merge
rebase
cherry-pick
reset
reflog
revert
push
pull
fetch
remote
branch
checkout
submodule
get link in browser
]]

K('<c-g><c-g>', '<cmd>Neogit kind=floating<cr>')

K('<c-g>f', function()
  if vim.t.diffview_view_initialized then
    vim.cmd 'DiffviewClose'
    vim.cmd 'tabp'
  else
    vim.cmd ':DiffviewFileHistory --follow %'
  end
end, { mode = { 'n', 'v' } })
K('<c-g>d', function()
  if vim.t.diffview_view_initialized then
    vim.cmd 'DiffviewClose'
    vim.cmd 'tabp'
  else
    vim.cmd 'DiffviewOpen'
  end
end)

local gs = require 'gitsigns'
gs.setup {
  signcolumn = false,
  numhl = true,
  word_diff = true,
  current_line_blame = true,
  on_attach = function(bufnr)
    for _, keymap in ipairs {
      { ']h', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end },
      { '[h', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end },
      { '<c-g>s', gs.stage_hunk },
      { '<c-g>r', gs.reset_hunk },
      { '<c-g>u', gs.undo_stage_hunk },
      { '<c-g>p', gs.preview_hunk },
      { '<c-g>b', function() gs.blame_line { full = true } end },
      { '<c-g>B', gs.blame },
      { '<c-g>D', gs.toggle_deleted },
      { 'ih',     '<cmd>Gitsigns select_hunk<cr>',             { 'o', 'x' } },
      { '<c-g>S', gs.stage_buffer },
      { '<c-g>R', gs.reset_buffer },
    } do
      K(keymap[1], keymap[2], { mode = keymap[3], buffer = bufnr })
    end
  end
}

require "octo".setup { picker = 'fzf-lua' }
K('<leader>os', '<cmd>Octo issue search<cr>')
K('<leader>ol', '<cmd>Octo issue list<cr>')

CMD('GHGet', function()
  local repo_id = vim.fn.input 'Enter github {user/repo} to get the latest release from: '
  if repo_id == '' then return vim.notify 'no input' end

  local latest_release_data = vim.fn.system('curl -s "https://api.github.com/repos/' .. repo_id .. '/releases/latest"')

  local ok, latest_release_feed = pcall(vim.fn.json_decode, latest_release_data)
  assert(ok, 'should fetch latest release info ' .. latest_release_data)

  local releases = vim.tbl_map(function(item) return item.browser_download_url end, latest_release_feed.assets)

  vim.ui.select(releases, { prompt = 'Select release' }, function(choice)
    if not choice then return end

    local log_gh = vim.schedule_wrap((function(data)
      vim.notify(('Fetch %s %s'):format(choice,
        data.stderr or data.stdout))
    end))

    vim.system({ 'curl', '-sSLO', choice }, { text = true }, function(curl_data)
      assert(curl_data.code == 0, 'should curl ' .. choice)
      local tar_file = choice:match '([^/]+)%.tar%.gz$'
      if tar_file then
        vim.system(
          { 'tar', 'xf', tar_file .. '.tar.gz', '--transform', ('s,^,%s/,'):format(tar_file), '--remove-files' },
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
    local issuekey = vim.g.gitsigns_head:match '[A-Z]+-%d+'
    if not issuekey or vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] ~= '' then return end
    vim.api.nvim_buf_set_text(ev.buf, 0, 0, 0, 0, { issuekey })

    local cmd = ([[
      curl --request GET --url ""
        --user ""
        --header 'Accept: application/json'
    ]]):format(issuekey):gsub('%s+', ' ')
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data.code ~= 0 then return end
        local ok, res_tbl = pcall(vim.json.decode, vim.fn.join(data, ''))
        assert(ok, 'should decode json ' .. vim.fn.join(data, ''))
        vim.api.nvim_buf_set_text(ev.buf, 0, -1, 1, -1, { vim.tbl_get(res_tbl, 'issues', 1, 'fields', 'summary') })
      end
    })
  end
})
