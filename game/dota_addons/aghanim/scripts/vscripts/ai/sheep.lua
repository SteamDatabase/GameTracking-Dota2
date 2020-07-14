--[[ Sheep AI ]]

local bHasBeenSaved = false
local hPortal = nil
local vPortalPos = nil
local nHoldTime = 0

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hPortal = Entities:FindByName( nil, "portal_path_track" )
	vPortalPos = hPortal:GetOrigin()

	thisEntity:SetContextThink( "SheepThink", SheepThink, 1 )
end

--------------------------------------------------------------------------------

function SheepThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	if bHasBeenSaved == false then
		if hPortal ~= nil then
			thisEntity:MoveToPosition( vPortalPos )
			local vPos = thisEntity:GetOrigin()
			local difference = vPos - vPortalPos
			local distance = difference:Length()
			if distance < 100 then
				--print("Sheep has been saved!")
				thisEntity:Hold()
				local szPortalFX = "particles/econ/events/league_teleport_2014/teleport_start_league.vpcf"
				local hPortalEffects = ParticleManager:CreateParticle( szPortalFX, PATTACH_CUSTOMORIGIN_FOLLOW, thisEntity )
				ParticleManager:SetParticleControlEnt( hPortalEffects, 0, thisEntity, PATTACH_POINT_FOLLOW, "attach_hitloc", thisEntity:GetAbsOrigin(), false )
				thisEntity:Attribute_SetIntValue( "effectsID", hPortalEffects )
				bHasBeenSaved = true
				EmitSoundOn("Creature.Sheep.Portal_Start", thisEntity)
			end
		end
	else
		if nHoldTime < 3 then
			nHoldTime = nHoldTime + 1
			--thisEntity:SetModelScale(nModelScale)
		else
			StopSoundOn("Creature.Sheep.Portal_Start", thisEntity)
			EmitSoundOn("Creature.Sheep.Portal_End", thisEntity)
			local hBase = Entities:FindByName( nil, "a1_1a_teamspawn_left" )
			local vTargetPoint = hBase:GetOrigin()
			thisEntity:SetAbsOrigin( vTargetPoint )
			thisEntity:ForceKill(false)
		end
	end
	
	return 1
end

--------------------------------------------------------------------------------
