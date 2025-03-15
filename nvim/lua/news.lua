local month_tbl = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }

local dt_fmt = '%Y-%m-%dT%H:%M:%SZ'

local data_list = {
  {
    title = 'Neovim commits',
    type = 'xml',
    url = 'https://github.com/neovim/neovim/commits/master/runtime/doc/news.txt.atom',
    callback = function(t, d)
      local new_entry = {}
      for _, item in ipairs(t.feed.entry) do
        local y, mo, dy, h, m, s = item.updated:match('(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z')
        if os.difftime(d, os.time({ year = y, month = mo, day = dy, hour = h, min = m, sec = s })) > 0 then
          break
        end
        vim.list_extend(new_entry, { '- ' .. item.title, item.link._attr.href, '' })
      end
      return new_entry
    end
  },
  {
    title = 'Neovim reddit',
    url = 'https://www.reddit.com/r/neovim/hot.json',
    callback = function(t, d)
      local new_entry = {}
      for _, item in ipairs(t.data.children) do
        if os.difftime(d, item.data.created) < 0
            and not item.data.link_flair_text:find 'Need Help'
            and not item.data.link_flair_text:find '101 Questions'
        then
          vim.list_extend(new_entry,
            { '- ' .. item.data.title, unpack(vim.split(item.data.selftext, '\n')), item.data.url, '' })
        end
      end
      return new_entry
    end
  },
  {
    title = 'awesome-neovim',
    url = function(dt) return 'https://api.github.com/repos/rockerBOO/awesome-neovim/commits?since=' .. dt end,
    callback = function(t, _)
      local new_entry = {}
      if #t == 0 then return new_entry end
      local diff_url = ('http://github.com/rockerBOO/awesome-neovim/compare/%s..HEAD.diff'):format(t[#t].sha)
      local data = vim.system({ 'curl', '-sSL', diff_url }, { text = true }):wait()
      for url, desc in data.stdout:gmatch "%+%-? %[[^%]]+%]%((https://[^%)]+)%) %- ([^\n]+)" do
        vim.list_extend(new_entry, { '- ' .. desc, url, '' })
      end
      return new_entry
    end
  },
  {
    title = 'Dotfyle',
    type = 'xml',
    url = 'https://dotfyle.com/this-week-in-neovim/rss.xml',
    callback = function(t, d)
      local new_entry = {}
      for _, item in ipairs(t.rss.channel.item) do
        local dy, mo, y, h, m, s = item.pubDate:match(', (%S+) (%S+) (%S+) (%d+):(%d+):(%d+)')
        if os.difftime(d, os.time({ year = y, month = month_tbl[mo], day = dy, hour = h, min = m, sec = s })) > 0 then
          break
        end
        vim.list_extend(new_entry, { '- ' .. item.title, item.link, '' })
      end
      return new_entry
    end
  }
}

CMD('News',
  function()
    local file = vim.uv.os_homedir() .. '/nav.md'
    vim.cmd.tabe(file)
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local now = os.time()
    local dt = vim.fn.strptime(dt_fmt, lines[1]) ~= 0 and lines[1] or os.date(dt_fmt, now - 864000) .. '' -- 10 days ago
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, { os.date(dt_fmt, now) .. '' })

    for _, item in ipairs(data_list) do
      local url = type(item.url) == 'function' and item.url(dt) or item.url
      vim.system({ 'curl', url }, {}, vim.schedule_wrap(function(data)
        local stdout = assert(data.code == 0 and data.stdout or nil, 'curl failed ' .. url .. ' ' .. data.stderr)
        local ok, t = pcall(item.type == 'xml' and require 'xml2lua'.parse or vim.json.decode, stdout)
        if not ok then return vim.notify(stdout, vim.log.levels.ERROR) end
        local new_entry = item.callback(t, vim.fn.strptime(dt_fmt, dt))

        if #new_entry > 0 then
          local title = '## ' .. item.title
          local insert_index = vim.fn.index(vim.api.nvim_buf_get_lines(buf, 0, -1, false), title)
          if insert_index == -1 then
            new_entry = { title, '', unpack(new_entry) }
          else
            insert_index = insert_index + 2
          end
          vim.api.nvim_buf_set_lines(buf, insert_index, insert_index, false, new_entry)
          vim.cmd 'write'
        end
      end))
    end
  end
  , {})
