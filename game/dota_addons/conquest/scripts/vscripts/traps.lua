--[[ traps.lua ]]

LinkLuaModifier("modifier_trap_reveal_attacker", LUA_MODIFIER_MOTION_NONE)

function tablefirstkey( T )
	for k, _ in pairs( T ) do return k end
	return nil
end

function tablehaselements( T )
	return tablefirstkey( T ) ~= nil
end


---------------------------------------------------------------------------
-- Fire and Venom Traps
---------------------------------------------------------------------------
function CConquestGameMode:OnTrapStartTouch( index, team, level, hActivatingHero, triggerActivated )

	m_trap_info[index].touchers[team][hActivatingHero] = true
	
	hActivatingHero:AddNewModifier( nil, nil, "modifier_trap_reveal_attacker", { duration = 3 } )

	-- Track who is standing on the button, but don't activate
	if not triggerActivated then
		return
	end

	local trapName = m_trap_info[index].npc_name
	local button = trapName .. "_button"

	local ownerTeam = m_trap_info[index].owner

	--Animate the button model
	if m_trap_info[index].isButtonReady == true then
		EmitGlobalSound("ui_menu_activate_open")
		--DoEntFire( button, "SetAnimation", "ancient_trigger001_down_up", 0, self, self )
		--DoEntFire( button, "SetDefaultAnimation", "ancient_trigger001_down_idle", 0.5, self, self )
		m_trap_info[index].isButtonReady = false
	end

	--Check to see if it is blocked
	local bBlocked = tablehaselements( m_trap_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_trap_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		print("Button is blocked for trap "..trapName)
		EmitGlobalSound("Conquest.TrapButton.Blocked")
		m_trap_info[index].isTrapActivated = false
	else
		print("Activate the trap "..trapName)
		local trapName = m_trap_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		m_trap_info[index].isTrapActivated = true
		npc.KillerToCredit = tablefirstkey( m_trap_info[index].touchers[team] )
		npc:SetContextThink( "ActivateTrap", function() return CConquestGameMode:TrapActivate( index ) end, 0 )
	end
end

function CConquestGameMode:TrapActivate( index )
	--print("Attempting to activate trap")
	if m_trap_info[index].isTrapActivated == true then
		--print("Trap is activated")
		local trapName = m_trap_info[index].npc_name
		local trapTarget = m_trap_info[index].targetName
		local target = Entities:FindByName( nil, trapTarget )
		local npc = Entities:FindByName( nil, trapName )
		--Secondary Traps
		local altTrapName = m_trap_info[index].npc_name_alt
		local altTrapTarget = m_trap_info[index].targetName_alt
		local altTarget = Entities:FindByName( nil, altTrapTarget )
		local altNPC = Entities:FindByName( nil, altTrapName )
		--Animating Models
		local modelName = m_trap_info[index].modelName
		local model = Entities:FindByName( nil, modelName )
		local altModelName = m_trap_info[index].modelName_alt
		local altModel = Entities:FindByName( nil, altModelName )

		local fireTrap = npc:FindAbilityByName("breathe_fire")
		local venomTrap = npc:FindAbilityByName("breathe_poison")

		-- Tell the Alt NPC about the Killer to Credit from the proper NPC
		if altNPC ~= nil then
			altNPC.KillerToCredit = npc.KillerToCredit
		end

		if npc.KillerToCredit then
			npc.KillerToCredit:AddNewModifier( nil, nil, "modifier_trap_reveal_attacker", { duration = 3 } )
		end

		local trapUsed = nil
		--print(level)
		if target ~= nil then
			if index < 7 then
				--print("Activating Fire Trap")
				fireTrap.targetLevel = level
				trapUsed = fireTrap
				if model ~= nil then
					DoEntFire( modelName, "SetAnimation", "bark_attack", 0, self, self )
				end
				npc:CastAbilityOnPosition(target:GetOrigin(), fireTrap, -1 )
				if altTarget ~= nil then
					if altModel ~= nil then
						DoEntFire( altModelName, "SetAnimation", "bark_attack", 0, self, self )
					end
					local altFireTrap = altNPC:FindAbilityByName("breathe_fire")
					altFireTrap.targetLevel = level
					altNPC:CastAbilityOnPosition(altTarget:GetOrigin(), altFireTrap, -1 )
				end
				return 2
			else
				--print("Activating Venom Trap")
				trapUsed = venomTrap
				DoEntFire( modelName, "SetAnimation", "fang_attack", 0, self, self )
				npc:CastAbilityOnPosition(target:GetOrigin(), venomTrap, -1 )
				if altTarget ~= nil then
					DoEntFire( altModelName, "SetAnimation", "fang_attack", 0, self, self )
					local altVenomTrap = altNPC:FindAbilityByName("breathe_poison")
					altNPC:CastAbilityOnPosition(altTarget:GetOrigin(), altVenomTrap, -1 )
				end
				return 4
			end
		end
	end
	return -1
end

function CConquestGameMode:OnTrapEndTouch( index, team, hActivatingHero )

	m_trap_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_trap_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_trap_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_trap_info[index].touchers[ownerOpponentTeam] )

	--Reset the button model animation
	if goodTouchCount == 0 and badTouchCount == 0 then
		--DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 0, self, self )
		--DoEntFire( button, "SetDefaultAnimation", "ancient_trigger001_idle", 1, self, self )
		m_trap_info[index].isButtonReady = true
	end

	if bHasAllies == false and bHasEnemies == false then 
		print("All teams have left "..m_trap_info[index].npc_name)
		m_trap_info[index].isTrapActivated = false
	elseif bHasAllies ~= bHasEnemies then
		local trapName = m_trap_info[index].npc_name
		print("Button is no longer blocked for "..trapName)
		m_trap_info[index].isTrapActivated = true
		local npc = Entities:FindByName( nil, trapName )
		local teamToCredit = ownerTeam
		if bHasEnemies then teamToCredit = ownerOpponentTeam end
		npc.KillerToCredit = tablefirstkey( m_trap_info[index].touchers[teamToCredit] )
		npc:SetContextThink( "ActivateTrap", function() return CConquestGameMode:TrapActivate( index ) end, 0 )
	end
end

---------------------------------------------------------------------------
-- Pendulum Trap
---------------------------------------------------------------------------

function CConquestGameMode:PendulumSetup()
	-- Spawning an env_shake for the pendulum
	local shakeTable = {
		spawnflags = "5", --Global Shake, In Air
		targetname = "pendulum_shake",
		origin = "0 0 192",
		amplitude = "4",
		radius = "5000",
		duration = "5",
		frequency = "2.5"
		}
	local shakeEntity = SpawnEntityFromTableSynchronous( "env_shake", shakeTable )
	local cp3Entity = Entities:FindByName( nil, "cp_particle_03" )
	if cp3Entity ~= nil then
		local shakePosition = cp3Entity:GetAbsOrigin()
		shakeEntity:SetAbsOrigin( shakePosition )
		-- Spawning a particle effect for the pendulum
		local debrisTable = {
			targetname = "pendulum_debris",
			origin = "0 0 512",
			effect_name = "particles/newplayer_fx/npx_landslide_debris.vpcf",
			start_active = "0"
			}
		local debrisEntity = SpawnEntityFromTableSynchronous( "info_particle_system", debrisTable )
		local globalEntity = Entities:FindByName( nil, "global_xp" )
		if globalEntity ~= nil then
			local debrisPosition = globalEntity:GetAbsOrigin()
			debrisEntity:SetAbsOrigin( debrisPosition )
		end
	end
end

function CConquestGameMode:OnPendulumStartTouch( index, team, hActivatingHero )
	EmitGlobalSound("ui_menu_activate_open")

	m_pendulum_info[index].touchers[team][hActivatingHero] = true

	local bBlocked = tablehaselements( m_pendulum_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_pendulum_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
	elseif team == m_pendulum_info[index].owner then
		--Activate the trap
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
	end
end

function CConquestGameMode:OnPendulumEndTouch( index, team, hActivatingHero )

	m_pendulum_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_pendulum_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_pendulum_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_pendulum_info[index].touchers[ownerOpponentTeam] )

	if bHasAllies and not bHasEnemies then
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
	end
end

function CConquestGameMode:EnablePendulum( index, team )
	if m_pendulum_info[index].isPendulumReady == true then
		--print("Enabling Pendulum")
		m_pendulum_info[index].isPendulumReady = false
		EmitGlobalSound("Conquest.Pendulum.Trigger")
		EmitGlobalSound("tutorial_rockslide")
		EmitGlobalSound( "Conquest.Pendulum.Scrape" )
		local pendulumName = m_pendulum_info[index].pendulum_name
		DoEntFire( "pendulum_shake", "StartShake", "", 0, self, self )
		DoEntFire( "pendulum_debris", "Start", "", 0, self, self )
		DoEntFire( pendulumName .. "_model", "SetAnimation", "pendulum_swing", 0, self, self )

		local pendulumName = m_pendulum_info[index].pendulum_name
		--print(pendulumName)
		DoEntFire( pendulumName .. "_trigger", "Enable", "", 4, self, self )
		DoEntFire( pendulumName .. "_trigger_backup", "Enable", "", 4, self, self )
		DoEntFire( pendulumName .. "_trigger", "Disable", "", 9, self, self )
		DoEntFire( pendulumName .. "_trigger_backup", "Disable", "", 9, self, self )

		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc:SetContextThink( "DisableTrap", function() return CConquestGameMode:DisablePendulum( index, team ) end, 16.67 )
	end
	return -1
end

function CConquestGameMode:DisablePendulum( index, team )
	--print( "Disabling Pendulum" )
	local pendulumName = m_pendulum_info[index].pendulum_name
	DoEntFire( "pendulum_shake", "StopShake", "", 0, self, self )
	DoEntFire( "pendulum_debris", "Stop", "", 0, self, self )
	DoEntFire( pendulumName .. "_trigger", "Disable", "", 0, self, self )
	m_pendulum_info[index].isPendulumReady = true

	local opposingTeam = DOTA_TEAM_BADGUYS
	if team == DOTA_TEAM_BADGUYS then
		opposingTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_pendulum_info[index].touchers[team] )
	local bHasEnemies = tablehaselements( m_pendulum_info[index].touchers[opposingTeam] )

	if bHasAllies and bHasEnemies then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
		return -1
	elseif bHasAllies then
		--Activate the trap
		--print("Reactivate the trap")
		--CConquestGameMode:EnablePendulum( index, team )
		local trapName = m_pendulum_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_pendulum_info[index].touchers[team] )
		npc:SetContextThink( "EnableTrap", function() return CConquestGameMode:EnablePendulum( index, team ) end, 0 )
		return 0
	end
end

---------------------------------------------------------------------------
-- Sawblade Trap
---------------------------------------------------------------------------

function CConquestGameMode:OnSawbladeStartTouch( index, team, hActivatingHero )
	EmitGlobalSound("ui_menu_activate_open")

	m_sawblade_info[index].touchers[team][hActivatingHero] = true

	local bBlocked = tablehaselements( m_sawblade_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_sawblade_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
	elseif team == m_sawblade_info[index].owner then
		--Activate the trap
		local trapName = m_sawblade_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_sawblade_info[index].touchers[team] )
		npc:SetContextThink( "EnableSawbladeTrap", function() return CConquestGameMode:EnableSawblade( index, team ) end, 0 )
	end
end

function CConquestGameMode:OnSawbladeEndTouch( index, team, hActivatingHero )

	m_sawblade_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_sawblade_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_sawblade_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_sawblade_info[index].touchers[ownerOpponentTeam] )

	if bHasAllies and not bHasEnemies then
		local trapName = m_sawblade_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_sawblade_info[index].touchers[team] )
		npc:SetContextThink( "EnableSawbladeTrap", function() return CConquestGameMode:EnableSawblade( index, team ) end, 0 )
	end
end

function CConquestGameMode:EnableSawblade( index, team )
	if m_sawblade_info[index].isSawbladeReady == true then
		--print("Enabling Sawblade")
		m_sawblade_info[index].isSawbladeReady = false
		EmitGlobalSound("ui.crafting_mech")
		--EmitGlobalSound("Conquest.Pendulum.Trigger")
		local cp3_location = Entities:FindByName( nil, "cp3_particle_neutral")
		StartSoundEvent( "Hero_Shredder.Chakram", cp3_location )
		local sawbladeName = m_sawblade_info[index].sawblade_name
		local sawbladeDuration = 7.5

		DoEntFire( sawbladeName .. "_prefx", "Start", "", 0, self, self )
		DoEntFire( sawbladeName .. "_prefx", "Stop", "", sawbladeDuration, self, self )

		DoEntFire( sawbladeName .. "_shake", "StartShake", "", 0, self, self )
		DoEntFire( sawbladeName .. "_shake", "StopShake", "", 2, self, self )
		DoEntFire( sawbladeName .. "_fx", "Start", "", 0, self, self )
		DoEntFire( sawbladeName .. "_fx", "Stop", "", 2, self, self )

		DoEntFire( sawbladeName .. "_tracktrain_top", "SetSpeed", "200", 2, self, self )
		DoEntFire( sawbladeName .. "_particle_top", "Start", "", 0, self, self )
		DoEntFire( sawbladeName .. "_trigger_top", "Enable", "", 2, self, self )

		DoEntFire( sawbladeName .. "_tracktrain_bot", "SetSpeed", "200", 2, self, self )
		DoEntFire( sawbladeName .. "_particle_bot", "Start", "", 0, self, self )
		DoEntFire( sawbladeName .. "_trigger_bot", "Enable", "", 2, self, self )

		DoEntFire( sawbladeName .. "_particle_top", "StopPlayEndCap", "", sawbladeDuration, self, self )
		DoEntFire( sawbladeName .. "_trigger_top", "Disable", "", sawbladeDuration, self, self )

		DoEntFire( sawbladeName .. "_particle_bot", "StopPlayEndCap", "", sawbladeDuration, self, self )
		DoEntFire( sawbladeName .. "_trigger_bot", "Disable", "", sawbladeDuration, self, self )

		local trapName = m_sawblade_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_sawblade_info[index].touchers[team] )
		npc:SetContextThink( "DisableSawbladeTrap", function() return CConquestGameMode:DisableSawblade( index, team ) end, 15 )
	end
	return -1
end

function CConquestGameMode:DisableSawblade( index, team )
	--print( "Disabling Sawblade" )
	local cp3_location = Entities:FindByName( nil, "cp3_particle_neutral")
	StopSoundEvent( "Hero_Shredder.Chakram", cp3_location )
	m_sawblade_info[index].isSawbladeReady = true

	local opposingTeam = DOTA_TEAM_BADGUYS
	if team == DOTA_TEAM_BADGUYS then
		opposingTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_sawblade_info[index].touchers[team] )
	local bHasEnemies = tablehaselements( m_sawblade_info[index].touchers[opposingTeam] )

	if bHasAllies and bHasEnemies then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
		return -1
	elseif bHasAllies then
		--Activate the trap
		--print("Reactivate the trap")
		local trapName = m_sawblade_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_sawblade_info[index].touchers[team] )
		npc:SetContextThink( "EnableSawbladeTrap", function() return CConquestGameMode:EnableSawblade( index, team ) end, 0 )
		return 0
	end
end

---------------------------------------------------------------------------
-- Boulder Trap
---------------------------------------------------------------------------

function CConquestGameMode:BoulderSetup()
	-- Spawning an env_shake for the pendulum
	local shakeTable = {
		spawnflags = "5", --Global Shake, In Air
		targetname = "boulder_shake",
		origin = "0 0 192",
		amplitude = "4",
		radius = "5000",
		duration = "5",
		frequency = "2.5"
		}
	local shakeEntity = SpawnEntityFromTableSynchronous( "env_shake", shakeTable )
	local cp3Entity = Entities:FindByName( nil, "cp_particle_03" )
	if cp3Entity ~= nil then
		local shakePosition = cp3Entity:GetAbsOrigin()
		shakeEntity:SetAbsOrigin( shakePosition )
		-- Spawning a particle effect for the pendulum
		local debrisTable = {
			targetname = "boulder_debris",
			origin = "0 0 512",
			effect_name = "particles/newplayer_fx/npx_landslide_debris.vpcf",
			start_active = "0"
			}
		local debrisEntity = SpawnEntityFromTableSynchronous( "info_particle_system", debrisTable )
		local globalEntity = Entities:FindByName( nil, "global_xp" )
		if globalEntity ~= nil then
			local debrisPosition = globalEntity:GetAbsOrigin()
			debrisEntity:SetAbsOrigin( debrisPosition )
		end
	end
end

function CConquestGameMode:OnBoulderStartTouch( index, team, hActivatingHero, triggerActivated )
	EmitGlobalSound("ui_menu_activate_open")
	--print("OnBoulderStartTouch")
	m_boulder_info[index].touchers[team][hActivatingHero] = true
	
	hActivatingHero:AddNewModifier( nil, nil, "modifier_trap_reveal_attacker", { duration = 3 } )

	if not triggerActivated then
		-- Still track who is standing on the button, but don't activate
		return
	end

	local bBlocked = tablehaselements( m_boulder_info[index].touchers[DOTA_TEAM_GOODGUYS] ) and tablehaselements( m_boulder_info[index].touchers[DOTA_TEAM_BADGUYS] )
	if bBlocked then
		--print("Button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
	else
		--Activate the trap
		local trapName = m_boulder_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = tablefirstkey( m_boulder_info[index].touchers[team] )
		npc:SetContextThink( "EnableBoulderTrap", function() return CConquestGameMode:EnableBoulder( index, team ) end, 0 )
	end
end

function CConquestGameMode:OnBoulderEndTouch( index, team, hActivatingHero )
	--print("OnBoulderEndTouch")
	m_boulder_info[index].touchers[team][hActivatingHero] = nil

	local ownerTeam = m_boulder_info[index].owner
	local ownerOpponentTeam = DOTA_TEAM_BADGUYS
	if ownerTeam == DOTA_TEAM_BADGUYS then
		ownerOpponentTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_boulder_info[index].touchers[ownerTeam] )
	local bHasEnemies = tablehaselements( m_boulder_info[index].touchers[ownerOpponentTeam] )

	if bHasAllies ~= bHasEnemies then
		local trapName = m_boulder_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		if bHasAllies then
			npc.KillerToCredit = tablefirstkey( m_boulder_info[index].touchers[ownerTeam] )
		else
			npc.KillerToCredit = tablefirstkey( m_boulder_info[index].touchers[ownerOpponentTeam])
		end
		npc:SetContextThink( "EnableBoulderTrap", function() return CConquestGameMode:EnableBoulder( index, team ) end, 0 )
	end
end

function CConquestGameMode:EnableBoulder( index, team )
	if m_boulder_info[index].isBoulderReady == true then
		print("Enabling Boulder "..index.." at "..GameRules:GetDOTATime( false, false ))
		m_boulder_info[index].isBoulderReady = false
		--EmitGlobalSound("Conquest.Pendulum.Trigger")
		EmitGlobalSound("Hero_Invoker.ChaosMeteor.Cast")
		EmitGlobalSound("Ability.Avalanche")
		local boulderName = m_boulder_info[index].boulder_name
		local npc = Entities:FindByName( nil, m_boulder_info[index].npc_name )

		DoEntFire( "boulder_shake", "StartShake", "", 0, self, self )
		DoEntFire( "boulder_debris", "Start", "", 0, self, self )
		DoEntFire( "boulder_shake", "StopShake", "", 4, self, self )
		DoEntFire( "boulder_debris", "Stop", "", 4, self, self )
		DoEntFire( boulderName .. "_model", "SetAnimation", "boulder001_destroy", 2, self, self )
		DoEntFire( boulderName .. "_model", "Enable", "", 2.2, self, self )
		DoEntFire( boulderName .. "_trigger", "Enable", "", 2, self, self )
		DoEntFire( boulderName .. "_impactfx", "SetParent", boulderName .. "_model", 2.6, self, self )
		DoEntFire( boulderName .. "_impactfx", "SetParentAttachment", "attach_boulder", 2.7, self, self )
		DoEntFire( boulderName .. "_impactfx", "Start", "", 3, self, self )
		DoEntFire( boulderName .. "_impactfx", "Stop", "", 6, self, self )
		DoEntFire( boulderName .. "_trigger", "Disable", "", 8.67, self, self )
		DoEntFire( boulderName .. "_model", "Disable", "", 8.67, self, self )
		DoEntFire( boulderName .. "_cracked", "Enable", "", 8.67, self, self )
		DoEntFire( boulderName .. "_cracked", "SetAnimation", "boulder001_cracked_anim", 8.67, self, self )
		DoEntFire( boulderName .. "_cracked", "Disable", "", 14, self, self )

		DoEntFire( boulderName .. "_particle", "SetParent", boulderName .. "_model", 2.6, self, self )
		DoEntFire( boulderName .. "_particle", "SetParentAttachment", "attach_boulder", 2.7, self, self )
		DoEntFire( boulderName .. "_particle", "Start", "", 3, self, self )
		DoEntFire( boulderName .. "_particle", "Stop", "", 8.67, self, self )
		
		npc.KillerToCredit = tablefirstkey( m_boulder_info[index].touchers[team] )
		npc:SetContextThink( "SetIsFalling", function() return CConquestGameMode:SetBoulderIsFalling(index, true) end, 2.6)
		npc:SetContextThink( "UpdateFOWViewers", function() return CConquestGameMode:BoulderUpdateFOWViewers(index, Entities:FindByName( nil, boulderName.."_model") ) end, 2.7 )
		npc:SetContextThink( "StartEffects", function() return CConquestGameMode:BoulderEffects( boulderName, npc ) end, 3 )
		npc:SetContextThink( "PlaySoundEffects1", function() return CConquestGameMode:PlayBoulderSounds( boulderName ) end, 7.25 )
		npc:SetContextThink( "PlaySoundEffects2", function() return CConquestGameMode:PlayBoulderSounds( boulderName ) end, 8.35 )
		npc:SetContextThink( "StopEffects", function() return CConquestGameMode:StopBoulderEffects( boulderName, npc ) end, 8.67 )
		npc:SetContextThink( "SetIsNotFalling", function() return CConquestGameMode:SetBoulderIsFalling(index, false) end, 8.67)
		npc:SetContextThink( "DisableTrap", function() return CConquestGameMode:DisableBoulder( index, team ) end, 15 )

		if npc.KillerToCredit then
			npc.KillerToCredit:AddNewModifier( nil, nil, "modifier_trap_reveal_attacker", { duration = 3 } )
		end
	end
	return -1
end

function CConquestGameMode:BoulderUpdateFOWViewers( index, ent )
	if m_boulder_info[index].isBoulderFalling == true and ent ~= nil and ent:IsNull() == false then
		local boulderLoc = ent:GetAttachmentOrigin( ent:ScriptLookupAttachment( "attach_boulder" ) )
		AddFOWViewer(DOTA_TEAM_GOODGUYS, boulderLoc, 350, 0.25, false)
		AddFOWViewer(DOTA_TEAM_BADGUYS, boulderLoc, 350, 0.25, false)
		return 0.25
	end
	return 0
end

function CConquestGameMode:BoulderEffects( boulderName, npc )
	local boulderEffects = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ROOTBONE_FOLLOW, npc )
	ParticleManager:SetParticleControlEnt( boulderEffects, 0, npc, PATTACH_ROOTBONE_FOLLOW, "attach_boulder", npc:GetAbsOrigin(), false )
	npc:Attribute_SetIntValue( "effectsID", boulderEffects )
	npc:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	EmitGlobalSound("Tiny.Grow")
end

function CConquestGameMode:PlayBoulderSounds( boulderName )
	EmitGlobalSound("Hero_Tiny.Death_01")
	DoEntFire( boulderName .. "_impactfx", "Start", "", 0, self, self )
	DoEntFire( boulderName .. "_impactfx", "Stop", "", 1, self, self )
end

function CConquestGameMode:StopBoulderEffects( boulderName, npc )
	local boulderEffects = npc:Attribute_GetIntValue( "effectsID", -1 )
	ParticleManager:DestroyParticle( boulderEffects, true )
	npc:StopSound("Hero_Invoker.ChaosMeteor.Loop")
	EmitGlobalSound("Tiny.Grow")
end

function CConquestGameMode:DisableBoulder( index, team )
	print( "Disabling Boulder "..index.." at "..GameRules:GetDOTATime( false, false ) )
	local trapName = m_boulder_info[index].npc_name
	local npc = Entities:FindByName( nil, trapName )
	m_boulder_info[index].isBoulderReady = true

	local opposingTeam = DOTA_TEAM_BADGUYS
	if team == DOTA_TEAM_BADGUYS then
		opposingTeam = DOTA_TEAM_GOODGUYS
	end

	local bHasAllies = tablehaselements( m_boulder_info[index].touchers[team] )
	local bHasEnemies = tablehaselements( m_boulder_info[index].touchers[opposingTeam] )

	if bHasAllies and bHasEnemies then
		print("Boulder button is blocked")
		EmitGlobalSound("Conquest.TrapButton.Blocked")
	elseif bHasAllies or bHasEnemies then
		--Activate the trap
		local trapName = m_boulder_info[index].npc_name
		local npc = Entities:FindByName( nil, trapName )
		local remainingTeam = team
		if bHasEnemies then remainingTeam = opposingTeam end
		npc.KillerToCredit = tablefirstkey( m_boulder_info[index].touchers[remainingTeam] )
		print("Reactivate"..trapName.." because "..npc.KillerToCredit:GetName().." is still standing on it")
		npc:SetContextThink( "EnableBoulderTrap", function() return CConquestGameMode:EnableBoulder( index, remainingTeam ) end, 0 )
	end

	return -1;
end

function CConquestGameMode:SetBoulderIsFalling( index, value )
	local textValue = "false"
	if value then textValue = "true" end
	print("Setting boulder "..index.." to falling value of "..textValue.." at "..GameRules:GetDOTATime( false, false ))
	m_boulder_info[index].isBoulderFalling = value
end
