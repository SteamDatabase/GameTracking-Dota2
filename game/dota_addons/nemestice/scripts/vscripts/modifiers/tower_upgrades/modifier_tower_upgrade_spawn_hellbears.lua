
if modifier_tower_upgrade_spawn_hellbears == nil then
	modifier_tower_upgrade_spawn_hellbears = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:OnCreated( kv )
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:OnRefresh( kv )
	self.spawns = self:GetAbility():GetSpecialValueFor( "spawns" )
	self.nthRound = self:GetAbility():GetSpecialValueFor( "nthRound" )
	self.energy_per = self:GetAbility():GetSpecialValueFor( "energy_per" )
	self.position = self:GetAbility():GetSpecialValueFor( "position" )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:GetAdditionalCreeps()
	if IsServer() == 0 then
		return nil
	end

	local tAdditionalCreeps = {}
	if self.nthRound == 1 or math.mod( GameRules.Nemestice:GetWaveNumber(), self.nthRound ) == 0 then
		for i = 1, self.spawns do
			local tNewCreep = {}
			tNewCreep.szCreepName = "npc_dota_creature_tower_upgrade_hellbear"
			tNewCreep.hCallback = self.OnAdditionalCreepSpawned
			tNewCreep.hModifierSource = self
			tNewCreep.nMeteorEnergy = self.energy_per
			tNewCreep.nPosition = self.position
			table.insert( tAdditionalCreeps, tNewCreep )
		end
		--PrintTable( tAdditionalCreeps, " ** " )
	end
	return tAdditionalCreeps
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_hellbears:OnAdditionalCreepSpawned( hCreep )
	if IsServer() == 0 then
		print( "not the server?")
		return
	end

	if hCreep == nil then
		print( "no creep?")
		return 
	end

	-- hellbear gets a level for each round
	hCreep:CreatureLevelUp( GameRules.Nemestice:GetRoundNumber() - 1 )

	hCreep:SetModelScale( 2.0 )
	hCreep:SetHealthBarOffsetOverride( hCreep:GetBaseHealthBarOffset() + hCreep:GetModelScale() * 100 )
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_BADGUYS then
		hCreep:SetMaterialGroup( "bad" )
	end
end