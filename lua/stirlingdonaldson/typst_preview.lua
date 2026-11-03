-- <leader>t: live typst preview, laid out side by side.
--
-- Pressing it in a typst buffer:
--   1. zooms the current tmux pane (if nvim is running inside tmux),
--   2. moves the terminal window to the left half of the MacBook screen,
--   3. starts typst-preview, which opens the preview in a new Safari window
--      on the right half (see open_cmd below).
-- Pressing it again stops the preview, closes that browser window, unzooms the
-- pane and puts the terminal window back where it was.
--
-- The window moving is done by scripts/typst_layout.js (macOS only).

local M = {}

local layout_script = vim.fn.stdpath("config") .. "/scripts/typst_layout.js"
local is_mac = vim.fn.has("mac") == 1

-- Per-preview state, keyed by the absolute path of the main typst file.
local state = {}

local function run_layout(args, on_done)
	local cmd = { "osascript", "-l", "JavaScript", layout_script }
	vim.list_extend(cmd, args)
	vim.system(cmd, { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify("typst layout: " .. vim.trim(res.stderr or ""), vim.log.levels.WARN)
			end
			if on_done then
				on_done(res)
			end
		end)
	end)
end

local function tmux(args)
	local out = vim.fn.system(vim.list_extend({ "tmux" }, args))
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return vim.trim(out)
end

local function pane_zoomed(pane)
	return tmux({ "display-message", "-p", "-t", pane, "#{window_zoomed_flag}" }) == "1"
end

-- Passed to typst-preview's `open_cmd`: it substitutes the preview URL for %s
-- and runs the result through the shell.
function M.open_cmd()
	if not is_mac then
		return nil
	end
	local script = vim.fn.shellescape(layout_script):gsub("%%", "%%%%")
	return "osascript -l JavaScript " .. script .. " right %s"
end

local function start(main, key)
	local s = {}
	state[key] = s

	local pane = vim.env.TMUX and vim.env.TMUX_PANE
	if pane and pane ~= "" and not pane_zoomed(pane) then
		if tmux({ "resize-pane", "-Z", "-t", pane }) then
			s.pane = pane -- remember we zoomed it, so we only unzoom our own zoom
		end
	end

	if is_mac then
		run_layout({ "left" }, function(res)
			if res.code == 0 then
				s.bounds = vim.split(vim.trim(res.stdout or ""), " ", { trimempty = true })
			end
		end)
	end

	vim.cmd("TypstPreview")
end

local function stop(main, key, servers_for_file)
	local links = {}
	for _, ser in pairs(servers_for_file) do
		if ser.link then
			table.insert(links, "http://" .. ser.link)
		end
	end

	vim.cmd("TypstPreviewStop")

	local s = state[key] or {}
	state[key] = nil

	if s.pane and pane_zoomed(s.pane) then
		tmux({ "resize-pane", "-Z", "-t", s.pane })
	end

	if is_mac then
		for _, link in ipairs(links) do
			run_layout({ "close", link })
		end
		if s.bounds and #s.bounds == 4 then
			run_layout(vim.list_extend({ "restore" }, s.bounds))
		end
	end
end

function M.toggle()
	local path = vim.api.nvim_buf_get_name(0)
	if vim.bo.filetype ~= "typst" and not path:match("%.typ$") then
		vim.notify("Not a typst file", vim.log.levels.WARN)
		return
	end
	if path == "" then
		vim.notify("Save the file before previewing it", vim.log.levels.WARN)
		return
	end

	local main = require("typst-preview.config").opts.get_main_file(path)
	local key = vim.fn.fnamemodify(main, ":p")
	local running = require("typst-preview.servers").get(main)

	if running then
		stop(main, key, running)
	else
		start(main, key)
	end
end

return M
