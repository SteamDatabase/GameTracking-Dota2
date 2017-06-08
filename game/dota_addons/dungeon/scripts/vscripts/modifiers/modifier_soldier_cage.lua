modifier_soldier_cage = class({})

--------------------------------------------------------------------------------

function modifier_soldier_cage:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_soldier_cage:OnCreated( kv )
	if IsServer() then
		self.bRescued = false
		print( "Start with ACT_DOTA_IDLE gesture" )
		self:GetParent():StartGesture( ACT_DOTA_IDLE )

		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_soldier_cage:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_soldier_cage:OnIntervalThink()
	if IsServer() then
		if self.bRescued == true then
			return
		end
		if not self.bRemovedUnwantedModifiers then
			self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )
			self:GetParent():RemoveModifierByName( "modifier_stack_count_animation_controller" )
			self.bRemovedUnwantedModifiers = true
		end
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Dungeon ~= nil then
					self.hPlayerEnt:Interrupt()
					
					self:StartIntervalThink( -1 )
					self.hPlayerEnt = nil

					local soldiers = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
					for _,soldier in pairs( soldiers ) do
						if soldier ~= nil then
							 local buff = soldier:FindModifierByName( "modifier_imprisoned_soldier" )
							 if buff ~= nil then
							 	--print( "Saving soldier" )
							 	buff:OnIntervalThink()
							 end
						end
					end

					self.bRescued = true
					self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
					self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_soldier_cage_open", {} )
					self:StartIntervalThink( -1 )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_soldier_cage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_soldier_cage:OnOrder( params )
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

		if self.bRescued == true then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end
