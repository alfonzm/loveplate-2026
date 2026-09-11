local Log = {}

-- convert table to string recursively
Log.stringify = function(t)
	string = ""

	for k, v in pairs(t) do
		if type(v) == 'table' then
			string = string .. k .. " = " .. Log.stringify(v)
		else
			v = type(v) ~= 'number' and tostring(v) or v
			string = string .. k .. " = " .. v
		end

		string = string .. ", "
	end

	-- remove trailing ", "
	string = string.sub(string,1,#string-2)

	return "{" .. string .. "}"
end

local function formatArg(v)
	if v == nil then
		return "nil"
	end
	if type(v) == "table" then
		return Log.stringify(v)
	end
	return tostring(v)
end

-- print tables inline; accepts any number of args (like print)
Log.print = function(...)
	local info = debug.getinfo(2, "Sl")
	local lineinfo = info.short_src .. ":" .. info.currentline .. ": "
	io.write(lineinfo)
	local n = select("#", ...)
	for i = 1, n do
		if i > 1 then
			io.write("\t")
		end
		io.write(formatArg(select(i, ...)))
	end
	io.write("\n")
end

Log.p = Log.print

return Log
