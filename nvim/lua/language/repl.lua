require 'iron.core'.setup {
  config = {},
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_paragraph = "<space>sp",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    send_code_block = "<space>sb",
    send_code_block_and_move = "<space>sn",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
}

K('<leader>..', function()
  local lines = vim.fn.mode() == 'n' and { vim.fn.getline '.' } or
      vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })

  if vim.g.repl_luafile == nil or vim.fn.filereadable(vim.g.repl_luafil) == 0 then
    vim.g.repl_luafile = os.tmpname()
  end
  vim.fn.writefile(lines, vim.g.repl_luafile, 'a')

  local ok, res = pcall(vim.api.nvim_exec2, 'luafile ' .. vim.g.repl_luafile, { output = true })

  if not ok then os.remove(vim.g.repl_luafile) end
  vim.notify(res.output, vim.log.levels[ok and 'INFO' or 'ERROR'])
end, { mode = { 'n', 'v' } })

K('<leader>.c', '<cmd>call delete(g:repl_luafile)<cr>')
