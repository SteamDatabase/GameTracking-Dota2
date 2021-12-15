
modifier_eimermole_burrow = class({})

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:GetModifierAura()
	return  "modifier_eimermole_burrow_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:OnCreated( kv )
	self.nMovespeed = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.nMovespeedBonusPct = self:GetAbility():GetSpecialValueFor( "movespeed_bonus_pct" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

	if IsServer() then
		self:GetCaster():StartGesture( ACT_DOTA_VICTORY )

		self.fNodrawTime = GameRules:GetGameTime() + 0.8

		self.fDescentInterval = 0.05
		self.fNextDescentMovement = GameRules:GetGameTime() + self.fDescentInterval
		self.fHeightChangePerInterval = 4
		self.fMaxHeightToDescend = 150

		self.nBurrowFX = -1
		self.vInitialPosition = self:GetParent():GetAbsOrigin()

		self:StartIntervalThink( 0.025 )
	end
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow:OnIntervalThink()
	if IsServer() then
		if self.nBurrowFX ~= -1 then
			ParticleManager:DestroyParticle( self.nBurrowFX, false )
		end

		if self.fNodrawTime ~= -1 and GameRules:GetGameTime() >= self.fNodrawTime then
			self:GetParent():AddEffects( EF_NODRAW )
			self.fNodrawTime = -1
		end

		if self.fNextDescentMovement ~= -1 and GameRules:GetGameTime() >= self.fNextDescentMovement then
			local vPos = self:GetCaster():GetAbsOrigin() 
			vPos.z = vPos.z - self.fHeightChangePerInterval

			self:GetCaster():SetAbsOrigin( vPos )

			local fGroundHeight = GetGroundHeight( vPos, nil )
			if fGroundHeight - vPos.z > self.fMaxHeightToDescend then
				self.fNextDescentMovement = -1
			end
		end

		local vFwd = self.vInitialPosition - self:GetParent():GetAbsOrigin()
		vFwd = vFwd:Normalized()

		local szEffect = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf"
		self.nBurrowFX = ParticleManager:CreateParticle( szEffect, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nBurrowFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nBurrowFX, 0, vFwd )
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:DeclareFunctions()
	local funcs = {
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

--[[
function modifier_eimermole_burrow:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end
]]

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.nMovespeedBonusPct
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow:CheckState()
	local state =
	{
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
		[ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true,
	}

	return state
end

-------------------------------------------------------------------------------

function modifier_eimermole_burrow:OnDestroy()
	if IsServer() then
		--self:GetCaster():FadeGesture( ACT_DOTA_FLAIL )

		self:GetParent():RemoveEffects( EF_NODRAW )
	end
end

--------------------------------------------------------------------------------
