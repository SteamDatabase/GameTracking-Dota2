--[[ traps/poisoncloud_trap.lua ]]

---------------------------------------------------------------------------
-- Poisoncloud Trap
---------------------------------------------------------------------------

function OnTrigger( trigger )
	if thisEntity.isTrapActivated then
		print( "Trap Skip" )
		return
	end

	--[[
	print( "-------------------------------------------------" )
	print( "OnTrigger... thisEntity:" )
	PrintTable( thisEntity, "   " )
	]]

	local baseTriggerName = "trigger_poisoncloud_trap_"
	local triggerName = thisEntity:GetName()

	-- Extract the suffix off the end of triggerName.  We'll be using it to keep the trigger, target all linked up (this does force us to have unique suffixes in our trap entity names in the map).
	local index, strMatch = string.find( triggerName, baseTriggerName )
	local suffix = string.sub( triggerName, index + string.len( baseTriggerName ), string.len( triggerName ) )
	--print( "suffix == " .. suffix )

	EmitGlobalSound( "ui.ui_player_disconnected" )

	TriggerTrap( triggerName, suffix )
end


function TriggerTrap( triggerName, suffix )
	local fTriggerDelay = 0

	if not thisEntity.isTrapActivated then
		local hTrigger = Entities:FindByName( nil, triggerName )
		if hTrigger == nil then
			print( "ERROR: hTrigger not found" )
			return
		end

		EmitSoundOn( "Dungeon.TrapActivate", hTrigger )

		thisEntity.triggerName = triggerName
		thisEntity.npcName = "npc_dota_poisoncloud_trap_" .. suffix
		thisEntity.targetName = "npc_dota_poisoncloud_trap_target_" .. suffix
		--thisEntity.modelName = "poisoncloud_trap_model_" .. suffix
		thisEntity.isTrapActivated = true

		hTrigger:SetContextThink( "ActivateTrap", function() return PoisonCloudTrapActivate() end, fTriggerDelay )
	end
end


function PoisonCloudTrapActivate()
	if thisEntity.isTrapActivated == true then
		--[[
		print( "----------------------------------------------------------" )
		print( "PoisonCloudTrapActivate... thisEntity:" )
		PrintTable( thisEntity, "   " )
		]]

		local hTargets = Entities:FindAllByName( thisEntity.targetName )
		if #hTargets == 0 then
			print( "ERROR: No hTargets found" )
			return
		end

		local hTrapNPCs = Entities:FindAllByName( thisEntity.npcName )
		if #hTrapNPCs == 0 then
			print( "ERROR: No hTrapNPCs found" )
			return
		end

		for index, hTarget in pairs( hTargets ) do
			local vPos = hTarget:GetOrigin()
			-- This method requires one npc per target (there was an issue with one npc casting multiple spells quickly)
			if hTrapNPCs[ index ] then
				local hPoisonCloudAbility = hTrapNPCs[ index ]:FindAbilityByName( "alchemist_acid_spray" )
				if hPoisonCloudAbility == nil then
					print( "ERROR: hPoisonCloudAbility not found" )
					return
				end
				hTrapNPCs[ index ]:CastAbilityOnPosition( hTarget:GetOrigin(), hPoisonCloudAbility, -1 )

				--[[
				-- Create a bunch of bats
				for i = 0, RandomInt( 4, 8 ) do
					local vRandomOffset = RandomVector( RandomFloat( 20, 100 ) )
					CreateUnitByName( "npc_dota_creature_bat", hTarget:GetOrigin() + vRandomOffset, true, nil, nil, DOTA_TEAM_BADGUYS )
				end
				]]
			end
		end
		thisEntity.isTrapActivated = false
	end

	return -1
end

