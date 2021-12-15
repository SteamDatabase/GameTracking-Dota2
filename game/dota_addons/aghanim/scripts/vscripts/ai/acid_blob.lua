
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	thisEntity.bInitialAggro = false

	thisEntity.fLastAggroTime = GameRules:GetGameTime()
	thisEntity.fAggroIdleTime = 12

	thisEntity:SetContextThink( "AcidblobThink", AcidblobThink, 1 )
end

--------------------------------------------------------------------------------

function AcidblobThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	if thisEntity:GetAggroTarget() ~= nil then
		--print( 'YES AGGRO' )
		thisEntity.fLastAggroTime = GameRules:GetGameTime()
		return 0.5
	end

	local fTimeSinceLastAggro = GameRules:GetGameTime() - thisEntity.fLastAggroTime
	--print( 'TIME SINCE LAST AGGRO = ' .. fTimeSinceLastAggro )
	if fTimeSinceLastAggro > thisEntity.fAggroIdleTime then
		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), FIND_UNITS_EVERYWHERE )
		--print( 'FOUND ' .. #heroes .. ' HEROES!' )
		if #heroes > 0 then
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--print( 'DORMANT BLOB IS GOING AFTER A HERO! ' .. hero:GetUnitName() )
				thisEntity.fLastAggroTime = GameRules:GetGameTime()
				thisEntity:MoveToPositionAggressive( hero:GetAbsOrigin() )
			end
		end
	end

	return 0.5
end

