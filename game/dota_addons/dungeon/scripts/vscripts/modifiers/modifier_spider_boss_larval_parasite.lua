
--[[ modifiers/modifier_spider_boss_larval_parasite.lua ]]

modifier_spider_boss_larval_parasite = class({})

--------------------------------------------------------------------------------

function modifier_spider_boss_larval_parasite:GetEffectName()
	return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spider_boss_larval_parasite:OnCreated( kv )
	self.explosion_damage = self:GetAbility():GetSpecialValueFor( "explosion_damage" )
	self.num_spawns = self:GetAbility():GetSpecialValueFor( "num_spawns" )
	self.buff_duration = self:GetAbility():GetSpecialValueFor( "buff_duration" )
	self.infection_radius = self:GetAbility():GetSpecialValueFor( "infection_radius" )
	self.vision_radius = self:GetAbility():GetSpecialValueFor( "vision_radius" )

	self.fStartTime = GameRules:GetGameTime()

	if IsServer() then
		self.nFXWarningIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXWarningIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nFXWarningIndex, 1, Vector( self.infection_radius, self.infection_radius, self.infection_radius ) )
		ParticleManager:SetParticleControl( self.nFXWarningIndex, 2, Vector( self.buff_duration, self.buff_duration, self.buff_duration ) )
		ParticleManager:SetParticleControl( self.nFXWarningIndex, 15, Vector( 131, 251, 40 ) )
		ParticleManager:SetParticleControl( self.nFXWarningIndex, 16, Vector( 1, 0, 0 ) )

		self:StartIntervalThink( 0.0 )
	end
		
end

--------------------------------------------------------------------------------

function modifier_spider_boss_larval_parasite:OnIntervalThink()
	if IsServer() then
		local fTimer = self.buff_duration - ( GameRules:GetGameTime() - self.fStartTime )
		--print( "fTimer == " .. fTimer )

		local nFXIndex = ParticleManager:CreateParticle( "particles/dungeon_overhead_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, math.floor( fTimer + 0.1 ), 0 ) ) -- timer was showing up wrong, 0.1 seemed to fix
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, math.ceil( fTimer ), 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1, 0, 0 ) ) -- Only 1 digit for the duration of all lvls of this effect
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	self:StartIntervalThink( 1.0 )
end

--------------------------------------------------------------------------------

function modifier_spider_boss_larval_parasite:OnDestroy()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		
		EmitSoundOn( "Broodmother.LarvalParasite.Burst", self:GetParent() )
		ParticleManager:DestroyParticle( self.nFXWarningIndex, false )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_broodmother_debuff_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

		local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.infection_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, hEnemy in pairs( hEnemies ) do
			-- Apply explosion damage
			local damage = {
				victim = hEnemy,
				attacker = self:GetCaster(),
				damage = self.explosion_damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self
			}
			ApplyDamage( damage )

			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", PATTACH_ABSORIGIN, hEnemy ) )

			-- Create some little spiders
			for i = 1, self.num_spawns do
				if #self:GetCaster().hSummonedUnits + 1 > self:GetCaster().nMaxSummonedUnits then
					break
				end

				local hSpiderling = CreateUnitByName( "npc_dota_creature_small_lycosidae", hEnemy:GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hSpiderling ~= nil then
					table.insert( self:GetCaster().hSummonedUnits, hSpiderling )
					if self:GetCaster().zone ~= nil then
						self:GetCaster().zone:AddEnemyToZone( hSpiderling )
					end	

					local vRandomOffset = Vector( RandomInt( -40, 40 ), RandomInt( -40, 40 ), 0 )
					local vSpawnPoint = hEnemy:GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hSpiderling, vSpawnPoint, true )
				end
			end

			--[[
			-- Infect other enemies near target, but not victim again
			if hEnemy ~= self:GetParent() then
				--print( "modifier_spider_boss_larval_parasite:OnDestroy() - infecting enemy named " .. hEnemy:GetUnitName() )
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_spider_boss_larval_parasite", { duration = self.buff_duration } )
			end
			]]
		end
	end
end

--------------------------------------------------------------------------------


