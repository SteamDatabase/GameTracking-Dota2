--[[ units/ai/ai_bandit.lua ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--[[
	hBlinkStrikeAbility = thisEntity:FindAbilityByName( "creature_blink_strike" )
	hBlinkStrikeAbility:SetLevel( 4 )
	]]

	thisEntity:SetContextThink( "BanditThink", BanditThink, 1 )
end


function BanditThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Get last aggro timestamp
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	end

	if thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if not thisEntity.bHasAggro then
		return 1
	end

	--[[
	-- If we've had aggro for a bit, we're willing to launch Blink Strike
	local fDelayBeforeBlinkStrike = RandomFloat( 3, 6 )
	if thisEntity.timeOfLastAggro and ( GameRules:GetGameTime() > ( thisEntity.timeOfLastAggro + fDelayBeforeBlinkStrike ) ) then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #enemies == 0 then
			return 1
		end

		local fLowestHP = nil
		local hLowHealthEnemy = nil
		for i, hEnemy in ipairs( enemies ) do
			local fEnemyHP = hEnemy:GetHealth()
			if i == 1 then
				-- Init value we'll be comparing and set first enemy as our target
				fLowestHP = fEnemyHP
				hLowHealthEnemy = hEnemy
			else
				-- Try to find a weaker enemy target
				if ( fLowestHP ~= nil ) and ( fEnemyHP < fLowestHP ) then
					fLowestHP = fEnemyMaxHP
					hLowHealthEnemy = hEnemy
				end
			end
		end

		-- we probably don't want to blink on our nearest target if we can avoid it
		if hBlinkStrikeAbility ~= nil and hBlinkStrikeAbility:IsCooldownReady() then
			return CastBlinkStrike( hLowHealthEnemy )
		end
	end
	]]

	return 0.5
end

--[[
function CastBlinkStrike( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = hBlinkStrikeAbility:entindex(),
		Queue = false,
	})
	return 5
end
]]

