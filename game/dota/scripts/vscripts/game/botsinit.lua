
local BotsInit = {}

-- Created so we can return a module for generic bot implementations so that it punches through bot calls to our API.
function BotsInit.CreateGeneric()
	local M = {}
	local globaltbl = _G
	local newenv = setmetatable({}, {
		__index = function (t, k)
			local v = M[k]
			if v == nil then return globaltbl[k] end
			return v
		end,
		__newindex = M,
	})
	setfenv(2, newenv)
	return M
end

return BotsInit