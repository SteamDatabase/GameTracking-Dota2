require( "ai/basic_spell_casting_ai" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	OverwhelmingOdds = thisEntity:FindAbilityByName( "aghsfort_stonehall_general_overwhelming_odds" )
	if OverwhelmingOdds then
		OverwhelmingOdds:StartCooldown( 6.0 ) 
	end
	PressTheAttack = thisEntity:FindAbilityByName( "stonehall_general_press_the_attack" )
	if PressTheAttack then
		PressTheAttack:StartCooldown( 12.0 ) 
	end
	Duel = thisEntity:FindAbilityByName( "stonehall_general_duel" )

	Blink = thisEntity:FindItemInInventory( "item_blink" )


	thisEntity.hAttacker = nil
	thisEntity.bBlinkedOut = false
	thisEntity.bDueledAttacker = false 
	thisEntity.flNextAggroTime = 0
	thisEntity.flAggroTimer = 30.0
	thisEntity.bTriggerBreached = false 
	
	
	thisEntity.nEntityHurtEvent = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityHurt' ), nil )
	thisEntity.nAbilityListener = ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnNonPlayerUsedAbility' ), nil )
	thisEntity:SetContextThink( "StonehallGeneralThink", StonehallGeneralThink, 1 )
end


--------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.nEntityHurtEvent )
	StopListeningToGameEvent( thisEntity.nAbilityListener )
end

--------------------------------------------

function StonehallGeneralThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsChanneling() then 
		return 0.1 
	end

	local Enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #Enemies == 0 then 
		return 0.1 
	end

	if thisEntity.vHomeLoc == nil then 
		thisEntity.vHomeLoc = thisEntity:GetAbsOrigin()
	end

	local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
	if OverwhelmingOdds and OverwhelmingOdds:IsCooldownReady() then 
		return CastOverwhelmingOdds( hRandomEnemy:GetAbsOrigin() )
	end

	if thisEntity.bTriggerBreached == false then 
		if thisEntity.hAttacker ~= nil then
			if thisEntity.hAttacker:IsAlive() == false then 
				thisEntity.hAttacker = nil
				thisEntity.bBlinkedOut = false
				thisEntity.bDueledAttacker = false 
				
				Blink:EndCooldown()
				return CastBlink( thisEntity.vHomeLoc )
			end

			if thisEntity.bBlinkedOut == false then 
				Blink:EndCooldown()
				if thisEntity.bDueledAttacker == false then
					return CastBlink( thisEntity.hAttacker:GetAbsOrigin() )
				else
					return CastBlink( thisEntity.vHomeLoc )
				end
			end

			if thisEntity.bDueledAttacker == false and Duel and Duel:IsCooldownReady() then 
				return CastDuel( thisEntity.hAttacker )
			end
		else
			local flDistFromHome = ( thisEntity:GetAbsOrigin() - thisEntity.vHomeLoc ):Length2D()
			if flDistFromHome > 500 then 
				thisEntity.hAttacker = nil
				thisEntity.bBlinkedOut = false
				thisEntity.bDueledAttacker = false 
				thisEntity.bBladeMailed = false
				Blink:EndCooldown()
				return CastBlink( thisEntity.vHomeLoc )
			end
		end
	end
	

	if Duel and Duel:IsCooldownReady() then 
		local flDist = ( Enemies[1]:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
		if flDist <= 250 then 
			return CastDuel( Enemies[1] )
		end
	end

	

	if PressTheAttack and PressTheAttack:IsCooldownReady() then 
		local vPosition = GetTargetAOELocation( thisEntity:GetTeamNumber(), 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  					
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											hRandomEnemy:GetOrigin(),
											600,
											400,
											3 )

		if vPosition ~= vec3_invalid then 
			return CastPressTheAttack( vPosition )
		end
	end

	

	return 0.1
end

--------------------------------------------

function CastDuel( hEnemy )
	thisEntity:RemoveModifierByName( "modifier_rooted_unpurgable" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = Duel:entindex(),
		Queue = false,
	})

	return 1.0
end

--------------------------------------------

function CastOverwhelmingOdds( vPosition )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = OverwhelmingOdds:entindex(),
		Queue = false,
	})
	return 1.2
end

--------------------------------------------

function CastPressTheAttack( vPosition )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = PressTheAttack:entindex(),
		Queue = false,
	})
	return 1.2
end

--------------------------------------------

function CastBlink( vPosition )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = Blink:entindex(),
		Queue = false,
	})
	return 0.25
end


--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function OnEntityHurt( event )

	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	local hAttacker = nil 
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if hAttacker == nil or hAttacker:IsRealHero() == false then 
		return 
	end

	if thisEntity.hAttacker ~= nil then 
		return 
	end

	if thisEntity.flNextAggroTime > GameRules:GetGameTime() then
		return
	end

	thisEntity.flNextAggroTime = GameRules:GetGameTime() + thisEntity.flAggroTimer

	thisEntity:RemoveModifierByName( "modifier_rooted_unpurgable" )

	thisEntity.hAttacker = hAttacker 
	thisEntity.bBlinkedOut = false
	thisEntity.bDueledAttacker = false
end

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------

function OnNonPlayerUsedAbility( event )
	local hCaster = nil
	if event.caster_entindex ~= nil and event.abilityname ~= nil then
		hCaster = EntIndexToHScript( event.caster_entindex )
		if hCaster ~= nil and hCaster == thisEntity then
			if thisEntity.hAttacker == nil then 
				return 
			end

			if event.abilityname == "item_blink" and thisEntity.bBlinkedOut == false then 
				if thisEntity.bDueledAttacker then 
					thisEntity.hAttacker = nil 
					thisEntity.bDueledAttacker = false
				
					thisEntity:AddNewModifier( thisEntity, nil, "modifier_rooted_unpurgable", { duration = -1 } )
				else
					thisEntity.bBlinkedOut = true 
				end
				return
			end

			if event.abilityname == "stonehall_general_duel" and thisEntity.bDueledAttacker == false then 
				thisEntity.bDueledAttacker = true 
				thisEntity.bBlinkedOut = false
				return
			end

		end
	end
end