vim.o.sessionoptions = "curdir,folds,help,tabpages,winsize"

local function get_session_path(dir, id)
	dir = dir or assert(vim.uv.cwd(), "should get cwd")
	return vim.fn.stdpath("data")
		.. "/session"
		.. vim.fn.fnamemodify(dir, ":p:h"):gsub("/", "!")
		.. (id and ":" .. id or "")
		.. ".vim"
end

local function select_session()
	require("fzf-lua").fzf_exec("rg --files " .. vim.fn.stdpath("data") .. " -g session*.vim", {
		prompt = "Sessions> ",
		fn_transform = function(line)
			return vim.fn.fnamemodify(
				line:gsub("^" .. vim.fn.stdpath("data") .. "/session", "")
					:gsub("!", "/")
					:gsub(":", " ")
					:gsub("%.vim", ""),
				":~"
			)
		end,
		preview = function(selected)
			local filecontent = vim.fn.system({ "cat", get_session_path(unpack(vim.split(selected[1], " "))) })
			local result = ""
			for bufname in filecontent:gmatch("badd %+%d+ (%S+)") do
				result = bufname .. "\n" .. result
			end
			return result
		end,
		actions = {
			["default"] = {
				desc = "save-and-switch-session",
				fn = function(selected)
					vim.cmd.mksession(vim.v.this_session, { bang = true })
					vim.cmd.source(get_session_path(unpack(vim.split(selected[1], " "))))
				end,
			},
			["ctrl-y"] = {
				desc = "yank-session-path",
				fn = function(selected)
					vim.fn.setreg(vim.v.register, get_session_path(unpack(vim.split(selected[1], " "))))
				end,
			},
			["ctrl-d"] = {
				desc = "delete-session",
				fn = function(selected)
					os.remove(get_session_path(unpack(vim.split(selected[1], " "))))
				end,
				reload = true,
			},
		},
	})
end

AUC("VimEnter", {
	desc = "Enable Session",
	nested = true,
	callback = function()
		local vim_argv = vim.fn.argv()

		local cwd = vim.uv.cwd()
		if cwd == vim.fn.expand("~") or cwd == vim.fn.fnamemodify("/", ":p") then
			return select_session()
		end

		AUC("VimLeave", { command = "silent mksession! " .. get_session_path() })
		pcall(vim.api.nvim_exec2, "silent source " .. get_session_path(), {})

		for _, path in ipairs(type(vim_argv) == "table" and vim_argv or { vim_argv }) do
			vim.cmd.tabedit(path)
		end
	end,
})

K("<leader>s", select_session, { desc = "Select Session" })

K("<leader>S", function()
	local key_left_4 = vim.api.nvim_replace_termcodes("<left>", true, false, true):rep(4)
	vim.api.nvim_feedkeys(":mksession " .. get_session_path() .. key_left_4, "n", true)
end, { desc = "Save Session" })
