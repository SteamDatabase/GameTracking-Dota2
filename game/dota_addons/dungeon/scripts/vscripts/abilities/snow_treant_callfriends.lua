snow_treant_call_friends = class({})

--------------------------------------------------------------------------------

function snow_treant_call_friends:OnAbilityPhaseStart()
	if IsServer() then
	end
	return true
end

--------------------------------------------------------------------------------

function snow_treant_call_friends:OnAbilityPhaseInterrupted()
	if IsServer() then
	end
end
--------------------------------------------------------------------------------

function snow_treant_call_friends:OnSpellStart()
	if IsServer() then
		local numSpawns = self:GetSpecialValueFor( "num_spawns" )
		local vLocation = self:GetCaster():GetOrigin()
		for i = 1, numSpawns do
			local hTreantChild = CreateUnitByName( "npc_dota_creature_snow_treant_baby", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hTreantChild ~= nil then
				if self:GetCaster().zone ~= nil then
					self:GetCaster().zone:AddEnemyToZone( hTreantChild )
				end	

				local vRandomOffset = Vector( RandomInt( -20, 20 ), RandomInt( -20, 20 ), 0 )
				local vSpawnPoint = vLocation + vRandomOffset
				FindClearSpaceForUnit( hTreantChild, vSpawnPoint, true )
			end
		end
	end
end

