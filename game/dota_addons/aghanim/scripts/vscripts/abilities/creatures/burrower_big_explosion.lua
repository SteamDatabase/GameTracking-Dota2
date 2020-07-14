
burrower_big_explosion = class({})

----------------------------------------------------------------------------------------

function burrower_big_explosion:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", context )

end

--------------------------------------------------------------------------------

function burrower_big_explosion:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		--self.duration = self:GetSpecialValueFor( "duration" )
		self.damage = self:GetSpecialValueFor( "damage" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "Burrower.PreSuicide", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function burrower_big_explosion:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function burrower_big_explosion:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )

		EmitSoundOn( "Burrower.Explosion", self:GetCaster() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,hEnemy in pairs( enemies ) do
			if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = hEnemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					--damage_type = DAMAGE_TYPE_MAGICAL,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}
				ApplyDamage( damageInfo )
				--hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.duration } )
			end
		end

		self:GetCaster():ForceKill( false )
	end
end

--------------------------------------------------------------------------------