require 'sniprun'.setup {
  selected_interpreters = { 'Lua_nvim' },
  display = { 'VirtualText', },
  live_mode_toggle = 'enable', inline_messages = true
}
K('<leader>.,', ':SnipRun<cr>', { mode = { 'n', 'v' } })

local ft_to_exec = {
  lua = function(fname)
    return vim.api.nvim_exec2('luafile ' .. fname, { output = true })
  end,
  typescript = { '', '' }
}

local function complete(ft, err, data)
  if err then
    os.remove(vim.fn.stdpath 'data' .. '/repl.' .. ft)
  end
  vim.notify(err or data)
end

K('<leader>..', function()
  local ft = vim.bo.ft
  local lines = vim.fn.mode() == 'n' and { vim.fn.getline '.' } or
      vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })

  local fname = vim.fn.stdpath 'data' .. '/repl.' .. ft
  vim.fn.writefile(lines, fname, 'a')

  local exec = ft_to_exec[ft]
  local exec_type = type(exec)

  if exec_type == 'function' then
    complete(ft, pcall(exec, fname))
  elseif exec_type == 'table' then
    local cmd = vim.tbl_map(function(component) return component:gsub('<file>', fname) end, exec)
    vim.system(cmd, { text = true }, function(data)
      complete(ft, data.stderr, data.stdout)
    end)
  end
end, { mode = { 'n', 'v' } })
