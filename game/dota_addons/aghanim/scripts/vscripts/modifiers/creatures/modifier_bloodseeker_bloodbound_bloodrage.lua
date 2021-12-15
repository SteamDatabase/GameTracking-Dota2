
modifier_bloodseeker_bloodbound_bloodrage = class({})

-----------------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:IsPurgable()
	return false
end

----------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:OnCreated( kv )
	self:OnRefresh( kv )
	if IsServer() then
		self:StartIntervalThink( 1.0 )
	end
end

----------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_aspd_per_hp_pct = self:GetAbility():GetSpecialValueFor( "bonus_aspd_per_hp_pct" )
	self.max_aspd = self:GetAbility():GetSpecialValueFor( "max_aspd" )
	self.bonus_mspd_per_hp_pct = self:GetAbility():GetSpecialValueFor( "bonus_mspd_per_hp_pct" )
	self.max_mspd = self:GetAbility():GetSpecialValueFor( "max_mspd" )
	self.heal_range = self:GetAbility():GetSpecialValueFor( "heal_range" )
	self.heal_pct = self:GetAbility():GetSpecialValueFor( "heal_pct" )
	self.heal_pct_hero = self:GetAbility():GetSpecialValueFor( "heal_pct_hero" )
end

-----------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:OnIntervalThink()
	if IsServer() == false then
		return
	end
	
	--					PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
	self:GetParent():Purge( false,		  true,			 false,		true,		 false )
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		--MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:GetModifierAttackSpeed_Limit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:GetModifierAttackSpeedBonus_Constant( params )
	if self:GetParent() == nil or self:GetParent():IsNull() == true then
		return 0
	end

	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return math.min( self.max_aspd, math.floor( self.bonus_aspd_per_hp_pct * ( 1.0 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth() ) * 100 ) )
end

-----------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:GetModifierMoveSpeedBonus_Percentage( params )
	if self:GetParent() == nil or self:GetParent():IsNull() == true then
		return 0
	end

	if self:GetParent():PassivesDisabled() then
		return 0
	end

	return math.min( self.max_mspd, math.floor( self.bonus_mspd_per_hp_pct * ( 1.0 - self:GetParent():GetHealth() / self:GetParent():GetMaxHealth() ) * 100 ) )
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_bloodbound_bloodrage:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.unit ~= nil and params.unit ~= self:GetParent()
				--and params.unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS
				then
			local flDist = ( params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Length2D()
			if flDist > self.heal_range then
				return 1
			end

			EmitSoundOn( "Hero_Bloodseeker.bloodbath", self:GetParent() )

			local nHealPct = self.heal_pct
			if params.unit:IsRealHero() and params.unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				nHealPct = self.heal_pct_hero
			end
			self:GetParent():Heal( math.floor( self:GetParent():GetMaxHealth() * self.heal_pct / 100 ), self:GetAbility() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end
