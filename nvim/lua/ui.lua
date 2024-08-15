-- :so $VIMRUNTIME/syntax/hitest.vim
vim.cmd [[
hi Normal guifg=#444444 guibg=NvimLightGray2
hi Visual guibg=#CCCCCC

hi Comment guifg=#628562 gui=italic
hi Conceal guifg=#777777 gui=bold,italic

hi Error guifg=#DC5284
hi WarningMsg guifg=#C48562
hi! link ErrorMsg Error
hi! link DiagnosticWarn WarningMsg
hi! link DiagnosticError Error
hi DiagnosticHint guifg=#896788
hi DiagnosticInfo guifg=#0084A3
hi DiagnosticOk guifg=#628562
hi DiagnosticSignError guifg=#DC5284
hi DiagnosticSignHint guifg=#896788
hi DiagnosticSignInfo guifg=#0084A3
hi DiagnosticSignOk guifg=#628562
hi DiagnosticSignWarn guifg=#C48562
hi DiagnosticUnderlineError guisp=#DC5284 gui=undercurl
hi DiagnosticUnderlineHint guisp=#896788 gui=undercurl
hi DiagnosticUnderlineInfo guisp=#0084A3 gui=undercurl
hi DiagnosticUnderlineOk guisp=#628562 gui=undercurl
hi DiagnosticUnderlineWarn guisp=#C48562 gui=undercurl
hi DiagnosticVirtualTextError guifg=#DC5284 guibg=#E9D1D7
hi DiagnosticVirtualTextHint guifg=#896788 guibg=#E8D0E7
hi DiagnosticVirtualTextInfo guifg=#0084A3 guibg=#C2DBE8
hi DiagnosticVirtualTextOk guifg=#628562 guibg=#A3E8A3
hi DiagnosticVirtualTextWarn guifg=#C48562 guibg=#E9D3CA
hi! link DiagnosticDeprecated DiagnosticWarn
hi! link DiagnosticUnnecessary DiagnosticWarn

hi FloatBorder guifg=#6A6A6A

hi Cursor guifg=#CCCCCC guibg=#555555
hi CursorLine guibg=#DADADA
hi! link CursorColumn CursorLine
hi CursorLineNr guifg=#555555 gui=bold
hi lCursor guifg=#CCCCCC guibg=#747474
hi FoldColumn guifg=#919191 gui=bold
hi Folded guifg=#4B4B4B guibg=#BBBBBB
hi LineNr guifg=#919191
hi! link SignColumn LineNr

hi Search guifg=#555555 guibg=#CBB1CA
hi IncSearch guifg=#CCCCCC guibg=#9E779D gui=bold
hi! link CurSearch IncSearch
hi Keyword guifg=#CA6284 gui=bold
hi! link Exception Keyword
hi! link ModeMsg Normal
hi MoreMsg guifg=#628562 gui=bold
hi! link Question MoreMsg

hi NonText guifg=#A6A6A6
hi! link Whitespace NonText

hi NormalFloat guibg=#CFCFCF

hi WildMenu guifg=#CCCCCC guibg=#896788
hi Pmenu guibg=#C9C9C9
hi PmenuSbar guibg=#9E9E9E
hi PmenuSel guibg=#B0B0B0
hi PmenuThumb guibg=#F3F3F3

hi! link MatchParen Search
hi! link QuickFixLine Search

hi StatusLine guifg=#555555 guibg=#C4C4C4
hi! link WinBar StatusLine
hi WinBarNC guifg=#818181 guibg=#D4D4D4
hi! link TabLine StatusLine
hi TabLineSel gui=bold
hi Title guifg=#555555 gui=bold
hi WinSeparator guifg=#919191
hi! link VertSplit WinSeparator

hi DiffAdd guibg=#AEDEAE
hi DiffChange guibg=#C0D5E0
hi DiffDelete guibg=#E5CBD1
hi DiffText guifg=#555555 guibg=#99B5C3
hi diffAdded guifg=#628562
hi diffChanged guifg=#0084A3
hi diffFile guifg=#C48562 gui=bold
hi diffIndexLine guifg=#C48562
hi diffLine guifg=#896788 gui=bold
hi diffNewFile guifg=#628562 gui=italic
hi diffOldFile guifg=#DC5284 gui=italic
hi diffRemoved guifg=#DC5284
hi GitSignsAdd guifg=#628562
hi GitSignsChange guifg=#0084A3
hi GitSignsDelete guifg=#DC5284

hi Constant guifg=#7C7C7C gui=italic
hi! link Character Constant
hi! link Float Constant
hi String guifg=#4A7587 gui=italic
hi Number guifg=#896500 gui=italic
hi! link Boolean Number
hi Identifier guifg=#555555
hi Function guifg=#6C6B20
hi Statement guifg=#0084A3 gui=bold
hi PreProc guifg=#BE6A84
hi Type guifg=#6D4C52
hi Special guifg=#755F74
hi Delimiter guifg=#7C7C7C
hi SpecialComment guifg=#868686
hi Todo gui=bold,underline

hi! link @variable Identifier
hi! link @variable.builtin Number
hi! link @variable.parameter @variable
hi! link @variable.member @variable

hi @constant guifg=#555555 gui=bold
hi! link @constant.builtin Number
hi! link @constant.macro Number

hi! link @module Number
hi! link @module.builtin @module
hi! link @label Statement

hi! link @string Constant
hi! link @string.documentation @string
hi! link @string.regexp Constant
hi! link @string.escape Special
hi! link @string.special Special
hi! link @string.special.symbol Identifier
hi! link @string.special.url @string.special
hi! link @string.special.path @string.special

hi! link @character Constant
hi! link @character.special Special

hi! link @boolean Number
hi! link @number Number
hi! link @number.float @number

hi! link @type Type
hi! link @type.builtin @type
hi! link @type.definition @type
hi! link @type.qualifier @type

hi! link @attribute PreProc
hi! link @property Identifier

hi! link @function Function
hi! link @function.builtin Special
hi! link @function.call @function
hi! link @function.macro PreProc
hi! link @function.method @function
hi! link @function.method.call @function

hi! link @constructor Special
hi! link @operator Statement

hi! link @keyword.coroutine Statement
hi! link @keyword.function Statement
hi! link @keyword.operator Statement
hi! link @keyword.import PreProc
hi! link @keyword.storage Type
hi! link @keyword.repeat Statement
hi! link @keyword.return Statement
hi! link @keyword.debug Special
hi! link @keyword.exception Statement
hi! link @keyword.conditional Statement
hi! link @keyword.conditional.ternary @keyword.conditional
hi! link @keyword.directive PreProc
hi! link @keyword.directive.define @keyword.directive

hi! link @punctuation.delimiter Delimiter
hi! link @punctuation.bracket Delimiter
hi! link @punctuation.special Delimiter

hi! link @comment Comment
hi! link @comment.documentation @comment
hi! link @comment.error Error
hi! link @comment.warning WarningMsg
hi! link @comment.todo Todo
hi! link @comment.note DiagnosticInfo

hi @markup.strong gui=bold
hi @markup.italic gui=italic
hi @markup.strikethrough gui=strikethrough
hi @markup.underline gui=underline
hi! link @markup.heading Title
hi @markup.quote guifg=#7C7C7C
hi! link @markup.math Special
hi! link @markup.environment PreProc
hi! link @markup.link Constant
hi! link @markup.link.label Special
hi! link @markup.link.url Constant
hi! link @markup.raw Constant
hi! link @markup.raw.block @markup.raw
hi! link @markup.list Special
hi! link @markup.list.checked @markup.list
hi! link @markup.list.unchecked @markup.list

hi! link @diff.plus GitSignsAdd
hi! link @diff.minus GitSignsRemove
hi! link @diff.delta GitSignsChange

hi! link @tag Special
hi! link @tag.attribute @property
hi! link @tag.delimiter Delimiter

hi! link @none None

hi! link @punctuation.special.markdown Special
hi! link @string.escape.markdown SpecialKey
hi @markup.link.markdownr guifg=#555555 gui=underline
hi @markup.italic.markdown gui=italic
hi! link @markup.title.markdown Statement
hi! link @markup.raw.markdown Type
hi! link @markup.link.url.markdown SpecialComment

hi @markup.link.vimdocr guifg=#555555 gui=underline
hi! link @markup.raw.block.vimdoc @markup.raw
hi! link @variable.parameter.vimdoc Type
hi @label.vimdoc guifg=#6D4C52 gui=bold

hi! link @lsp.type.boolean @boolean
hi! link @lsp.type.builtinType @type.builtin
hi! link @lsp.type.comment @comment
hi! link @lsp.type.decorator @attribute
hi! link @lsp.type.deriveHelper @attribute
hi! link @lsp.type.enum @type
hi! link @lsp.type.enumMember @constant
hi! link @lsp.type.escapeSequence @string.escape
hi! link @lsp.type.formatSpecifier @markup.list
hi! link @lsp.type.generic @variable
hi! link @lsp.type.interface @type
hi! link @lsp.type.keyword Statement
hi! link @lsp.type.lifetime @keyword.storage
hi! link @lsp.type.namespace @module
hi! link @lsp.type.number @number
hi! link @lsp.type.operator @operator
hi! link @lsp.type.parameter @variable.parameter
hi! link @lsp.type.property @property
hi! link @lsp.type.selfKeyword @variable.builtin
hi! link @lsp.type.selfTypeKeyword @variable.builtin
hi! link @lsp.type.string @string
hi! link @lsp.type.typeAlias @type.definition
hi @lsp.type.unresolvedReference gui=undercurl, guifg=#DC5284
hi! link @lsp.type.variable None
hi! link @lsp.typemod.class.defaultLibrary @type.builtin
hi! link @lsp.typemod.enum.defaultLibrary @type.builtin
hi! link @lsp.typemod.enumMember.defaultLibrary @constant.builtin
hi! link @lsp.typemod.function.defaultLibrary @function.builtin
hi! link @lsp.typemod.keyword.async @keyword.coroutine
hi! link @lsp.typemod.keyword.injected Statement
hi! link @lsp.typemod.macro.defaultLibrary @function.builtin
hi! link @lsp.typemod.method.defaultLibrary @function.builtin
hi! link @lsp.typemod.operator.injected @operator
hi! link @lsp.typemod.string.injected @string
hi! link @lsp.typemod.struct.defaultLibrary @type.builtin
hi! link @lsp.typemod.type.defaultLibrary @type
hi! link @lsp.typemod.typeAlias.defaultLibrary @type
hi! link @lsp.typemod.variable.callable @function
hi! link @lsp.typemod.variable.defaultLibrary @variable.builtin
hi! link @lsp.typemod.variable.injected @variable
hi! link @lsp.typemod.variable.static @constant

hi! link LspReferenceRead ColorColumn
hi! link LspReferenceText ColorColumn
hi! link LspReferenceWrite ColorColumn
hi! link LspCodeLens LineNr
hi LspInlayHint guifg=#9C868A guibg=#DDDDDD

hi! link markdownUrl SpecialComment
hi! link markdownCode Type
hi markdownLinkTextr guifg=#555555 gui=underline
hi! link markdownLinkTextDelimiter Delimiter

hi! link TelescopeSelection CursorLine
hi TelescopeSelectionCaret guifg=#DC5284 guibg=#DADADA
hi TelescopeMatching guifg=#896788 gui=bold
hi! link TelescopeBorder FloatBorder

hi IblIndent guifg=#D4D4D4
hi IblScope guifg=#ABABAB

hi! link TroubleNormal Function
hi! link TroubleText Function
hi! link TroubleSource Constant

hi Directory guifg=#4A7587 gui=bold
hi NvimTreeNormal guifg=#555555 guibg=#C4C4C4
hi! link NvimTreeWinSeparator NvimTreeNormal
hi NvimTreeCursorLine guibg=#D4D4D4
hi! link NvimTreeCursorColumn NvimTreeCursorLine
hi NvimTreeRootFolder guifg=#0084A3 gui=bold
hi NvimTreeSymlink guifg=#0084A3
hi! link NvimTreeGitDirty diffChanged
hi! link NvimTreeGitNew diffAdded
hi! link NvimTreeGitDeleted diffRemoved
hi NvimTreeSpecialFile guifg=#9E779D gui=underline

hi CmpItemAbbr guifg=#555555
hi! link CmpItemAbbrDeprecated DiagnosticWarn
hi CmpItemAbbrMatch guifg=#896500 gui=bold
hi CmpItemAbbrMatchFuzzy guifg=#F3F3F3 gui=bold
hi CmpItemKind guifg=#7C7C7C
hi CmpItemMenu guifg=#CCCCCC

hi FlashBackdrop guifg=#868686
hi FlashLabel guifg=#555555 guibg=#99B5C3
]]

require 'colorizer'.setup { user_default_options = { css_fn = false, tailwind = true } }

local function draw_statusline()
  local vim_mode_hl = ({
    ['n']                                                       = 'MiniStatuslineModeNormal',
    ['v']                                                       = 'MiniStatuslineModeVisual',
    ['V']                                                       = 'MiniStatuslineModeVisual',
    [vim.api.nvim_replace_termcodes('<C-V>', true, true, true)] = 'MiniStatuslineModeVisual',
    ['i']                                                       = 'MiniStatuslineModeInsert',
    ['R']                                                       = 'MiniStatuslineModeReplace',
    ['c']                                                       = 'MiniStatuslineModeCommand'
  })[vim.fn.mode()] or 'MiniStatuslineModeOther'
  local githead_vimmode = vim.g.gitsigns_head and ('%%#%s# %s %%*'):format(vim_mode_hl, vim.g.gitsigns_head)

  local gs_dict = vim.b.gitsigns_status_dict or {}
  local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
  local diff_status =
      (added and added > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
      (changed and changed > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
      (removed and removed > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

  local diagnostic_status
  for _, level in ipairs(vim.diagnostic.severity) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    if count ~= 0 then
      diagnostic_status = (diagnostic_status or '') ..
          ('%%#Diagnostic%s#%s%s%%*'):format(level, level:sub(1, 1), count)
    end
  end

  local search = vim.fn.searchcount()

  local file_modified_hl = vim.o.modified and 'NvimTreeModifiedFile' or ''

  vim.o.statusline = vim.fn.join(vim.tbl_filter(function(item) return item end, {
    githead_vimmode,
    diff_status,
    diagnostic_status,
    ((search.total or 0) > 0 and ('%s/%s'):format(search.current, search.total) or ''),
    '%=',
    vim.fn.fnamemodify(vim.loop.cwd(), ':~'),
    ('%%#%s#%s%%*'):format(file_modified_hl, vim.fn.fnamemodify(vim.fn.expand '%', ':.')),
    '%P',
    os.date '%H:%M'
  }), '  ')
end

AUC(
  { 'WinEnter', 'BufEnter', 'SessionLoadPost', 'FileChangedShellPost', 'VimResized', 'Filetype', 'CursorMoved',
    'CursorMovedI', 'ModeChanged', 'DirChanged' },
  { callback = draw_statusline }
)
vim.fn.timer_start(2000, draw_statusline, { ['repeat'] = -1 })


local win_bufname_ns = vim.api.nvim_create_namespace('win_bufname')
AUC({ 'WinEnter', 'WinScrolled', 'WinResized', 'VimResized' }, {
  nested = false,
  callback = function()
    local current_winnr = vim.api.nvim_tabpage_get_win(0)

    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local bufnr = vim.api.nvim_win_get_buf(winnr)
      local win_bufname_extmark_id = win_bufname_ns + bufnr
      if vim.bo[bufnr].buflisted then
        if winnr == current_winnr then
          vim.api.nvim_buf_del_extmark(bufnr, win_bufname_ns, win_bufname_extmark_id)
        else
          local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':.')
          vim.api.nvim_buf_set_extmark(bufnr, win_bufname_ns, vim.fn.line('w0', winnr) - 1, -1,
            {
              id = win_bufname_extmark_id,
              virt_text = { { bufname, 'Normal' } },
              virt_text_pos = 'right_align'
            })
        end
      end
    end
  end
})


-- local progress_token_to_title, progress_title_to_order, clients_title_progress, timerid_to_winbuf, spinner_frames = {},
--     {}, {}, {}, { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷", index = 1 }
--
-- local function update_progress_notif(timer_id)
--   spinner_frames.index = spinner_frames.index % #spinner_frames + 1
--
--   local lines = {}
--   for client_id, title_to_prog_info in pairs(clients_title_progress) do
--     local spinner = (next(clients_title_progress[client_id]) and spinner_frames[spinner_frames.index] or '󰄬')
--     local client_name = vim.tbl_get(vim.lsp.get_client_by_id(client_id) or {}, 'name')
--     if not client_name then return end
--     table.insert(lines, spinner .. ' ' .. client_name)
--
--     local t = vim.tbl_values(title_to_prog_info)
--     table.sort(t, function(a, b) return a.order - b.order > 0 end)
--     vim.list_extend(lines, vim.tbl_map(function(v) return v.progress_info end, t))
--   end
--
--   if not vim.tbl_contains(vim.api.nvim_list_wins(), timerid_to_winbuf[timer_id].win) then
--     return vim.fn.timer_stop(timer_id)
--   end
--   if not next(progress_token_to_title) and #lines == 0 then
--     return vim.api.nvim_win_close(timerid_to_winbuf[timer_id].win, false)
--   end
--
--   vim.api.nvim_win_set_height(timerid_to_winbuf[timer_id].win, #lines)
--   vim.api.nvim_buf_set_lines(timerid_to_winbuf[timer_id].buf, 0, -1, false, lines)
-- end
--
-- local _progress_handler = vim.lsp.handlers['$/progress']
-- vim.lsp.handlers['$/progress'] = function(_, result, ctx)
--   _progress_handler(_, result, ctx)
--   local token, val, client_id = result.token, result.value, ctx.client_id
--   local title                 = val.title or vim.tbl_get(progress_token_to_title, client_id, token)
--   local message_maybe_prev    = val.message or vim.tbl_get(clients_title_progress, client_id, title, 'message') or ''
--   local percentage            = val.kind == 'end' and 'Complete' or val.percentage and val.percentage .. '%' or ''
--
--   if val.kind == "begin" then
--     progress_token_to_title[client_id] = vim.tbl_deep_extend('error', progress_token_to_title[client_id] or {},
--       { [token] = title })
--     progress_title_to_order[client_id] = vim.tbl_deep_extend('keep', progress_title_to_order[client_id] or {},
--       { [title] = #vim.tbl_keys(progress_title_to_order[client_id] or {}) + 1 })
--
--     if not next(clients_title_progress) then
--       local timer_id = vim.fn.timer_start(100, update_progress_notif, { ['repeat'] = -1 })
--       local buf = vim.api.nvim_create_buf(false, true)
--       timerid_to_winbuf[timer_id] = {
--         buf = buf,
--         win = vim.api.nvim_open_win(buf, false,
--           {
--             relative = 'win',
--             anchor = 'NE',
--             width = 45,
--             height = 1,
--             row = 0,
--             col = vim.fn.winwidth(0),
--             style = 'minimal',
--             focusable = false
--           })
--       }
--     end
--   elseif val.kind == "end" then
--     progress_token_to_title[client_id][token] = nil
--     if not next(progress_token_to_title[client_id]) then progress_token_to_title[client_id] = nil end
--
--     vim.defer_fn(function()
--       (clients_title_progress[client_id] or {})[title] = nil
--       if not next(clients_title_progress[client_id] or {}) then clients_title_progress[client_id] = nil end
--     end, 1000)
--   end
--
--   clients_title_progress[client_id] = vim.tbl_deep_extend('force', clients_title_progress[client_id] or {},
--     {
--       [title] = {
--         progress_info = ('%s %s %s'):format(title, message_maybe_prev, percentage),
--         message = message_maybe_prev,
--         order = progress_title_to_order[client_id][title]
--       }
--     })
-- end
