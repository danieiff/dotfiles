require 'iron.core'.setup {
  keymaps = {
    toggle_repl = "<leader>ii",
    send_motion = "<leader>is",
    visual_send = "<leader>is",
    send_file = "<leader>i%",
    send_line = "<leader>iI",
    send_paragraph = "<leader>ip",
    send_until_cursor = "<leader>i.",
    send_mark = "<leader>iM",
    mark_motion = "<leader>im",
    mark_visual = "<leader>im",
    remove_mark = "<leader>id",
    exit = "<leader>iq",
    clear = "<leader>ic"
  }
}

K('<leader>iw', '<cmd>IronWatch file<cr>')
K('<leader>ir', '<cmd>IronRestart<cr>')

K('<leader>..', function()
  local lines = vim.fn.mode() == 'n' and { vim.fn.getline '.' } or
      vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })

  if vim.g.repl_luafile == nil or vim.fn.filereadable(vim.g.repl_luafile) == 0 then
    vim.g.repl_luafile = os.tmpname()
  end
  vim.fn.writefile(lines, vim.g.repl_luafile, 'a')

  local ok, res = pcall(vim.api.nvim_exec2, 'luafile ' .. vim.g.repl_luafile, { output = true })

  if not ok then os.remove(vim.g.repl_luafile) end
  vim.notify(res.output, vim.log.levels[ok and 'INFO' or 'ERROR'])
end, { mode = { 'n', 'v' } })

K('<leader>.c', '<cmd>call delete(g:repl_luafile)<cr>')
