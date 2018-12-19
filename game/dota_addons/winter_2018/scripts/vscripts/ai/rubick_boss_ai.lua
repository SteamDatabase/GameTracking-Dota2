require( "ai/basic_spell_casting_ai" )

bRubickDebug = false

TAUNT_RATE = 20.0
SPEECH_COOLDOWN = 3.0

MAX_SPELL_STEAL_BEHAVIOR_TIME = 20

_G.TRIGGER_PHASE_CD = 30
_G.PHASE_DURATION = 20
_G.RUBICK_PHASES =
{
	NORMAL = 1,
	TELEKINESIS = 2,
	FADE_BOLTS = 3,
	SPELL_STEAL = 4,
	INSANE = 5,
}

_G.STOLEN_SPELL_CASTTIME_MOD =
{
	1.75,
	1.5,
	1.25,
	1.0,
}


--Put post spell cast behaviors here.  return true to continue processing AI in conjunction with this behavior, false if this the only thing we should be doing
SPELL_BEHAVIORS =
{
	lone_druid_true_form = function()
		local ReturnToDruidAbility = thisEntity:FindAbilityByName( "lone_druid_true_form_druid" )
		if ReturnToDruidAbility ~= nil then
			ReturnToDruidAbility:StartCooldown( 20 )
			s_flSpellBehaviorReleaseTime = 0
		end
		return true
	end,
	
	pangolier_gyroshell_winter = function()
		if s_StolenSpellToCast ~= nil and thisEntity:FindModifierByName( "modifier_pangolier_gyroshell" ) ~= nil then
			local hTarget = GetBestUnitTarget( s_FadeBolt )
			if hTarget ~= nil then
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = hTarget:GetOrigin(),
				})
				return false
			end
		else
			s_flSpellBehaviorReleaseTime = 0
		end
		return true
	end,

	frostivus2018_centaur_stampede = function()
		if thisEntity.bHasDoneStampedeNonPlayerFix == nil then
			local hStampede = thisEntity:FindAbilityByName( "frostivus2018_centaur_stampede" )
			if hStampede then
				thisEntity.bHasDoneStampedeNonPlayerFix = true
				thisEntity:AddNewModifier( thisEntity, hStampede, "modifier_centaur_stampede", { duration = hStampede:GetSpecialValueFor( "duration" ) * 2 } )
				thisEntity.StampedeTargets = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			end
		end
		if thisEntity:FindModifierByName( "modifier_centaur_stampede" ) ~= nil then
			if thisEntity.hStampedeTarget == nil then
				print( "centaur_stampede: I have " .. #thisEntity.StampedeTargets .. " stampede targets" )
				for k,Target in pairs ( thisEntity.StampedeTargets ) do
					if Target ~= nil and thisEntity.hStampedeTarget == nil then
						if bRubickDebug then
							print ( "centaur_stampede: Assign target" .. Target:GetUnitName() )
						end
						thisEntity.hStampedeTarget = Target
						table.remove( thisEntity.StampedeTargets, k )
					end
				end
			end

			if thisEntity.hStampedeTarget:IsAlive() == false or thisEntity.hStampedeTarget:FindModifierByName( "modifier_centaur_stampede_slow" ) ~= nil then
				thisEntity.hStampedeTarget = nil
				print( "centaur_stampede: I hit my target, find a new one" )
			else
				if bRubickDebug then
					print ( "centaur_stampede: Run towards " .. thisEntity.hStampedeTarget:GetUnitName() )
				end
				ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = thisEntity.hStampedeTarget:GetOrigin(),
					})
				
			end
			return false
		else
			s_flSpellBehaviorReleaseTime = 0
			thisEntity.hStampedeTarget = nil
			thisEntity.bHasDoneStampedeNonPlayerFix = nil
			thisEntity.StampedeTargets = nil
		end
		return true
	end,

	weaver_shukuchi = function()
		if thisEntity:FindModifierByName( "modifier_weaver_shukuchi" ) then
			if thisEntity.ShkuchiTargets == nil then
				thisEntity.ShkuchiTargets = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			end

			if #thisEntity.ShkuchiTargets == 0 then
				s_flSpellBehaviorReleaseTime = 0
				thisEntity.hShukuchiTarget = nil
				thisEntity.ShkuchiTargets = nil
				return true
			end

			if thisEntity.hShukuchiTarget == nil then
				thisEntity.hShukuchiTarget = thisEntity.ShkuchiTargets[1]
				table.remove( thisEntity.ShkuchiTargets, 1 )
			end

			if thisEntity.hShukuchiTarget ~= nil then
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = thisEntity.hShukuchiTarget:GetOrigin(),
				})

				local flDist = ( thisEntity.hShukuchiTarget:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist < 175 then
					thisEntity.hShukuchiTarget = nil
				end
			end

			return false
		else
			s_flSpellBehaviorReleaseTime = 0
			thisEntity.hShukuchiTarget = nil
			thisEntity.ShkuchiTargets = nil
		end
		return true
	end,

	monkey_king_tree_dance = function()
		local MAX_TREE_JUMPS = 3

		local hSpringAbility = thisEntity:FindAbilityByName( "monkey_king_primal_spring" )
		local hTreeDanceAbility = thisEntity:FindAbilityByName( "monkey_king_tree_dance" )
		if hSpringAbility then
			local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			local tree = FindTreeTarget( hTreeDanceAbility )
			if #enemies == 0 then
				-- no enemies.  if i have a tree, do a jump,but only a few times.
				if tree ~= nil and s_nSpellBehaviorCasts < MAX_TREE_JUMPS then
					CastSpellTreeTarget( hTreeDanceAbility, tree )
				else
					--Walk off
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = thisEntity:GetOrigin() + RandomVector( 25 ),
					})
					s_flSpellBehaviorReleaseTime = 0
					return true
				end
			else
				local nRoll = RandomInt( 1, 2 )
				-- Sometimes even if an enemy is in range, do a tree jump anyway
				if tree ~= nil and s_nSpellBehaviorCasts < MAX_TREE_JUMPS and nRoll == 1 then
					CastSpellTreeTarget( hTreeDanceAbility, tree )
				else
					local hEnemy = enemies[RandomInt(1,#enemies)]
					if hEnemy ~= nil then
						CastSpellPointTarget( hSpringAbility, hEnemy:GetOrigin() )
					end
				end
			end
			return false
		else
			s_flSpellBehaviorReleaseTime = 0
		end

		return true
	end,

	pugna_life_drain = function()
		if s_nSpellBehaviorCasts > 2 then
			s_flSpellBehaviorReleaseTime = 0
		else
			if s_StolenSpellToCast ~= nil and s_StolenSpellToCast:IsFullyCastable() then
				local hTarget = GetBestUnitTarget( s_StolenSpellToCast )
				if hTarget ~= nil then
					CastSpellUnitTarget( s_StolenSpellToCast, hTarget )
				end
			end
		end
		return true
	end,

	-- frostivus2018_dark_willow_shadow_realm = function()
	-- 	if thisEntity:FindModifierByName( "frostivus2018_modifier_dark_willow_shadow_realm_buff" ) ~= nil then
	-- 		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	-- 		if #enemies > 0 then
	-- 			ExecuteOrderFromTable({
	-- 				UnitIndex = thisEntity:entindex(),
	-- 				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
	-- 				TargetIndex = enemies[1]:GetOrigin(),
	-- 			})
	-- 		end
	-- 	else
	-- 		s_flSpellBehaviorReleaseTime = 0
	-- 	end
	-- 	return true
	-- end,

	-- windrunner_focusfire = function()
	-- 	local hModifier = thisEntity:FindModifierByName( "modifier_windrunner_focusfire" )
	-- 	if hModifier and hModifier:GetCreationTime() + 7.0 > GameRules:GetGameTime()  then
	-- 		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	-- 		if #enemies > 0 and enemies[1] ~= nil then
	-- 			local vToClosest = enemies[1]:GetOrigin() - thisEntity:GetOrigin()
	-- 			local flDist = vToClosest:Length2D()

	-- 			if flDist > thisEntity:GetAttackRange() then
	-- 				ExecuteOrderFromTable({
	-- 					UnitIndex = thisEntity:entindex(),
	-- 					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	-- 					Position = thisEntity.hStampedeTarget:GetOrigin(),
	-- 				})
	-- 			else
	-- 				ExecuteOrderFromTable({
	-- 					UnitIndex = hSpell:GetCaster():entindex(),
	-- 					OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
	-- 					TargetIndex = hTree:entindex(),
	-- 					AbilityIndex = hSpell:entindex(),
	-- 				})
	-- 			end
	-- 			return true
	-- 		end
	-- 	end

	-- 	s_flSpellBehaviorReleaseTime = 0
	-- 	return true
		
	-- end,

	puck_illusory_orb = function()
		local hJaunt = thisEntity:FindAbilityByName( "puck_ethereal_jaunt" )
		if hJaunt == nil then
			thisEntity.flTimeToCastEtherealJaunt = nil
			s_flSpellBehaviorReleaseTime = 0
			return true
		end

		if thisEntity.flTimeToCastEtherealJaunt == nil then
			hJaunt:StartCooldown( 1.5 )
			thisEntity.flTimeToCastEtherealJaunt = GameRules:GetGameTime() + 1.5
		else
			if GameRules:GetGameTime() > thisEntity.flTimeToCastEtherealJaunt then
				hJaunt:EndCooldown()
				CastSpellNoTarget( hJaunt )
				s_flSpellBehaviorReleaseTime = 0
				thisEntity.flTimeToCastEtherealJaunt = nil	
			end
		end

		return true
	end,
}

BLACKLISTED_ABILITIES =
{
	"troll_warlord_berserkers_rage",
	"sandking_sand_storm",
	"keeper_of_the_light_illuminate",
	"frostivus2018_dark_willow_shadow_realm",
	"pugna_life_drain",
}

function IsAbilityBlacklisted( szAbilityName )
	for _,szName in pairs( BLACKLISTED_ABILITIES ) do
		if szAbilityName == szName then
			return true
		end
	end

	return false
end

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "BossRubickThink", BossRubickThink, 0.25 )	

		s_Telekinesis = thisEntity:FindAbilityByName( "rubick_telekinesis" )
		s_TelekinesisLand = thisEntity:FindAbilityByName( "rubick_telekinesis_land" )
		s_FadeBolt = thisEntity:FindAbilityByName( "rubick_boss_fade_bolt" )
		s_Blink = thisEntity:FindAbilityByName( "rubick_boss_blink" )
		s_SpellSteal = thisEntity:FindAbilityByName( "rubick_boss_spell_steal" )

		thisEntity:AddItemByName( "item_octarine_core" )

		if GameRules.holdOut._bBossHasSpawned == false then
			EmitGlobalSound( "rubick_rub_arc_spawn_01" )
		end

		thisEntity.flSpeechCooldown = GameRules:GetGameTime() + SPEECH_COOLDOWN
		s_flNextLaughTime = GameRules:GetGameTime() + TAUNT_RATE

		thisEntity.Phase = RUBICK_PHASES.NORMAL
		s_flNextPhaseCheckTime = 0
		s_HighestPhaseReached = RUBICK_PHASES.NORMAL

		s_StolenSpellToCast = nil
		s_SpellBehavior = nil
		s_flSpellBehaviorReleaseTime = 0
		s_nSpellBehaviorCasts = 0
		s_hPrioritySpellStealTarget = nil
		s_szRecentStolenSpells = {}
		thisEntity.hForceCastStolenSpell = nil

		thisEntity:SetIdleAcquire( true )

		if bRubickDebug then
			print( "Blacklisted spells:" )
			for _,szName in pairs( BLACKLISTED_ABILITIES ) do
				print( szName )
			end
		end
		
		thisEntity.SpellCastResult = function( szName )
			--print( "I just used " .. szName )
			if szName == "rubick_boss_spell_steal" then
				s_hPrioritySpellStealTarget = nil
				if bRubickDebug then
					print( "I stole!  Reset my steal priority." )
				end
			end

			local funcBehavior = SPELL_BEHAVIORS[szName]		
			if funcBehavior ~= nil then
				-- this is a different spell
				if funcBehavior ~= s_SpellBehavior then
					if bRubickDebug then
						print( "Setting new behavior for " .. szName )
					end
					s_SpellBehavior = funcBehavior
					s_nSpellBehaviorCasts = 1
					s_flSpellBehaviorReleaseTime = GameRules:GetGameTime() + MAX_SPELL_STEAL_BEHAVIOR_TIME --ensures the behavior will go off once.
				else -- this is the same spell i already have
					s_nSpellBehaviorCasts = s_nSpellBehaviorCasts + 1
					if bRubickDebug then
						print( "Casted " .. szName .. " " .. s_nSpellBehaviorCasts .. " times." )
					end
				end
			end
		end

		thisEntity.EnemySpellCastResult = function ( hCaster, szName )
			if hCaster == nil or szName == nil then
				return
			end

			if bRubickDebug then
				print( hCaster:GetUnitName() .. " enemy just cast " .. szName )
				if #s_szRecentStolenSpells > 0 then
					print( "Let's see.. I've recently stolen:" )
					for k,v in pairs( s_szRecentStolenSpells ) do
						print( "--" .. v )
					end
				end
			end

			local hAbility = hCaster:FindAbilityByName( szName )
			if hAbility == nil then
				if bRubickDebug then
					print( "ability does not exist" )
				end
				return
			end

			if IsAbilityBlacklisted( szName ) then
				if bRubickDebug then
					print( "ability is blacklisted" )
				end
				return
			end

			local bHasStolenSpellRecently = false
			for _,szSpell in pairs( s_szRecentStolenSpells ) do
				if szSpell ~= nil and szSpell == szName then
					bHasStolenSpellRecently = true
				end
			end

			--Prioritize ultimates
			if hAbility:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
				if bRubickDebug then
					print( "--Setting new priority to steal " .. szName .. " from " .. hCaster:GetUnitName() .. " ultimate" )
				end
				s_hPrioritySpellStealTarget = hCaster
				return
			end

			if bHasStolenSpellRecently then
				if bRubickDebug then
					print( "Ignoring, I already stole from this guy" )
				end
				return
			end

			if s_hPrioritySpellStealTarget == nil then
				s_hPrioritySpellStealTarget = hCaster
				print( "--Setting new priority to steal " .. szName .. " from " .. hCaster:GetUnitName() )
			end
		end
	end
end


function CheckToChangePhase()             
	local OldPhase = thisEntity.Phase
	local NewPhase = thisEntity.Phase
	local nHealthPct = thisEntity:GetHealthPercent()

	if nHealthPct > 85 then
		NewPhase = RUBICK_PHASES.NORMAL
	end
	if nHealthPct <= 85 and nHealthPct > 66 then
		NewPhase = RUBICK_PHASES.TELEKINESIS
	end
	if nHealthPct <= 66 and nHealthPct > 35 then
		NewPhase = RUBICK_PHASES.FADE_BOLTS
	end
	if nHealthPct <= 35 and nHealthPct > 15 then
		NewPhase = RUBICK_PHASES.SPELL_STEAL
	end
	if nHealthPct <= 15 then
		NewPhase = RUBICK_PHASES.INSANE
	end

	if NewPhase < s_HighestPhaseReached then
		NewPhase = s_HighestPhaseReached
	end

	if NewPhase > s_HighestPhaseReached then
		s_HighestPhaseReached = NewPhase
		if NewPhase == RUBICK_PHASES.INSANE then
			thisEntity:AddItemByName( "item_ultimate_scepter" )
		end
	end

	thisEntity.Phase = NewPhase
	return OldPhase ~= NewPhase
end


function BossRubickThink()
	if IsServer() then
		if GameRules:IsGamePaused() then
			return 0.1 
		end

		if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
			if bRubickDebug then
				print( "I'm doing nothing, I'm dead or got deleted" )
			end
			return 0.1
		end

		if thisEntity:FindModifierByName( "modifier_monkey_king_fur_army_soldier" ) then
			print( "I'm a wukong soldier from a stolen ult, never think again") 
			return -1
		end

		if GameRules:GetGameTime() > s_flNextLaughTime then
			TauntPlayers()
			s_flNextLaughTime = s_flNextLaughTime + TAUNT_RATE
		end

		if thisEntity:IsChanneling() then
			if bRubickDebug then
				print( "I'm doing nothing, because I'm channeling" )
			end
			return 0.1
		end

		-- Come back later if we're changing phase
		if GameRules:GetGameTime() > s_flNextPhaseCheckTime and CheckToChangePhase() then
			thisEntity.bChangePhase = true
			s_flNextPhaseCheckTime = GameRules:GetGameTime() + TRIGGER_PHASE_CD
			if bRubickDebug then
				print( "I'm doing nothing, because I changed phase" )
			end
			return 0.1
		end

		if thisEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if bRubickDebug then
				print( "I'm doing nothing, because I am a friendly rubick" )
			end
			return 0.1
		end

		if thisEntity.bInActivePhase == true then
			if bRubickDebug then
				print( "I'm doing nothing, because I am in an active phase" )
			end
			return 0.1
		end

		if HasReadyStolenSpell() then
			CustomGameEventManager:Send_ServerToAllClients( "rubick_stole_spell", { szAbilityName = s_StolenSpellToCast:GetAbilityName() } )
		end

		if s_SpellBehavior ~= nil then
			if bRubickDebug then
				print( "I have a spell behavior" )
			end
			if GameRules:GetGameTime() > s_flSpellBehaviorReleaseTime then
				if bRubickDebug then
					print( "Spell Behavior released" )
				end
				s_SpellBehavior = nil
				s_nSpellBehaviorCasts = 0
				if s_StolenSpellToCast ~= nil and s_StolenSpellToCast:IsNull() == false then
					s_StolenSpellToCast:StartCooldown( s_SpellSteal:GetCooldownTimeRemaining() + 2 )
				end
			else
				
				if bRubickDebug then
					--print( "Spell Behavior will be released at " .. s_flSpellBehaviorReleaseTime .. ", game time is " .. GameRules:GetGameTime() )
				end
				if not s_SpellBehavior() then
					if bRubickDebug then
						print ( "Performed Spell Behavior - don't continue logic" ) 
					end
					return 0.1
				end
				if bRubickDebug then
					print ( "Performed Spell Behavior, continuing my other behaviors" ) 
				end
			end
		end

		if s_Blink ~= nil and s_Blink:IsFullyCastable() and thisEntity:GetAggroTarget() ~= nil then
			return CastBlink()
		end

		if s_Telekinesis ~= nil and s_Telekinesis:IsFullyCastable() then
			if bRubickDebug then
				print ( "I want to use Telekinesis" ) 
			end
			return CastTelekinesis()
		end
		
		if s_TelekinesisLand ~= nil and s_TelekinesisLand:IsFullyCastable() and not s_TelekinesisLand:IsHidden() then
			if bRubickDebug then
				print ( "I want to use Telekinesis Land" ) 
			end
			return CastTelekinesisLand()
		end

		if s_FadeBolt ~= nil and s_FadeBolt:IsFullyCastable() then
			if bRubickDebug then
				print ( "I want to use Fade Bolt" ) 
			end
			return CastFadeBolt()
		end
	
		return SpellStealThink()
	end
	if bRubickDebug then
		print( "I'm doing nothing." )
	end
	return 0.1
end

function SpellStealThink()
	if s_SpellBehavior ~= nil then
		return 0.1
	end

	if HasReadyStolenSpell() then
		if bRubickDebug then
			print ( "I want to to cast my stolen spell " .. s_StolenSpellToCast:GetAbilityName() ) 
		end
		return CastSpell( s_StolenSpellToCast )
	end

	if s_SpellSteal ~= nil and s_SpellSteal:IsFullyCastable() then
		if bRubickDebug then
			print( "I want to steal a new spell!" )
		end
		return CastSpellSteal()
	end
	
	if bRubickDebug then
		print( "I found nothign to do, so I'm attacking" )
		
	end
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = thisEntity:GetOrigin(),
		})
	return 1.0
end

function CastSpellSteal()
	local hTarget = s_hPrioritySpellStealTarget
	if bRubickDebug and hTarget ~= nil and hTarget:IsAlive() then
		print( "try to steal from my priority target " .. s_hPrioritySpellStealTarget:GetUnitName() )
	end

	if hTarget == nil or not hTarget:IsAlive() then
		hTarget = GetBestUnitTarget( s_SpellSteal )
	end

	if hTarget ~= nil then
		return CastSpellUnitTarget( s_SpellSteal, hTarget )
	end

	return 0.1
end

function CastBlink()
	local Heroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #Heroes > 0 then
		local HeroTarget = Heroes[#Heroes]
		if HeroTarget ~= nil then
			local vBlinkTarget = HeroTarget:GetOrigin() + RandomVector( 1 ) * 600
			return CastSpellPointTarget( s_Blink, vBlinkTarget )
		end
	end
	return 0.1
end

function CastTelekinesisLand()
	local vTargetLoc = GetBestAOEPointTarget( s_TelekinesisLand )
	if vTargetLoc ~= nil then
		thisEntity:CastAbilityOnPosition( vTargetLoc, s_TelekinesisLand, thisEntity:GetPlayerOwnerID() )
	end

	return 0.1
end

function CastTelekinesis()
	local hTarget = GetBestUnitTarget( s_Telekinesis )
	if hTarget ~= nil then
		return CastSpellUnitTarget( s_Telekinesis, hTarget )
	end
	return 0.1
end

function CastFadeBolt()
	local hTarget = GetBestAOEUnitTarget( s_FadeBolt )
	if hTarget ~= nil then
		return CastSpellUnitTarget( s_FadeBolt, hTarget )
	end
	return 0.1
end

function HasReadyStolenSpell()
	for i=0,DOTA_MAX_ABILITIES-1 do
		local hAbility = thisEntity:GetAbilityByIndex( i )
		if hAbility ~= nil and hAbility:IsFullyCastable() and not hAbility:IsHidden() and hAbility:IsStolen() and hAbility:IsCooldownReady() and not hAbility:IsPassive() then
			if IsAbilityBlacklisted( hAbility:GetAbilityName() ) then
				return false
			end
			s_StolenSpellToCast = hAbility
			if s_StolenSpellToCast.bMarkedAsStolen == nil then
				s_StolenSpellToCast.bMarkedAsStolen = true 
				table.insert( s_szRecentStolenSpells, s_StolenSpellToCast:GetAbilityName() )
				if #s_szRecentStolenSpells > 5 then
					table.remove( s_szRecentStolenSpells, 1 )
				end
			end
			return true
		end
	end

	return false
end

function TauntPlayers()
	if thisEntity.flSpeechCooldown > GameRules:GetGameTime() then
		return
	end

	thisEntity.flSpeechCooldown = GameRules:GetGameTime()  + SPEECH_COOLDOWN
	local nTaunt = RandomInt( 0, 10 )
	if nTaunt == 0 then
		EmitGlobalSound( "rubick_rub_arc_kill_06" )
	end
	if nTaunt == 1 then
		EmitGlobalSound( "rubick_rub_arc_kill_03" )
	end
	if nTaunt == 2 then
		EmitGlobalSound( "rubick_rub_arc_kill_14" )
	end
	if nTaunt == 3 then
		EmitGlobalSound( "rubick_rub_arc_laugh_07" )
	end
	if nTaunt == 4 then
		EmitGlobalSound( "rubick_rub_arc_laugh_07" )
	end
	if nTaunt == 5 then
		EmitGlobalSound( "rubick_rub_arc_laugh_01" )
	end
	if nTaunt == 6 then
		EmitGlobalSound( "rubick_rub_arc_laugh_02" )
	end
	if nTaunt == 7 then
		EmitGlobalSound( "rubick_rub_arc_laugh_03" )
	end
	if nTaunt == 8 then
		EmitGlobalSound( "rubick_rub_arc_respawn_09" )
	end
	if nTaunt == 9 then
		EmitGlobalSound( "rubick_rub_arc_laugh_06" )
	end
	if nTaunt == 10 then
		EmitGlobalSound( "rubick_rub_arc_laugh_06" )
	end
	
end
