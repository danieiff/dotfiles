require 'iron.core'.setup { config = {} }

K('<leader>..', function()
  local lines = vim.fn.mode() == 'n' and { vim.fn.getline '.' } or
      vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })

  vim.g.repl_luafile = os.tmpname()
  vim.fn.writefile(lines, vim.g.repl_luafile, 'a')

  local ok, res = pcall(vim.api.nvim_exec2, 'luafile ' .. vim.g.repl_luafile, { output = true })

  if not ok then os.remove(vim.g.repl_luafile) end
  vim.notify(res.output, vim.log.levels[ok and 'INFO' or 'ERROR'])
end, { mode = { 'n', 'v' } })

K('<leader>c', 'delete(g:repl_luafile)')
