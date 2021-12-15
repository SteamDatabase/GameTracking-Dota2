modifier_candy_well_bomb_thinker = class({})

------------------------------------------------------------------

function modifier_candy_well_bomb_thinker:IsHidden()
	return true
end

------------------------------------------------------------------

function modifier_candy_well_bomb_thinker:IsPurgable() 
	return false
end

------------------------------------------------------------------

function modifier_candy_well_bomb_thinker:OnCreated( kv )
	if IsServer() and self:GetAbility() == nil then
		self:Destroy()
		UTIL_Remove( self:GetParent() )
		return
	end

	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/candy_well/candy_well_bomb_ground_preview.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.delay, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 100, 155, 255 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:StartIntervalThink( self.delay )
	end
end

------------------------------------------------------------------

function modifier_candy_well_bomb_thinker:OnIntervalThink()
	if IsServer() then
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "CandyBucket.BombCast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() + Vector( 0, 0, 40 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local guardian_name = "npc_dota_creature_bucket_soldier"
		local guardian_origin = self:GetCaster():GetOrigin()
		local guardian = CreateUnitByName(guardian_name, guardian_origin, true, self:GetParent(), nil, DOTA_TEAM_BADGUYS)

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
			 	guardian:SetInitialGoalEntity( enemy )
			end
		end
		print( "Adding Bucket Soldier Passive Modifier" )
		guardian:AddNewModifier( self:GetParent(), nil, "modifier_bucket_soldier_passive", { duration = -1 } )

		self:Destroy()
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------