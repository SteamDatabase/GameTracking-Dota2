modifier_penguin_passive = class({})
----------------------------------------------------------------------------------

function modifier_penguin_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_penguin_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_penguin_passive:OnCreated( kv )
	if IsServer() then

		self.bInTransit = false
		self.bRescued = false
		self.hPlayerEnt = false

		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_phased", { duration = -1 } )
	end
end

----------------------------------------------------------------------------------

function modifier_penguin_passive:CheckState()
	local state =
	{

	}
	if IsServer() then
		state[MODIFIER_STATE_NO_HEALTH_BAR] = ( self.bRescued or not self.bInTransit )
		state[MODIFIER_STATE_INVULNERABLE] = ( self.bRescued or not self.bInTransit )
	end
	return state
end


-----------------------------------------------------------------------

function modifier_penguin_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_penguin_passive:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		if self.bInTransit == true or self.bRescued == true then
			return
		end

		self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_penguin_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
			if params.attacker ~= nil then
				local gameEvent = {}
				gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
				gameEvent["locstring_value"] = params.attacker:GetUnitName()
				gameEvent["message"] = "#Dungeon_PenguinKilled"
				FireGameEvent( "dota_combat_event_message", gameEvent )
			end
			
			if self.hFollowEnt ~= nil then
				self.hFollowEnt.hFollower = nil
				self:GetParent().hFollower = nil
			end
		end
	end
	return 0 
end

-----------------------------------------------------------------------

function modifier_penguin_passive:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Dungeon ~= nil then
					self.hPlayerEnt:Interrupt()
					GameRules.Dungeon:OnDialogBegin( self.hPlayerEnt, self:GetParent() )

					local hToFollow = self.hPlayerEnt
					local nAttempts = 0
					while hToFollow.hFollower ~= nil and nAttempts < 10 do
						hToFollow = hToFollow.hFollower
						nAttempts = nAttempts + 1
					end

					if hToFollow ~= nil then
						self.bInTransit = true
						self.hPlayerEnt = nil
						self.hFollowEnt = hToFollow
						self:GetParent():MoveToNPC( hToFollow )
						self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )
						self.hFollowEnt.hFollower = self:GetParent()
					end
				end
			end
		else
			local hElonTusk = Entities:FindByName( nil, "ice_lake_quest_giver" )
			if hElonTusk ~= nil then
				local flDist = ( hElonTusk:GetOrigin() - self:GetParent():GetOrigin() ):Length2D()
				if flDist < 450.0 then
					self.bInTransit = false
					self.bRescued = true
					self:GetParent():Interrupt()
					local hPenguinRest = Entities:FindByName( nil, "ice_lake_penguin_rest" )
					if hPenguinRest ~= nil then
						if GameRules.Dungeon ~= nil then
							local hCurrentBuff = self
							local hRescueHero = nil
							local nAttempts = 0
							while hCurrentBuff ~= nil and nAttempts < 10 do
								if hCurrentBuff.hFollowEnt ~= nil and hCurrentBuff.hFollowEnt:IsRealHero() then
									hRescueHero = hCurrentBuff.hFollowEnt
								end
								hCurrentBuff = hCurrentBuff.hFollowEnt:FindModifierByName( "modifier_penguin_passive" )
								nAttempts = nAttempts + 1
							end
							if hRescueHero ~= nil then
								self:GetParent().nCurrentLine = self:GetParent().nCurrentLine + 1
								GameRules.Dungeon:OnDialogBegin( hRescueHero, self:GetParent() )
							end
						end

						local newItem = CreateItem( "item_bag_of_gold", nil, nil )
						newItem:SetPurchaseTime( 0 )
						newItem:SetCurrentCharges( 100 )
						local drop = CreateItemOnPositionSync( self:GetParent():GetAbsOrigin(), newItem )
						local dropTarget = self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
						newItem:LaunchLoot( true, 150, 0.75, dropTarget )

						self:GetParent():StartGesture( ACT_DOTA_SLIDE )

						if self:GetParent().hFollower ~= nil then
							self.hFollowEnt.hFollower = self:GetParent().hFollower
							self:GetParent().hFollower = nil
							local hBuff = self.hFollowEnt.hFollower:FindModifierByName( "modifier_penguin_passive" )
							if hBuff ~= nil then
								hBuff.hFollowEnt = self.hFollowEnt
								self.hFollowEnt.hFollower:MoveToNPC( self.hFollowEnt )
								self.hFollowEnt = nil
							end
						else
							self.hFollowEnt.hFollower = nil
						end

						self:GetParent():MoveToPosition( hPenguinRest:GetOrigin() + RandomVector( 75 ) )
					end
					self:StartIntervalThink( -1 )
				end
			end

			if self.bInTransit == true then
				if self.hFollowEnt == nil or self.hFollowEnt:IsNull() or self.hFollowEnt:IsAlive() == false then
					self.bInTransit = false
					self.hFollowEnt = nil
					self:StartIntervalThink( -1 )
				end
			end
		end
	end
end

