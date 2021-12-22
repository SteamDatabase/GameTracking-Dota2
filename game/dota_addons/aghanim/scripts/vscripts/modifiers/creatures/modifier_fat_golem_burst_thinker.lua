
modifier_fat_golem_burst_thinker = class({})

------------------------------------------------------------------------------------

function modifier_fat_golem_burst_thinker:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

------------------------------------------------------------------------------------

function modifier_fat_golem_burst_thinker:OnCreated( kv )
	self.thinker_interval = self:GetAbility():GetSpecialValueFor( "thinker_interval" )
	self.thinker_spawn_duration = self:GetAbility():GetSpecialValueFor( "thinker_spawn_duration" )
	self.spawns_per_interval = self:GetAbility():GetSpecialValueFor( "spawns_per_interval" )
	self.max_spawn_distance = self:GetAbility():GetSpecialValueFor( "max_spawn_distance" )
	self.max_spawns = self:GetAbility():GetSpecialValueFor( "max_spawns" )

	self.nTeamNumber = self:GetCaster():GetTeamNumber()

	if IsServer() then
		self.nSkeleteeniesSpawned = 0

		self:StartIntervalThink( self.thinker_interval )
	end
end

------------------------------------------------------------------------------------

function modifier_fat_golem_burst_thinker:OnIntervalThink()
	if not IsServer() then
		return
	end

	local heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
	if #heroes <= 0 then
		return
	end

	local hHeroTarget = heroes[ 1 ]

	-- Create enemies nearby
	local vParentPos = self:GetParent():GetAbsOrigin()
	for i = 1, self.spawns_per_interval do
		local vRandomOffset = Vector( RandomInt( -self.max_spawn_distance, self.max_spawn_distance ), RandomInt( -self.max_spawn_distance, self.max_spawn_distance ), 0 )
		local vSpawnPos = vParentPos + vRandomOffset

		local nAttempts = 0
		while ( ( not GridNav:CanFindPath( self:GetParent():GetOrigin(), vSpawnPos ) ) and ( nAttempts < 5 ) ) do
			vRandomOffset = Vector( RandomInt( -self.max_spawn_distance, self.max_spawn_distance ), RandomInt( -self.max_spawn_distance, self.max_spawn_distance ), 0 )
			vSpawnPos = vParentPos + vRandomOffset
			nAttempts = nAttempts + 1

			if nAttempts >= 5 then
				vSpawnPos = self:GetParent():GetAbsOrigin()
			end
		end

		local hSkeleteeny = CreateUnitByName( "npc_dota_creature_skeleteeny", vParentPos, true, nil, nil, self.nTeamNumber )
		if hSkeleteeny ~= nil and not hSkeleteeny:IsNull() then
			FindClearSpaceForUnit( hSkeleteeny, vSpawnPos, true )

			if hHeroTarget ~= nil then
				hSkeleteeny:SetInitialGoalEntity( hHeroTarget )
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hSkeleteeny )
			ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPos )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self.nSkeleteeniesSpawned = self.nSkeleteeniesSpawned + 1

			if self.nSkeleteeniesSpawned >= self.max_spawns then
				self:StartIntervalThink( -1 )
				self:Destroy()
				return
			end
		end
	end

	if self:GetElapsedTime() >= self.thinker_spawn_duration then
		self:StartIntervalThink( -1 )
		self:Destroy()
		return
	end
end

--------------------------------------------------------------------------------
