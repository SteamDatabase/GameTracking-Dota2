
huge_brood_summon_eggs = class({})

--------------------------------------------------------------------------------

function huge_brood_summon_eggs:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_broodmother_baby_d", context, -1 )
end

--------------------------------------------------------------------------------

function huge_brood_summon_eggs:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function huge_brood_summon_eggs:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function huge_brood_summon_eggs:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		if self.hSummonedUnits == nil then
			self.hSummonedUnits = {}
		end

		self.egg_spawns = self:GetSpecialValueFor( "egg_spawns" )
		self.spider_spawns = self:GetSpecialValueFor( "spider_spawns" )
		self.max_summoned_units = self:GetSpecialValueFor( "max_summoned_units" )
		self.summon_radius = self:GetSpecialValueFor( "summon_radius" )

		EmitSoundOn( "Creature.Summon", self:GetCaster() )

		for i = 1, self.egg_spawns do
			if #self.hSummonedUnits + 1 < self.max_summoned_units then
				local nMaxDistance = self.summon_radius
				local vSpawnLoc = nil

				local nMaxAttempts = 5
				local nAttempts = 0

				repeat
					if nAttempts > nMaxAttempts then
						vSpawnLoc = nil
						printf( "WARNING - huge_brood_summon_eggs - failed to find valid spawn loc for egg" )
						break
					end

					local vPos = self:GetCaster():GetAbsOrigin() + RandomVector( nMaxDistance )
					vSpawnLoc = FindPathablePositionNearby( vPos, 0, 50 )
					nAttempts = nAttempts + 1
				until ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vSpawnLoc ) )

				if vSpawnLoc == nil then
					vSpawnLoc = self:GetCaster():GetAbsOrigin()
				end

				local hEgg = CreateUnitByName( "npc_dota_spider_sac", vSpawnLoc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hEgg ~= nil then
					table.insert( self.hSummonedUnits, hEgg )
					--local vRandomOffset = Vector( RandomInt( -self.summon_radius, self.summon_radius ), RandomInt( -self.summon_radius, self.summon_radius ), 0 )
					--local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hEgg, vSpawnLoc, true )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnLoc )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
				end
			end
		end

		for i = 1, self.spider_spawns do
			if #self.hSummonedUnits + 1 < self.max_summoned_units then
				local nMaxDistance = self.summon_radius
				local vSpawnLoc = nil

				local nMaxAttempts = 5
				local nAttempts = 0

				repeat
					if nAttempts > nMaxAttempts then
						vSpawnLoc = nil
						printf( "WARNING - huge_brood_summon_eggs - failed to find valid spawn loc for spider" )
						break
					end

					local vPos = self:GetCaster():GetAbsOrigin() + RandomVector( nMaxDistance )
					vSpawnLoc = FindPathablePositionNearby( vPos, 0, 50 )
					nAttempts = nAttempts + 1
				until ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vSpawnLoc ) )

				if vSpawnLoc == nil then
					vSpawnLoc = self:GetCaster():GetAbsOrigin()
				end

				if vSpawnLoc ~= nil then
					local hSummonedSpider = CreateUnitByName( "npc_dota_creature_broodmother_baby_d", vSpawnLoc, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					if hSummonedSpider ~= nil then
						table.insert( self.hSummonedUnits, hSummonedSpider )
						hSummonedSpider:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )

						--local vRandomOffset = Vector( RandomInt( -600, 600 ), RandomInt( -600, 600 ), 0 )
						--local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
						FindClearSpaceForUnit( hSummonedSpider, vSpawnLoc, true )

						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
						ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnLoc )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
