la_spawn_enemy_at_target = class({})

LinkLuaModifier( "lm_spawn_enemy_at_target", LUA_MODIFIER_MOTION_NONE )

function la_spawn_enemy_at_target:OnSpellStart()
	Msg( "la_spawn_enemy_at_target:OnSpellStart\n")

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )

	local vTargetPos = hPlayerHero:GetAbsOrigin()
	vTargetPos.z = 0
	Msg( tostring( vTargetPos ) )

	local fRandom = RandomFloat( 0, 1 )
	local hEnemy = nil

	if fRandom <= 0.8 then
		hEnemy = CreateUnitByName( "npc_dota_hero_axe", vTargetPos, true, nil, nil, GameRules.herodemo.m_nENEMIES_TEAM )
		table.insert( GameRules.herodemo.m_tEnemiesList, hEnemy )
	else
		hEnemy = CreateUnitByName( "npc_dota_hero_antimage", vTargetPos, true, nil, nil, GameRules.herodemo.m_nENEMIES_TEAM )
		hEnemy:SetModelScale( 0.5 )
		table.insert( GameRules.herodemo.m_tEnemiesList, hEnemy )
	end

	hEnemy:SetControllableByPlayer( GameRules.herodemo.m_nPlayerID, false )
	FindClearSpaceForUnit( hEnemy, vTargetPos, false )
	hEnemy:Hold()
	hEnemy:SetIdleAcquire( false )
	hEnemy:SetAcquisitionRange( 0 )
end

function la_spawn_enemy_at_target:GetCastRange( vLocation, hTarget )
	Msg( "la_spawn_enemy_at_target:GetCastRange\n" )
	return 5000
end