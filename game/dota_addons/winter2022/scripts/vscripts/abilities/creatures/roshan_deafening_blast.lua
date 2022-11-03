require( "winter2022_utility_functions" )

if roshan_deafening_blast == nil then
	roshan_deafening_blast = class({})
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:Precache( context )
	PrecacheResource( "particle", "particles/hw_fx/roshan_linear_blast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:OnSpellStart()
    if not IsServer() then return end

	self.hHitEntities = {}

    local radius_start = self:GetSpecialValueFor( "radius_start" )
    local radius_end = self:GetSpecialValueFor( "radius_end" )
    local travel_distance = self:GetSpecialValueFor( "travel_distance" )
    local travel_speed = self:GetSpecialValueFor( "travel_speed" )
	local vDir = self:GetCaster():GetForwardVector()

	self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
	self.disarm_duration = self:GetSpecialValueFor( "disarm_duration" )
	self.damage = self:GetSpecialValueFor( "damage" )
	self.damage_mult_per_min = self:GetSpecialValueFor( "damage_mult_per_min" )
	self.num_projectiles = self:GetSpecialValueFor( "num_projectiles" )

	local info = {
		EffectName = "particles/hw_fx/roshan_linear_blast.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		fStartRadius = radius_start,
		fEndRadius = radius_end,
		fDistance = travel_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	local startAngle = VectorAngles( vDir )
	for i=1,self.num_projectiles do
		local Angle = QAngle( 0, startAngle.y + i * 360 / self.num_projectiles, 0 )
		local vProjectileDirection = AnglesToVector( Angle )
		info.vVelocity = vProjectileDirection * travel_speed
		ProjectileManager:CreateLinearProjectile( info )
	end

	EmitSoundOn( "RoshanDT.DeafeningBlast", self:GetCaster() )
end

--------------------------------------------------------------------------------

function roshan_deafening_blast:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsNull() == false and hTarget:IsAlive() == true and hTarget:IsMagicImmune() == false then
			if self.hHitEntities[ hTarget ] == nil then
				table.insert( self.hHitEntities, hTarget )

				-- don't hit neutrals but allow pushback on greevils
				local nTargetTeam = hTarget:GetTeamNumber()
				local bIsGreevil = IsGreevil( hTarget )
				if nTargetTeam == DOTA_TEAM_NEUTRALS and bIsGreevil == false then
					return false
				end

				-- apply damage
				if bIsGreevil == false then
					local fDamage = self.damage * ( 1.0 + ( (GameRules:GetGameTime() / 60) * self.damage_mult_per_min ) )
					local damage = 
					{
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = fDamage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self
					}
					ApplyDamage( damage )
				end

				local vToTarget = hTarget:GetAbsOrigin() - vLocation;
				vToTarget = vToTarget:Normalized()

				local kv = {
					duration = self.knockback_duration,
					disarm_duration = self.disarm_duration,
					push_vec_x = vToTarget.x,
					push_vec_y = vToTarget.y,
				}
				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_invoker_deafening_blast_knockback", kv )
			end
		end
	end

	return false
end