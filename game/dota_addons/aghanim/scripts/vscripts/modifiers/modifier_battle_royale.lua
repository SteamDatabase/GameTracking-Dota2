-- This is the modifier that punishes players for not being in the active room
LinkLuaModifier( "modifier_battle_royale_damage", "modifiers/modifier_battle_royale_damage", LUA_MODIFIER_MOTION_NONE )

modifier_battle_royale = class({})

--------------------------------------------------------------------------------

function modifier_battle_royale:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_battle_royale:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_battle_royale:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_battle_royale:OnCreated( kv )
	if IsServer() then
		self.nDeepestDepth = 0
		self.hDeepestRoom = nil
		self.vLastValidPos = self:GetParent():GetAbsOrigin()
		self.flLastTimeInCurrentRoom = GameRules:GetGameTime()
		self:StartIntervalThink( 0.01 )
	end
end

--------------------------------------------------------------------------------

function modifier_battle_royale:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_battle_royale:OnIntervalThink()

	local bIsRidingMorty = self:GetParent():FindModifierByName( "modifier_snapfire_gobble_up_creep" ) ~= nil
	if bIsRidingMorty == true then
		return
	end

	-- Determine whether we have a valid position and valid room

	local bValidRoom = false
	local bValidFlyingPos = false
	local bValidPosition = IsUnitInValidPosition( self:GetParent() )

	local nDepth = 0
	local vCurrentPos = self:GetParent():GetAbsOrigin()
	local vClampedValidFlyingPos = self.vLastValidPos 

	local hCurrentRoom = GameRules.Aghanim:GetCurrentRoom()
	if hCurrentRoom then
		
		if not hCurrentRoom:IsInRoomBounds( vCurrentPos ) then
			--print( "POINT IS NOT IN ROOM BOUNDS!!" )
			--print( "CurrentRoom: " .. hCurrentRoom:GetName() )
			--print( "Room Origin: ( ".. hCurrentRoom:GetOrigin().x .. ", " .. hCurrentRoom:GetOrigin().y .. ", " .. hCurrentRoom:GetOrigin().z .. ")" )
			--print( "vCurrentPos: ( ".. vCurrentPos.x .. ", " .. vCurrentPos.y .. ", " .. vCurrentPos.z .. ")" )
			--print( "Room Mins: ( ".. hCurrentRoom.vMins.x .. ", " .. hCurrentRoom.vMins.y .. ", " .. hCurrentRoom.vMins.z .. ")" )
			--print( "Room Maxs: ( ".. hCurrentRoom.vMaxs.x .. ", " .. hCurrentRoom.vMaxs.y .. ", " .. hCurrentRoom.vMaxs.z .. ")" )
		end
	end 

	local hRoom = GameRules.Aghanim:FindRoomForPoint( vCurrentPos )
	if hRoom ~= nil then
		--print( "found room" )
		nDepth = hRoom:GetDepth()
		--print( "room depth: " .. nDepth )
		-- Update the deepest we've ever been in the dungeon
		-- But don't allow people to skip ahead to unselected rooms

		if nDepth > self.nDeepestDepth then
			if ( hCurrentRoom == hRoom ) or
				( hCurrentRoom:GetExitRoomSelected() == hRoom:GetName() ) or 
				( hCurrentRoom.hEventRoom and hCurrentRoom.hEventRoom:GetName() == hRoom:GetName() ) or
				( GameRules.Aghanim:GetTestEncounterDebugRoom() == hRoom ) then
				self.nDeepestDepth = nDepth
				self.hDeepestRoom = hRoom
				--print( "setting deepest depth and deepest room" )

				-- Ok, they advanced rooms. We can stop punishment.
				if self:GetParent():FindModifierByName( "modifier_battle_royale_damage" ) ~= nil then
					self:GetParent():RemoveModifierByName( "modifier_battle_royale_damage" )
				end
			end
		end

		if hCurrentRoom == hRoom then
			self.flLastTimeInCurrentRoom = GameRules:GetGameTime()
		end

		bValidRoom = ( nDepth == self.nDeepestDepth )

		vClampedValidFlyingPos = vCurrentPos
		if bValidPosition == false or bValidRoom == false then
			local flBoundary = 192.0
			if bValidPosition == true then
				flBoundary = 4.0
			end

			local hClampRoom = self.hDeepestRoom
			if hCurrentRoom ~= nil then
				local bIsHub = hCurrentRoom:GetName() == "hub" and hCurrentRoom:GetAct() > self.hDeepestRoom:GetAct()
				local bIsEventRoom = hCurrentRoom == self.hDeepestRoom.hEventRoom
				if bIsHub or bIsEventRoom then
					hClampRoom = hCurrentRoom
				end
			end
			vClampedValidFlyingPos = hClampRoom:ClampPointToRoomBounds( vCurrentPos, flBoundary )
		end
	end

	if ( GameRules:GetGameTime() - self.flLastTimeInCurrentRoom ) > 12.0 and self:GetParent():IsSummoned() == false and GameRules.Aghanim:GetAnnouncer() ~= nil then
		GameRules.Aghanim:GetAnnouncer():OnLaggingHero( self:GetParent():GetUnitName(), GameRules.Aghanim:GetCurrentRoom():GetDepth() )
	end

	if bValidRoom == true and bValidPosition == true then
		self.vLastValidPos = vCurrentPos
	end

	local bIsMotionControlled = self:GetParent():IsCurrentlyHorizontalMotionControlled() == true or self:GetParent():IsCurrentlyVerticalMotionControlled() == true
	if self:GetParent():HasFlyMovementCapability() == false and bIsMotionControlled == false then
		if bValidRoom == false or bValidPosition == false then
			if bValidRoom == false then 
			--	print( "Room is not valid!" )
			end

			if bValidPosition == false then
			--	print( "Position is not valid!" )
			end
			--print( "BR Modifier Teleporting to " .. tostring( self.vLastValidPos ) )
			FindClearSpaceForUnit( self:GetParent(), self.vLastValidPos, true )
		end
	else
		if bValidRoom == false or vCurrentPos ~= vClampedValidFlyingPos then
			--print( "BR Flying Teleporting to " .. tostring( vClampedValidFlyingPos ) )
			FindClearSpaceForUnit( self:GetParent(), vClampedValidFlyingPos, true )
		end
	end

end

-----------------------------------------------------------------------

function modifier_battle_royale:OnTakeDamage( params )

	if IsServer() == false then
		return
	end

	if params.attacker ~= self:GetParent() then
		return
	end

	local hUnit = params.unit
	if hUnit == nil or hUnit.Encounter == nil then
		return
	end

	local nUnitDepth = hUnit.Encounter:GetRoom():GetDepth()
	if nUnitDepth <= self.nDeepestDepth then
		return
	end

	-- They are attacking a unit at the wrong depth. PUNISH THEM
	if self:GetParent():FindModifierByName( "modifier_battle_royale_damage" ) == nil then
 		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_battle_royale_damage", {} )
 		if self:GetParent():GetPlayerOwner() ~= nil then
			CustomGameEventManager:Send_ServerToPlayer( self:GetParent():GetPlayerOwner(), "battle_royale_damage_starting", {} )
			GameRules.Aghanim:GetAnnouncer():OnCowardlyHero( self:GetParent():GetUnitName(), self:GetCaster():GetUnitName() )
		end
	end
end