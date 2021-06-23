
if modifier_tower_upgrade_spawn_lane_creeps == nil then
	modifier_tower_upgrade_spawn_lane_creeps = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:OnCreated( kv )
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:OnRefresh( kv )
	if IsServer() == false then
		return
	end

	self.melee_spawns = self:GetAbility():GetSpecialValueFor( "melee_spawns" )
	self.ranged_spawns = self:GetAbility():GetSpecialValueFor( "ranged_spawns" )
	self.energy_per = self:GetAbility():GetSpecialValueFor( "energy_per" )
	self.position = self:GetAbility():GetSpecialValueFor( "position" )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:GetAdditionalCreeps()
	if IsServer() == 0 then
		return nil
	end
	
	local nMeleeSpawns = self.melee_spawns
	local nRangedSpawns = self.ranged_spawns

	local tAdditionalCreeps = {}
	for i = 1, nMeleeSpawns do
		local tNewCreep = {}
		tNewCreep.szCreepName = "npc_dota_creep_goodguys_melee"
		tNewCreep.hCallback = self.OnAdditionalCreepSpawned
		tNewCreep.hModifierSource = self
		tNewCreep.nMeteorEnergy = self.energy_per
		tNewCreep.nPosition = self.position
		if self:GetParent():GetTeamNumber() == DOTA_TEAM_BADGUYS then
			tNewCreep.szCreepName = "npc_dota_creep_badguys_melee"
		end
		table.insert( tAdditionalCreeps, tNewCreep )
	end

	for i = 1, nRangedSpawns do
		local tNewCreep = {}
		tNewCreep.szCreepName = "npc_dota_creep_goodguys_ranged"
		tNewCreep.hCallback = self.OnAdditionalCreepSpawned
		tNewCreep.hModifierSource = self
		tNewCreep.nMeteorEnergy = self.energy_per
		tNewCreep.nPosition = self.position
		if self:GetParent():GetTeamNumber() == DOTA_TEAM_BADGUYS then
			tNewCreep.szCreepName = "npc_dota_creep_badguys_ranged"
		end
		table.insert( tAdditionalCreeps, tNewCreep )
	end

	--PrintTable( tAdditionalCreeps, " ** " )
	return tAdditionalCreeps
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_lane_creeps:OnAdditionalCreepSpawned( hCreep )
	if IsServer() == 0 then
		print( "not the server?")
		return
	end

	if hCreep == nil then
		print( "no creep?")
		return 
	end

	hCreep:CreatureLevelUp( GameRules.Nemestice:GetRoundNumber() - 1 )
end