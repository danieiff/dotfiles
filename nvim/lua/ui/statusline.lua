local mode_hl_tbl = {
    ['n'] = 'MiniStatuslineModeNormal',
    ['v'] = 'MiniStatuslineModeVisual',
    ['V'] = 'MiniStatuslineModeVisual',
    [''] = 'MiniStatuslineModeVisual',
    ['i'] = 'MiniStatuslineModeInsert',
    ['R'] = 'MiniStatuslineModeReplace',
    ['c'] = 'MiniStatuslineModeCommand'
}
function _G.statusline()
    local vim_mode_hl = mode_hl_tbl[vim.fn.mode()] or 'MiniStatuslineModeOther'
    local githead_vimmode = vim.g.gitsigns_head and ('%%#%s# %s %%*'):format(vim_mode_hl, vim.g.gitsigns_head)

    local gs_dict = vim.b.gitsigns_status_dict or {}
    local added, changed, removed = gs_dict.added, gs_dict.changed, gs_dict.removed
    local diff_status =
        (added and added > 0 and ('%#GitsignsAdd#+' .. added .. '%*') or '') ..
        (changed and changed > 0 and ('%#GitsignsChange#~' .. changed .. '%*') or '') ..
        (removed and removed > 0 and ('%#GitsignsDelete#-' .. removed .. '%*') or '')

    local diagnostic_status = ''
    for _, level in ipairs(vim.diagnostic.severity) do
        local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
        if count ~= 0 then
            diagnostic_status = diagnostic_status ..
                ('%%#Diagnostic%s#%s%s%%*'):format(level, string.sub(level, 1, 1), count)
        end
    end

    local search = vim.fn.searchcount()

    local file_modified_hl = vim.bo.modified and 'NvimTreeModifiedFileHL' or ''

    return vim.fn.join(vim.tbl_filter(function(item) return item end, {
        -- vim.wo.statusline = vim.fn.join(vim.tbl_filter(function(item) return item end, {
        githead_vimmode,
        diff_status,
        diagnostic_status,
        ((search.total or 0) > 0 and ('%s/%s'):format(search.current, search.total) or ''),
        '%=%<',
        '%{fnamemodify(getcwd(), ":~")}',
        ('%%#%s#%%f%%*'):format(file_modified_hl),
        '%P',
        "%{(&fenc!='utf-8'&&&fenc!='')?&fenc:''}",
    }), ' ')
end

vim.o.statusline = '%!v:lua.statusline()'
