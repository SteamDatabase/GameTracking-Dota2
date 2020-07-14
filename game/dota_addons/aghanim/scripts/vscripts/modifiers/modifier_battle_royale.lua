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
	local hRoom = GameRules.Aghanim:FindRoomForPoint( vCurrentPos )
	if hRoom ~= nil then

		nDepth = hRoom:GetDepth()

		-- Update the deepest we've ever been in the dungeon
		-- But don't allow people to skip ahead to unselected rooms
		local hCurrentRoom = GameRules.Aghanim:GetCurrentRoom()
		if nDepth > self.nDeepestDepth then
			if ( hCurrentRoom == hRoom ) or
				( hCurrentRoom:GetExitRoomSelected() == hRoom:GetName() )  or
				( GameRules.Aghanim:GetTestEncounterDebugRoom() == hRoom ) then
				self.nDeepestDepth = nDepth
				self.hDeepestRoom = hRoom

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
			vClampedValidFlyingPos = self.hDeepestRoom:ClampPointToRoomBounds( vCurrentPos, flBoundary )
		end
	end

	if ( GameRules:GetGameTime() - self.flLastTimeInCurrentRoom ) > 8.0 and self:GetParent():IsSummoned() == false then
		GameRules.Aghanim:GetAnnouncer():OnLaggingHero( self:GetParent():GetUnitName(), GameRules.Aghanim:GetCurrentRoom():GetDepth() )
	end

	if bValidRoom == true and bValidPosition == true then
		self.vLastValidPos = vCurrentPos
	end

	local bIsMotionControlled = self:GetParent():IsCurrentlyHorizontalMotionControlled() == true or self:GetParent():IsCurrentlyVerticalMotionControlled() == true
	if self:GetParent():HasFlyMovementCapability() == false and bIsMotionControlled == false then
		if bValidRoom == false or bValidPosition == false then
			--print( "Teleporting to " .. tostring( self.vLastValidPos ) )
			FindClearSpaceForUnit( self:GetParent(), self.vLastValidPos, true )
		end
	else
		if bValidRoom == false or vCurrentPos ~= vClampedValidFlyingPos then
			--print( "Flying Teleporting to " .. tostring( vClampedValidFlyingPos ) )
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