
--[[ abilities/giant_burrower_minion_spawner.lua ]]

giant_burrower_minion_spawner = class({})

function giant_burrower_minion_spawner:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "LycanBoss.SummonWolves", self:GetCaster() )

		local nMinionSpawns = self:GetCaster().GIANT_BURROWER_MAX_SUMMONS
		for i = 0, nMinionSpawns do
			if #self:GetCaster().GIANT_BURROWER_SUMMONED_UNITS + 1 <= self:GetCaster().GIANT_BURROWER_MAX_SUMMONS then
				self:CreateMinion()
			end
		end
	end
end

function giant_burrower_minion_spawner:CreateMinion()
	local hMinion = CreateUnitByName( "npc_dota_creature_exploding_burrower", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	if hMinion ~= nil then
		hMinion:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
		hMinion.hParent = self:GetCaster()
		table.insert( self:GetCaster().GIANT_BURROWER_SUMMONED_UNITS, hMinion )
		if self:GetCaster().zone ~= nil then
			self:GetCaster().zone:AddEnemyToZone( hMinion )
		end	

		local fDist = 900
		local vCasterPos = self:GetCaster():GetAbsOrigin()
		local vSpawnPoint = vCasterPos + Vector( RandomInt( -fDist, fDist ), RandomInt( -fDist, fDist ), 0 )

		-- Verify path is clear from giant burrower to desired spawn loc
		local nMaxAttempts = 7
		local nAttempts = 0
		while ( not GridNav:CanFindPath( vCasterPos, vSpawnPoint ) ) do
			vSpawnPoint = vCasterPos + Vector( RandomInt( -fDist, fDist ), RandomInt( -fDist, fDist ), 0 )
			nAttempts = nAttempts + 1
			if nAttempts >= nMaxAttempts then
				break
			end
		end

		FindClearSpaceForUnit( hMinion, vSpawnPoint, true )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

