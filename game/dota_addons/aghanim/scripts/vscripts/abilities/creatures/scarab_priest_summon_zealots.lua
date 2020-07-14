
scarab_priest_summon_zealots = class({})
LinkLuaModifier( "modifier_scarab_priest_summon_mound", "modifiers/creatures/modifier_scarab_priest_summon_mound", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function scarab_priest_summon_zealots:Precache( context )

	PrecacheResource( "particle", "particles/themed_fx/tower_dragon_black_smokering.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_exit.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_zealot_mound", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_zealot_scarab", context, -1 )

end

--------------------------------------------------------------------------------

function scarab_priest_summon_zealots:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function scarab_priest_summon_zealots:OnSpellStart()
	if not IsServer() then
		return
	end

	if self:GetCaster() == nil or self:GetCaster():IsNull() then
		return
	end

--	print( "scarab_priest_summon_zealots:OnSpellStart " )

	local nSummonCount = self:GetSpecialValueFor( "spawn_count" )
	local flSpawnDistance = self:GetSpecialValueFor( "spawn_distance" )
	local flDuration = self:GetSpecialValueFor( "mound_duration" )
	local flDeltaAngle = 360 / nSummonCount
	local vAngles = QAngle( 0, math.random( 0, flDeltaAngle ), 0 )

	for i = 1,nSummonCount do

		local vSpawnPosition = nil
		for s = 1,36 do

			local vDir = AnglesToVector( vAngles )
			local vTest = self:GetCaster():GetAbsOrigin() + vDir * flSpawnDistance + math.random( -25, 25 )

			if GameRules.Aghanim:GetCurrentRoom():IsValidSpawnPoint( vTest ) then
				vSpawnPosition = vTest
				break
			end

			vAngles.y = vAngles.y + 10

		end

		vAngles.y = vAngles.y + flDeltaAngle + math.random( -20, 20 )

		if vSpawnPosition ~= nil then

			EmitSoundOn( "Hero_NyxAssassin.Vendetta", self:GetCaster() )

			local hMound = CreateUnitByName( "npc_dota_creature_zealot_mound", vSpawnPosition, true, 
				self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )

			if hMound ~= nil then
				hMound:AddNewModifier( self:GetCaster(), self, "modifier_scarab_priest_summon_mound", 
					{ 
						duration = flDuration, 
						summoned_unit = "npc_dota_creature_zealot_scarab" 
					} )
				hMound:AddNewModifier( self:GetCaster(), self, "modifier_provides_fow_position", { duration = -1 } )
				hMound:AddNewModifier( self:GetCaster(), self, "modifier_fixed_number_of_hits_to_kill", { duration = -1 } )
			end

		end

	end

end

--------------------------------------------------------------------------------
