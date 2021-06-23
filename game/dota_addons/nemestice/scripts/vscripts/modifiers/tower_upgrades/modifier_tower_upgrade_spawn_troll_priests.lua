
if modifier_tower_upgrade_spawn_troll_priests == nil then
	modifier_tower_upgrade_spawn_troll_priests = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:OnCreated( kv )
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:OnRefresh( kv )
	self.spawns = self:GetAbility():GetSpecialValueFor( "spawns" )
	self.energy_per = self:GetAbility():GetSpecialValueFor( "energy_per" )
	self.position = self:GetAbility():GetSpecialValueFor( "position" )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:GetAdditionalCreeps()
	if IsServer() == 0 then
		return nil
	end

	local tAdditionalCreeps = {}
	for i = 1, self.spawns do
		local tNewCreep = {}
		tNewCreep.szCreepName = "npc_dota_creature_troll_priest"
		tNewCreep.hCallback = self.OnAdditionalCreepSpawned
		tNewCreep.hModifierSource = self
		tNewCreep.nMeteorEnergy = self.energy_per
		tNewCreep.nPosition = self.position
		--if self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		--	tNewCreep.vecColor = Vector( 0, 255, 0 )
		--else
		--	tNewCreep.vecColor = Vector( 255, 0, 0 )
		--end
		table.insert( tAdditionalCreeps, tNewCreep )
	end
	--PrintTable( tAdditionalCreeps, " ** " )
	return tAdditionalCreeps
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_spawn_troll_priests:OnAdditionalCreepSpawned( hCreep )
	if IsServer() == 0 then
		print( "not the server?")
		return
	end

	if hCreep == nil then
		print( "no creep?")
		return 
	end

	hCreep:CreatureLevelUp( GameRules.Nemestice:GetRoundNumber() - 1 )
	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = hCreep:GetAbilityByIndex( i )
		if hAbility then
			hAbility:SetLevel( GameRules.Nemestice:GetRoundNumber() )
		end
	end
end