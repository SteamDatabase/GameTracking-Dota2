
modifier_room_decider = class({})

------------------------------------------------------------------------------

function modifier_room_decider:StatusEffectPriority()
	return 14
end

------------------------------------------------------------------------------

function modifier_room_decider:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_room_decider:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_room_decider:IsPermanent()
	return true
end

---------------------------------------------------------

function modifier_room_decider:RemoveOnDeath()
	return false
end 

--------------------------------------------------------------------------------

function modifier_room_decider:OnCreated()
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_room_decider:GetRoomFromString( szRoomString )

	local Room = nil

	if string.ends(szRoomString, "_ante") then
		local k,l = string.find( szRoomString, "_ante" )
		local szRoomString = string.sub( szRoomString, 1, k-1 )
		local m, n = string.find( szRoomString, "room_" )
		local szAntechamberRoomNumber = string.sub( szRoomString, n+1, string.len( szRoomString ) ) 
		Room = GameRules.Cavern.Rooms[tonumber(szAntechamberRoomNumber)]
	else 
		--if string.starts("room_") then
		local i, j = string.find( szRoomString, "room_" )
		local szRoomNumber = string.sub( szRoomString, j+1, string.len( szRoomString ) )
		Room = GameRules.Cavern.Rooms[tonumber(szRoomNumber)]
	end
	
	return Room

end

--------------------------------------------------------------------------------

function modifier_room_decider:OnIntervalThink()
	if IsServer() then
		local Triggers = Entities:FindAllByClassnameWithin( "trigger_dota", self:GetParent():GetAbsOrigin(), 2000 )
		local flClosestRoomDist = 1e10
		local hClosestRoom = nil
		for _,Trigger in pairs(Triggers) do
			local szTriggerName = Trigger:GetName()
			if string.starts( szTriggerName, "room_") then
				local flRoomDist = (self:GetParent():GetAbsOrigin() - Trigger:GetAbsOrigin()):Length2D()
				if flRoomDist < flClosestRoomDist then
					flClosestRoomDist = flRoomDist
					hClosestRoom = Trigger
				end
			end
		end

		if hClosestRoom ~= nil then
			local szRoomName = hClosestRoom:GetName()
			local hCavernRoom = self:GetRoomFromString( szRoomName )
			if self.szLastRoom ~= szRoomName then 
				--printf("entered room = %s, %s, %s", szRoomName, hCavernRoom, hCavernRoom:GetRoomID() );	
				GameRules.Cavern:OnNPCEnteredRoom( hCavernRoom, self:GetParent() )
				self.szLastRoom = szRoomName
			end
		end
		
	end
end

--------------------------------------------------------------------------------
