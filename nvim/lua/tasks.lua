local overseer = require 'overseer'
overseer.setup {}

K('<leader>tt', '":<c-u>OverseerToggle" . (v:count ? "" : "!") . "<cr>"', { expr = true })
K('<leader>ts', '<cmd>OverseerSaveBundle<cr>')
K('<leader>tl', '<cmd>OverseerLoadBundle<cr>')
K('<leader>td', '<cmd>OverseerDeleteBundle<cr>')
K('<leader>tr', '<cmd>OverseerRun<cr>')
K('<leader>tC', '<cmd>OverseerRunCmd<cr>')
K('<Leader>$', '<cmd>OverseerRunCmd ' .. vim.o.shell .. '<cr>')
K('<Leader>%', '<cmd>OverseerRunCmd top<cr>')
K('<leader>ti', '<cmd>OverseerInfo<cr>')
K('<leader>tb', '<cmd>OverseerBuild<cr>')
K('<leader>tq', '<cmd>OverseerQuickAction<cr>')
K('<leader>ta', '<cmd>OverseerTaskAction<cr>')
K('<leader>tc', '<cmd>OverseerClearCache<cr>')

CMD('Base64Encode', function(arg)
  vim.print(vim.base64.encode(arg.args))
end, { nargs = 1 })

CMD('Base64Decode', function(arg)
  vim.print(vim.base64.decode(arg.args))
end, { nargs = 1 })

CMD('UriEncode', function(arg)
  vim.print(vim.uri_encode(arg.args, 'rfc3986'))
end, { nargs = 1 })

CMD('UriDecode', function(arg)
  vim.print(vim.uri_decode(arg.args))
end, { nargs = 1 })

CMD('UrlSplitJoin', function()
  local urlpath, querystring = unpack(vim.split(vim.api.nvim_get_current_line(), '?'))
  if urlpath and querystring then
    local lines = { urlpath }
    local queryparams = vim.fn.sort(vim.split(querystring, '&'))
    for idx, queryparam in ipairs(queryparams) do
      table.insert(lines, (idx == 1 and '?' or '&') .. queryparam)
    end
    vim.api.nvim_buf_set_lines(0, vim.api.nvim_win_get_cursor(0)[1] - 1, -1, false, lines)
  else
    vim.cmd [['{,'}s/\n\@<!//g]]
  end
end, {})
