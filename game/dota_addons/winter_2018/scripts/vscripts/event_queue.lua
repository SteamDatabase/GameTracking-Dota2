if CEventQueue == nil then
	CEventQueue = class({})
end

_nEventQueueCounter = 1

--------------------------------------------------------------------
function CEventQueue:constructor()
	self.Events = {}
	GameRules:GetGameModeEntity():SetContextThink( string.format("CEventQueue_%d", _nEventQueueCounter), function() return self:OnThink() end, 0.0 )
	_nEventQueueCounter = _nEventQueueCounter +1
end

--------------------------------------------------------------------

function CEventQueue:AddEvent( flDelay, fnCallback, ...)
	flEventTime = GameRules:GetGameTime() + flDelay
	if self.Events[ flEventTime ] == nil then
		self.Events[ flEventTime ]  = {}
	end
	--printf("adding callback %s %s at %f", fnCallback, table.ToStringShallow({...}), flEventTime)
	table.insert( self.Events[ flEventTime ], {fnCallback, {...} } )
	self:OnThink()
end

function CEventQueue:OnThink()

	local flCurrentTime = GameRules:GetGameTime()
	local flNextThink = 0.1

	--printf("CEventQueue:OnThink %f %f %d", flCurrentTime, flNextThink, #self.Events)

	local Times = {}

	for t in pairs(self.Events) do 
		table.insert(Times, t) 
	end

	table.sort(Times)

	for _,flEventTime in ipairs(Times) do 
		
		if flEventTime < flCurrentTime then
			local tCallbacks = self.Events[flEventTime]
			self.Events[flEventTime] = nil
			for __,fnCallbackAndArgs in pairs(tCallbacks) do
				--printf("Executing event %s with args %s %f, current time %f", fnCallbackAndArgs[1], table.ToStringShallow(fnCallbackAndArgs[2]), flEventTime, flCurrentTime)
				if fnCallbackAndArgs[2] == nil then
					fnCallbackAndArgs[1]()
				else
					fnCallbackAndArgs[1](unpack(fnCallbackAndArgs[2]))
				end
			end
		else
			flNextThink = flEventTime - flCurrentTime
			break
		end
	end

	return flNextThink

end