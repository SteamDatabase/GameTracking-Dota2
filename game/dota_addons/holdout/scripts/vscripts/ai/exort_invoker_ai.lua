--[[ Exort InvokerAI ]]
require( "ai/invoker_shared_ai" )

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "ExortInvokerThink", ExortInvokerThink, 0.25 )
	
		s_Quas  = thisEntity:FindAbilityByName( "invoker_quas" )
		s_Wex = thisEntity:FindAbilityByName( "invoker_wex" )
		s_Exort  = thisEntity:FindAbilityByName( "invoker_exort" )
		s_SunStrike = thisEntity:FindAbilityByName( "invoker_sun_strike" )
		s_IceWall = thisEntity:FindAbilityByName( "invoker_ice_wall" )
		s_Meteor = thisEntity:FindAbilityByName( "invoker_chaos_meteor" )
		s_ForgedSpirit = thisEntity:FindAbilityByName( "invoker_forge_spirit" )
		s_Invoke = thisEntity:FindAbilityByName( "invoker_invoke" )

		s_Euls = nil
		s_Blink = nil

		s_ActiveSpell1 = nil
		s_ActiveSpell2 = nil
		s_ChangeSpellQueue = {}
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
		end
	end
end

function ExortInvokerThink()
	if IsServer() then
		if GameRules:IsGamePaused() then
			return 0.1 
		end

		if thisEntity:IsAlive() == false then
			return 0.1
		end

		local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
		for _,forgedSpirit in pairs( Entities:FindAllByName( "npc_dota_invoker_forged_spirit" ) ) do
			if forgedSpirit ~= nil and forgedSpirit:GetAggroTarget() == nil then
				ExecuteOrderFromTable({
					UnitIndex = forgedSpirit:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					Position = hAncient:GetOrigin(),
				})
			end
		end

		if s_Euls == nil or s_Blink == nil then
			FindItems()
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

		if s_ActiveSpell2:IsFullyCastable() then
			if s_ActiveSpell2 == s_SunStrike and CheckToCastSunStrike( thisEntity, s_ActiveSpell2 ) == true then
				CastSunStrike( thisEntity, s_ActiveSpell2 )
				return 0.1
			end

			if s_ActiveSpell2 == s_IceWall and CheckToCastIceWall( thisEntity, s_ActiveSpell2 ) == true then
				CastIceWall( thisEntity, s_ActiveSpell2 )
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
		end

		if s_ActiveSpell1:IsFullyCastable() then
			if s_ActiveSpell1 == s_IceWall and CheckToCastIceWall( thisEntity, s_ActiveSpell1 ) == true then
				CastIceWall( thisEntity, s_ActiveSpell1 )
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
		end

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
			if s_ActiveSpell1:GetAbilityName() == "invoker_empty1" or CheckToInvoke( s_ForgedSpirit ) then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if s_ActiveSpell2:GetAbilityName() == "invoker_empty1" or CheckToInvoke( s_Meteor ) then
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Wex )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_IceWall ) == true then
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Quas )
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Invoke )
				return 0.1
			end

			if CheckToInvoke( s_SunStrike )  then
				table.insert( s_ChangeSpellQueue, s_Exort )
				table.insert( s_ChangeSpellQueue, s_Exort )
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

	if spell == s_Meteor then
		return CheckToCastMeteor( thisEntity, spell  )
	end

	if spell == s_SunStrike then
		return CheckToCastSunStrike( thisEntity, spell  )
	end

	if spell == s_IceWall then
		return CheckToCastIceWall( thisEntity, spell  )
	end

	if spell == s_ForgedSpirit then
		return CheckToCastForgedSpirit( thisEntity, spell )
	end

	return false
end

