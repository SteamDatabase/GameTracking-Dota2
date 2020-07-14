boss_timbersaw_whirling_death = class({})

----------------------------------------------------------------------------------------

function boss_timbersaw_whirling_death:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_timbersaw/boss_timbersaw_whirling_death.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_whirling_death_debuff.vpcf", context )

end

--------------------------------------------------------------------------------

function boss_timbersaw_whirling_death:OnAbilityPhaseStart()
	if IsServer() then
		self.whirling_radius = self:GetSpecialValueFor( "whirling_radius" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.whirling_radius, self.whirling_radius, self.whirling_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "Hero_Shredder.WhirlingDeath.Cast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_timbersaw_whirling_death:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function boss_timbersaw_whirling_death:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.duration = self:GetSpecialValueFor( "duration" )
		self.whirling_damage = self:GetSpecialValueFor( "whirling_damage" )
		self.tree_damage_scale = self:GetSpecialValueFor( "tree_damage_scale" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/boss_timbersaw/boss_timbersaw_whirling_death.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.whirling_radius, self.whirling_radius, self.whirling_radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Shredder.WhirlingDeath.Cast", self:GetCaster() )

		local nTreeBonusDmg = 0
		local hTrees = GridNav:GetAllTreesAroundPoint( self:GetCaster():GetAbsOrigin(), self.whirling_radius, true )
		for _,Tree in pairs ( hTrees ) do
			if Tree.IsStanding and Tree:IsStanding() then
				nTreeBonusDmg = nTreeBonusDmg + self.tree_damage_scale
				Tree:CutDown( self:GetTeamNumber() )
			end
		end

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.whirling_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_shredder_whirling_death_debuff", { duration = self.duration } )
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.whirling_damage + nTreeBonusDmg,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self,
				}
				ApplyDamage( damageInfo )	
			end
		end
	
	end
end

--------------------------------------------------------------------------------