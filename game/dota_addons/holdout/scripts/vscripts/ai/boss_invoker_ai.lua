--[[ Exort InvokerAI ]]
require( "ai/invoker_shared_ai" )

PHASE_NONE = -1
PHASE_QUAS = 0
PHASE_WEX = 1
PHASE_EXORT = 2

TAUNT_RATE = 20.0
SPEECH_COOLDOWN = 3.0

TRIGGER_PHASE_CD = 30

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BossInvokerThink", BossInvokerThink, 0.25 )
	
		s_Quas  = thisEntity:FindAbilityByName( "invoker_quas" )
		s_Wex = thisEntity:FindAbilityByName( "invoker_wex" )
		s_Exort  = thisEntity:FindAbilityByName( "invoker_exort" )
		
		s_DeafeningBlast = thisEntity:FindAbilityByName( "invoker_deafening_blast" )
		s_SunStrike = thisEntity:FindAbilityByName( "invoker_sun_strike" )
		s_Meteor = thisEntity:FindAbilityByName( "invoker_chaos_meteor" )
		s_ForgedSpirit = thisEntity:FindAbilityByName( "invoker_forge_spirit" )
		s_Tornado = thisEntity:FindAbilityByName( "invoker_tornado" )
		s_IceWall = thisEntity:FindAbilityByName( "invoker_ice_wall" )
		s_ColdSnap = thisEntity:FindAbilityByName( "invoker_cold_snap" )
		s_GhostWalk = thisEntity:FindAbilityByName( "invoker_ghost_walk" )
		s_EMP = thisEntity:FindAbilityByName( "invoker_emp" )
		s_Alacrity = thisEntity:FindAbilityByName( "invoker_alacrity" )
		s_Invoke = thisEntity:FindAbilityByName( "invoker_invoke" )

		s_MegaForgedSpirit = thisEntity:FindAbilityByName( "invoker_dark_moon_forge_spirit" )
		s_MegaIceWall = thisEntity:FindAbilityByName( "invoker_dark_moon_ice_wall" )
		s_MegaSunStrike = thisEntity:FindAbilityByName( "invoker_dark_moon_sun_strike" )
		s_MegaMeteor = thisEntity:FindAbilityByName( "invoker_dark_moon_meteor" )
		s_MegaTornado = thisEntity:FindAbilityByName( "invoker_dark_moon_tornado" )
		s_MegaEMP = thisEntity:FindAbilityByName( "invoker_dark_moon_emp" )
		s_MegaGhostWalk = thisEntity:FindAbilityByName( "invoker_dark_moon_ghost_walk" )

		s_Euls = nil
		s_Blink = nil
		s_Sheep = nil

		thisEntity.Phase = PHASE_NONE
		s_HighestPhaseReached = PHASE_NONE
		s_nQuasPhaseChangeHP = 75
		s_nWexPhaseChangeHP = 50
		s_nExortPhaseChangeHP = 25

		s_ActiveSpell1 = nil
		s_ActiveSpell2 = nil
		s_ChangeSpellQueue = {}

		EmitGlobalSound( "invoker_invo_inthebag_01" )
		thisEntity.flSpeechCooldown = GameRules:GetGameTime() + SPEECH_COOLDOWN
		s_flNextLaughTime = GameRules:GetGameTime() + TAUNT_RATE
	end
end

function FindItems()
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_cyclone" then
				s_Euls = item
			end
			if item:GetAbilityName() == "item_blink" then
				s_Blink = item
			end
			if item:GetAbilityName() == "item_sheepstick" then
				s_Sheep = item
			end
		end
	end
end

function CheckToChangePhase()             
	if ( thisEntity:GetHealthPercent() < s_nQuasPhaseChangeHP ) and ( thisEntity:GetHealthPercent() > s_nWexPhaseChangeHP ) and ( s_HighestPhaseReached < PHASE_QUAS ) then
		s_HighestPhaseReached = PHASE_QUAS
		return PHASE_QUAS
	elseif ( thisEntity:GetHealthPercent() < s_nWexPhaseChangeHP ) and ( thisEntity:GetHealthPercent() > s_nExortPhaseChangeHP ) and ( s_HighestPhaseReached < PHASE_WEX ) then
		s_HighestPhaseReached = PHASE_WEX
		return PHASE_WEX
	elseif ( thisEntity:GetHealthPercent() < s_nExortPhaseChangeHP ) and ( s_HighestPhaseReached < PHASE_EXORT ) then
		s_HighestPhaseReached = PHASE_EXORT
		return PHASE_EXORT
	end

	return thisEntity.Phase
end

function BossInvokerThink()
	if IsServer() then
		if GameRules:IsGamePaused() then
			return 0.1 
		end

		if thisEntity:IsAlive() == false then
			return 0.1
		end

		local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
		for _,forgedSpirit in pairs( Entities:FindAllByName( "npc_dota_creature_invoker_forged_spirit" ) ) do
			if forgedSpirit ~= nil and forgedSpirit:GetAggroTarget() == nil then
				ExecuteOrderFromTable({
					UnitIndex = forgedSpirit:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					Position = hAncient:GetOrigin(),
				})
			end
		end

		if s_Euls == nil or s_Blink == nil or s_Sheep == nil then
			FindItems()
		end

		if GameRules:GetGameTime() > s_flNextLaughTime then
			TauntPlayers()
			s_flNextLaughTime = s_flNextLaughTime + TAUNT_RATE
		end

		local lastPhase = thisEntity.Phase
		thisEntity.Phase = CheckToChangePhase()

		-- Come back later if we're changing phase
		if lastPhase ~= thisEntity.Phase then
			return TRIGGER_PHASE_CD --20.0
		end

		s_ActiveSpell1 = thisEntity:GetAbilityByIndex( 3 )
		s_ActiveSpell2 = thisEntity:GetAbilityByIndex( 4 )

		if CheckToCastEuls( thisEntity, s_Euls ) == true then
			CastEuls( thisEntity, s_Euls)
			return 0.1
		end

		if CheckToCastBlink( thisEntity, s_Blink ) == true then
			CastBlink( thisEntity, s_Blink )
			return 0.1
		end

		if CheckToCastSheep( thisEntity, s_Sheep ) == true then
			CastSheep( thisEntity, s_Sheep )
			return 0.1
		end

		NormalSpellThink()

		return InvokeThink()
	end

	return 0.1
end

function InvokeThink()
	if IsServer() then
		if #s_ChangeSpellQueue > 0 then
			local spell = s_ChangeSpellQueue[1]
			if spell == nil or spell:IsCooldownReady() == false then
				return 0.1
			end
			if s_ChangeSpellQueue ~= nil then
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = spell:entindex()
				})
				table.remove( s_ChangeSpellQueue, 1 )
			end
			return 0.1
		else

			if CheckToInvoke( s_DeafeningBlast ) then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_Tornado ) then
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_ColdSnap ) then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			--[[
			if CheckToInvoke( s_ForgedSpirit ) then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end
			]]

			if CheckToInvoke( s_Meteor ) then
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_SunStrike ) then
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end	

			if CheckToInvoke( s_EMP ) then
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_IceWall ) then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_Alacrity ) then
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end
		end 
	end
	
	return 0.1
end


function CheckToInvoke( spell )
	if spell == s_ActiveSpell1 or spell == s_ActiveSpell2 then
		return false
	end

	if spell:IsCooldownReady() == false then
		return false
	end

	if spell == s_ColdSnap then
		return CheckToCastColdSnap( thisEntity, spell )
	end

	if spell == s_DeafeningBlast then
		return CheckToCastDeafeningBlast( thisEntity, spell )
	end

	if spell == s_Tornado then
		return CheckToCastTornado( thisEntity, spell )
	end

	if spell == s_IceWall then
		return CheckToCastIceWall( thisEntity, spell )
	end

	if spell == s_Meteor then
		return CheckToCastMeteor( thisEntity, spell  )
	end

	if spell == s_SunStrike then
		return CheckToCastSunStrike( thisEntity, spell  )
	end

	if spell == s_ForgedSpirit then
		return CheckToCastForgedSpirit( thisEntity, spell )
	end

	if spell == s_Alacrity then
		return CheckToCastAlacrity( thisEntity, spell )
	end

	if spell == s_EMP then
		return CheckToCastEMP( thisEntity, spell )
	end


	return false
end

function NormalSpellThink()
	if s_ActiveSpell2:IsFullyCastable() then
		if s_ActiveSpell2 == s_DeafeningBlast and CheckToCastDeafeningBlast( thisEntity, s_ActiveSpell2 ) == true then
			CastDeafeningBlast( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_ColdSnap and CheckToCastColdSnap( thisEntity, s_ActiveSpell2 ) == true then
			CastColdSnap( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_SunStrike and CheckToCastSunStrike( thisEntity, s_ActiveSpell2 ) == true then
			CastSunStrike( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_IceWall and CheckToCastIceWall( thisEntity, s_ActiveSpell2 ) == true then
			CastIceWall( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_Alacrity and CheckToCastAlacrity( thisEntity, s_ActiveSpell2 ) == true then
			CastAlacrity( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_Meteor and CheckToCastMeteor( thisEntity, s_ActiveSpell2 ) == true then
			CastMeteor( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_ForgedSpirit and CheckToCastForgedSpirit( thisEntity, s_ActiveSpell2 ) == true then
			CastForgedSpirit( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_EMP and CheckToCastEMP( thisEntity, s_ActiveSpell2 ) == true then
			CastEMP( thisEntity, s_ActiveSpell2 )
			return 0.1
		end

		if s_ActiveSpell2 == s_Tornado and CheckToCastTornado( thisEntity, s_ActiveSpell2 ) == true then
			CastTornado( thisEntity, s_ActiveSpell2 )
			return 0.1
		end
	end

	if s_ActiveSpell1:IsFullyCastable() then
		if s_ActiveSpell1 == s_DeafeningBlast and CheckToCastDeafeningBlast( thisEntity, s_ActiveSpell1 ) == true then
			CastDeafeningBlast( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_IceWall and CheckToCastIceWall( thisEntity, s_ActiveSpell1 ) == true then
			CastIceWall( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_ColdSnap and CheckToCastColdSnap( thisEntity, s_ActiveSpell1 ) == true then
			CastColdSnap( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_SunStrike and CheckToCastSunStrike( thisEntity, s_ActiveSpell1 ) == true then
			CastSunStrike( thisEntity, s_ActiveSpell1)
			return 0.1
		end

		if s_ActiveSpell1 == s_Meteor and CheckToCastMeteor( thisEntity, s_ActiveSpell1 ) == true then
			CastMeteor( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_ForgedSpirit and CheckToCastForgedSpirit( thisEntity, s_ActiveSpell1 ) == true then
			CastForgedSpirit( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_EMP and CheckToCastEMP( thisEntity, s_ActiveSpell1 )  then
			CastEMP( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_Tornado and CheckToCastTornado( thisEntity, s_ActiveSpell1 ) == true then
			CastTornado( thisEntity, s_ActiveSpell1 )
			return 0.1
		end

		if s_ActiveSpell1 == s_Alacrity and CheckToCastAlacrity( thisEntity, s_ActiveSpell1 ) == true then
			CastAlacrity( thisEntity, s_ActiveSpell1 )
			return 0.1
		end		
	end
end


function TauntPlayers()
	if thisEntity.flSpeechCooldown > GameRules:GetGameTime() then
		return
	end

	thisEntity.flSpeechCooldown = GameRules:GetGameTime()  + SPEECH_COOLDOWN
	local nTaunt = RandomInt( 0, 9 )
	if nTaunt == 0 then
		EmitGlobalSound( "invoker_invo_attack_04" )
	end
	if nTaunt == 1 then
		EmitGlobalSound( "invoker_invo_attack_05" )
	end
	if nTaunt == 2 then
		EmitGlobalSound( "invoker_invo_attack_06" )
	end
	if nTaunt == 3 then
		EmitGlobalSound( "invoker_invo_attack_10" )
	end
	if nTaunt == 4 then
		EmitGlobalSound( "invoker_invo_attack_12" )
	end
	if nTaunt == 5 then
		EmitGlobalSound( "invoker_invo_deny_10" )
	end
	if nTaunt == 6 then
		EmitGlobalSound( "invoker_invo_deny_11" )
	end
	if nTaunt == 7 then
		EmitGlobalSound( "invoker_invo_kill_14" )
	end
	if nTaunt == 8 then
		EmitGlobalSound( "invoker_invo_kill_15" )
	end
	if nTaunt == 9 then
		EmitGlobalSound( "invoker_invo_kill_16" )
	end
	if nTaunt == 10 then
		EmitGlobalSound( "invoker_invo_kill_17" )
	end
	if nTaunt == 11 then
		EmitGlobalSound( "invoker_invo_kill_18" )
	end
	if nTaunt == 12 then
		EmitGlobalSound( "invoker_invo_kill_19" )
	end
end
