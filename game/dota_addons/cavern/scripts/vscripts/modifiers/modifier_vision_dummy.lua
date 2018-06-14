
modifier_vision_dummy = class({})

--------------------------------------------------------------------------------

function modifier_vision_dummy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_vision_dummy:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_vision_dummy:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_vision_dummy:OnIntervalThink()
	if IsServer() then

		if self:GetParent() == nil or self:GetParent():IsNull() then
			return nil
		end

		-- Receiving our revealed hero in OnIntervalThink instead of OnCreated, because it's set in modifier_bounty_hunter_statue_aura_effect after this modifier is made
		if not self.bInitialized then
			self.hRevealedHero = self:GetParent().hRevealedHero
			if self.hRevealedHero then
				--printf( "modifier_vision_dummy -- \"%s\" is revealing \"%s\"", self:GetParent():GetUnitName(), self.hRevealedHero:GetUnitName() )
			else
				printf( "ERROR: modifier_vision_dummy -- self.hRevealedHero is nil" )
				return
			end
			self.bInitialized = true
		end

		self:GetParent():SetAbsOrigin( self.hRevealedHero:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------------------

function modifier_vision_dummy:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and not self:GetParent():IsNull() then
			UTIL_Remove( self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_vision_dummy:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_DISARMED ] = true

	end
	
	return state
end

--------------------------------------------------------------------------------
