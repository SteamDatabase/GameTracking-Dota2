
if modifier_tower_upgrade_spawn_melee_creeps == nil then
	modifier_tower_upgrade_spawn_melee_creeps = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:OnCreated( kv )
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:OnRefresh( kv )
	self.spawns = self:GetAbility():GetSpecialValueFor( "spawns" )
	self.energy_per = self:GetAbility():GetSpecialValueFor( "energy_per" )
	self.position = self:GetAbility():GetSpecialValueFor( "position" )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:GetAdditionalCreeps()
	if IsServer() == 0 then
		return nil
	end

	local tAdditionalCreeps = {}
	for i = 1, self.spawns do
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
	--PrintTable( tAdditionalCreeps, " ** " )
	return tAdditionalCreeps
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_melee_creeps:OnAdditionalCreepSpawned( hCreep )
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