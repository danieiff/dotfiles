local month_tbl = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }

local dt_fmt = '%Y-%m-%dT%H:%M:%SZ'

local news_list = {
  {
    title = 'Neovim commits',
    type = 'xml',
    url = { 'https://github.com/neovim/neovim/commits/master/runtime/doc/news.txt.atom' },
    callback = function(t, d)
      local new_entry = ''
      for _, item in ipairs(t.feed.entry) do
        local y, mo, dy, h, m, s = item.updated:match('(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z')
        if os.difftime(d, os.time({ year = y, month = mo, day = dy, hour = h, min = m, sec = s })) > 0 then
          break
        end
        new_entry = ('%s\n- %s\n  %s'):format(new_entry, item.title, item.link._attr.href)
      end
      return new_entry
    end
  },
  {
    title = 'Neovim reddit',
    url = { 'https://www.reddit.com/r/neovim/hot.json', '-b', os.getenv 'REDDIT_TOKEN', '-H', 'user-agent:Chrome' },
    callback = function(t, d)
      local new_entry = ''
      for _, item in ipairs(t.data.children) do
        if os.difftime(d, item.data.created) < 0
            and not item.data.link_flair_text:find 'Need Help'
            and not item.data.link_flair_text:find '101 Questions'
        then
          new_entry = ('%s\n- %s\n  %s\n  %s\n'):format(new_entry, item.data.title, item.data.selftext, item.data.url)
        end
      end
      return new_entry
    end
  },
  {
    title = 'awesome-neovim',
    url = function(dt) return { 'https://api.github.com/repos/rockerBOO/awesome-neovim/commits?since=' .. dt } end,
    callback = function(t, _)
      local new_entry = ''
      if #t == 0 then return new_entry end
      local diff_url = ('http://github.com/rockerBOO/awesome-neovim/compare/%s..HEAD.diff'):format(t[#t].sha)
      local data = vim.system({ 'curl', '-sSL', diff_url }, { text = true }):wait()
      for url, desc in data.stdout:gmatch "%+%-? %[[^%]]+%]%((https://[^%)]+)%) %- ([^\n]+)" do
        new_entry = ('%s\n- %s\n  %s'):format(new_entry, desc, url)
      end
      return new_entry
    end
  },
  {
    title = 'Dotfyle',
    type = 'xml',
    url = { 'https://dotfyle.com/this-week-in-neovim/rss.xml' },
    callback = function(t, d)
      local new_entry = ''
      for _, item in ipairs(t.rss.channel.item) do
        local dy, mo, y, h, m, s = item.pubDate:match(', (%S+) (%S+) (%S+) (%d+):(%d+):(%d+)')
        if os.difftime(d, os.time({ year = y, month = month_tbl[mo], day = dy, hour = h, min = m, sec = s })) > 0 then
          break
        end
        new_entry = ('%s\n- %s\n  %s'):format(new_entry, item.title, item.link)
      end
      return new_entry
    end
  }
}

local file = vim.uv.os_homedir() .. '/nav.md'
local news_lines = vim.iter(io.lines(file)):totable()

local now = os.time()
local five_days_ago = now - 60 * 60 * 24 * 5
local prev_t = vim.fn.strptime(dt_fmt, news_lines[1])
if prev_t == 0 then prev_t = five_days_ago end

if five_days_ago < prev_t then return end

local prev_dt = os.date(dt_fmt, prev_t)
news_lines[1] = os.date(dt_fmt, now)

local completions = 0

for _, item in ipairs(news_list) do
  local url = type(item.url) == 'function' and item.url(prev_dt, news_lines[#news_lines]) or item.url
  vim.system({ 'curl', unpack(url) }, {}, vim.schedule_wrap(function(data)
    completions = completions + 1

    local ok, t = pcall(item.type == 'xml' and require 'xml2lua'.parse or vim.json.decode, data.stdout)
    if not ok then
      vim.notify(('%s\n%s\n%s'):format(item.title, data.stdout, data.stderr))
    else
      local new_entry = item.callback(t, prev_t)
      if new_entry ~= '' then
        local title = '## ' .. item.title
        local insert_index = vim.fn.index(news_lines, title)
        if insert_index == -1 then
          new_entry = title .. '\n\n' .. new_entry
        else
          insert_index = insert_index + 2
        end
        table.insert(news_lines, insert_index, new_entry)
      end
    end

    if completions == #news_list then
      local file = assert(io.open(file, 'w'))
      file:write(table.concat(news_lines, '\n'))
      file:close()
    end
  end))
end
