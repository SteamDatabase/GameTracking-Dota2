--[[
Broodking AI
]]

function Spawn( entityKeyValues )
	POSITIONS_retreat = Entities:FindAllByName( "waypoint_*" )
	for i = 1, #POSITIONS_retreat do
		POSITIONS_retreat[i] = POSITIONS_retreat[i]:GetOrigin()
	end

	ABILITY_spin_web = thisEntity:FindAbilityByName( "creature_spin_web" )
	ABILITY_spawn_broodmother = thisEntity:FindAbilityByName( "creature_spawn_broodmother" )
	if ABILITY_spawn_broodmother == nil then
		ABILITY_spawn_broodmother = thisEntity:FindAbilityByName( "creature_spawn_broodmother_eggs" )
	end

	thisEntity:SetContextThink( "BroodkingThink", BroodkingThink, 0.25 )
end


function BroodkingThink()
	if not thisEntity:IsAlive() then
		local web = Entities:FindByClassname( nil, "npc_dota_broodmother_web" )
		while web do
			local thisWeb = web
			web = Entities:FindByClassname( web, "npc_dota_broodmother_web" )
			thisWeb:ForceKill( false )
		end
		return nil
	end

	local now = GameRules:GetGameTime()
	if not thisEntity:IsIdle() then
		-- Don't let broodking do *anything* for 30s or longer.
		if now - thisEntity:GetLastIdleChangeTime() > 30 then
			thisEntity:Stop()
		else
			return 0.5
		end
	end

	-- Spawn a broodmother whenever we're able to do so.
	if ABILITY_spawn_broodmother:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget( ABILITY_spawn_broodmother, -1 )
		return 0.1
	end

	-- Wait 10 seconds if we're idling in a web.
	if now - thisEntity:GetLastIdleChangeTime() < 10 then
		return 0.5
	end

	-- Move to the target and cast.
	thisEntity:CastAbilityOnPosition( POSITIONS_retreat[ RandomInt( 1, #POSITIONS_retreat ) ], ABILITY_spin_web, -1 )
	return 0.1
end


local escapePoint = nil
local flWaitUntilTime = 0
local nWaitUntilHP = 0
function IdleWander()
	if escapePoint ~= nil then
		if (thisEntity:GetOrigin() - escapePoint):Length() < 300 then
			escapePoint = nil
			flWaitUntilTime = GameRules:GetGameTime() + RandomFloat( 10, 15 ) -- Wait 10 - 15 seconds at the destination
			nWaitUntilHP = math.floor( thisEntity:GetHealth() - thisEntity:GetMaxHealth() * 0.1 ) -- Wait until we've lost some health
			-- Drop a web here, if we can.
			if ABILITY_spin_web:IsFullyCastable() then
				thisEntity:Stop()
				thisEntity:CastAbilityNoTarget( ABILITY_spin_web, -1 )
			end
		end
	end

	if escapePoint == nil then
		if flWaitUntilTime > GameRules:GetGameTime() and nWaitUntilHP < thisEntity:GetHealth() then
			return 0.2
		end
		flWaitUntilTime = 0
		nWaitUntilHP = 0

		local happyPlaceIndex = RandomInt( 1, #POSITIONS_retreat )
		escapePoint = POSITIONS_retreat[ happyPlaceIndex ]
	end
	thisEntity:MoveToPosition( escapePoint )
	return RandomFloat( 0.1, 1.0 )
end


function DropMarkerFX( pt )
	-- Drop an effect where we're moving to
	local nFXIndex = ParticleManager:CreateParticle( "veil_of_discord", PATTACH_CUSTOMORIGIN, thisEntity )
	ParticleManager:SetParticleControl( nFXIndex, 0, pt )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end
