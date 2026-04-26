-- ============================================================================
-- Plugin setup
-- ============================================================================
require("full-border"):setup()
require("git"):setup()

-- ============================================================================
-- Status bar customizations. Keep colors minimal; no busy badges.
-- ============================================================================

-- LEFT: "cursor/total" so file count is always visible without scrolling.
Status:children_add(function(self)
	local cur = (self._current.cursor or 0) + 1
	local total = #self._current.files
	return ui.Line {
		ui.Span(string.format(" %d/%d ", cur, total)):fg("#D8DEE9"),
	}
end, 500, Status.LEFT)

-- RIGHT: free disk space. Throttled to 30s; no popen on every cd.
local _disk_free, _disk_ts = "?", 0
local function shell_quote(s)
	return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end
local function refresh_disk(cwd)
	local handle = io.popen("/bin/df -Ph " .. shell_quote(cwd) .. " 2>/dev/null")
	if not handle then return end
	local s = handle:read("*a") or ""
	handle:close()
	local tokens, seen = {}, false
	for line in string.gmatch(s, "[^\r\n]+") do
		if not seen then
			seen = true
		else
			for tok in string.gmatch(line, "%S+") do
				tokens[#tokens + 1] = tok
			end
		end
	end
	_disk_free = tokens[4] or "?"
end
Status:children_add(function(self)
	local cwd_url = cx and cx.active and cx.active.current and cx.active.current.cwd
	local cwd = cwd_url and tostring(cwd_url) or nil
	local now = os.time()
	if cwd and (now - _disk_ts) > 30 then
		_disk_ts = now
		refresh_disk(cwd)
	end
	return ui.Line {
		ui.Span(" " .. _disk_free .. " free "):fg("#D8DEE9"),
	}
end, 500, Status.RIGHT)
