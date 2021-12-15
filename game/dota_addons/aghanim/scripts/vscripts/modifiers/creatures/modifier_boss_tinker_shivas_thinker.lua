
require( "utility_functions" )

modifier_boss_tinker_shivas_thinker = class({})

---------------------------------------------------------------------------

function modifier_boss_tinker_shivas_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas_thinker:OnCreated( kv )
	self.blast_damage = self:GetAbility():GetSpecialValueFor( "blast_damage" )
	self.blast_radius = self:GetAbility():GetSpecialValueFor( "blast_radius" )
	self.blast_speed = self:GetAbility():GetSpecialValueFor( "blast_speed" )
	self.blast_debuff_duration = self:GetAbility():GetSpecialValueFor( "blast_debuff_duration" )

	self.vecEnemiesHit = {}

	if IsServer() then
		self:StartIntervalThink( 0.0 )

		self.fCurRadius = 0.0
		self.fLastThink = GameRules:GetGameTime()

		local nFX = ParticleManager:CreateParticle( "particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( nFX, 1, Vector( self.blast_radius, self.blast_debuff_duration, self.blast_speed ) )
		ParticleManager:ReleaseParticleIndex( nFX )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas_thinker:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	self.fCurRadius = self.fCurRadius + ( self.blast_speed * ( GameRules:GetGameTime() - self.fLastThink ) )
	self.fLastThink = GameRules:GetGameTime()

	local bKillThinker = false

	if self.fCurRadius > self.blast_radius then
		bKillThinker = true
		self.fCurRadius = self.blast_radius
	end

	if self:GetCaster() == nil or self:GetCaster():IsNull() then
		self:Destroy()
		return -1
	end

	self:GetParent():SetAbsOrigin( self:GetCaster():GetAbsOrigin() )

	local enemies = Util_FindEnemiesAroundUnit( self:GetParent(), self.fCurRadius )

	for _, enemy in pairs( enemies ) do
		if enemy and enemy:IsAlive() and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
			if TableContainsValue( self.vecEnemiesHit, enemy ) == false then
				local damage = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.blast_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
			
				ApplyDamage( damage )

				local kv_shivas =
				{
					duration = self.blast_debuff_duration,
				}

				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_tinker_shivas", kv_shivas )

				local nImpactFX = ParticleManager:CreateParticle( "particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
				ParticleManager:SetParticleControlEnt( nImpactFX, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nImpactFX )

				table.insert( self.vecEnemiesHit, enemy )
			end
		end
	end

	if bKillThinker then
		self:Destroy()
		return -1
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_shivas_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
