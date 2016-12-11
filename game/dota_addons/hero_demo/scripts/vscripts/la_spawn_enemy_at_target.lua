la_spawn_enemy_at_target = class({})

LinkLuaModifier( "lm_spawn_enemy_at_target", LUA_MODIFIER_MOTION_NONE )

function la_spawn_enemy_at_target:OnSpellStart()
	Msg( "la_spawn_enemy_at_target:OnSpellStart\n")

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )

	local vTargetPos = hPlayerHero:GetAbsOrigin()
	vTargetPos.z = 0
	Msg( tostring( vTargetPos ) )
	table.insert( GameRules.herodemo.m_tEnemiesList, CreateUnitByName( "npc_dota_hero_axe", vTargetPos, true, nil, nil, GameRules.herodemo.m_nENEMIES_TEAM ) )

	local hUnit = GameRules.herodemo.m_tEnemiesList[ #GameRules.herodemo.m_tEnemiesList ] -- the unit we want a handle on is in the last index of the table
	hUnit:SetControllableByPlayer( GameRules.herodemo.m_nPlayerID, false )
	FindClearSpaceForUnit( hUnit, vTargetPos, false )
	hUnit:Hold()
	hUnit:SetIdleAcquire( false )
	hUnit:SetAcquisitionRange( 0 )
end

function la_spawn_enemy_at_target:GetCastRange( vLocation, hTarget )
	Msg( "la_spawn_enemy_at_target:GetCastRange\n" )
	return 5000
end