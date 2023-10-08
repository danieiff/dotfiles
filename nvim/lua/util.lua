local M = {}

M.ensure_pack_installed = function(deps)
  local jobs, rt = {}
  for _, dep in ipairs(deps) do
    local pack = vim.fn.fnamemodify(dep.url, ':t')
    if not vim.tbl_contains(vim.g.packages, pack) then
      table.insert(vim.g.packages, pack)
      local job = vim.fn.jobstart('git clone --depth 1 ' .. dep.url, {
        cwd = vim.g.packdir,
        on_exit = function(_, code)
          if code == 0 then
            vim.print('Downloaded: ' .. dep.url)
            if dep.callback then rt = dep.callback() end
          else
            vim.print('Download Failed: ' .. dep.url)
          end
        end
      })
      table.insert(jobs, job)
    else
      if dep.callback then rt = dep.callback() end
    end
  end
  return jobs, rt
end

M.ensure_npm_deps = function(deps)
  local jobs = vim.tbl_map(function(d)
    if not vim.g.npm_list:find(d:gsub('-', '%%-') .. '\n') then return vim.fn.jobstart('npm i -g ' .. d) end
  end, deps)
  return jobs
end

M.safe_require = function(package_name, cb)
  local is_exist, package = pcall(require, package_name)
  if is_exist then
    if cb then cb(package) end
  else
    vim.notify('Failed to require a package: ' .. package_name, vim.log.levels.WARN)
  end
end

return M
