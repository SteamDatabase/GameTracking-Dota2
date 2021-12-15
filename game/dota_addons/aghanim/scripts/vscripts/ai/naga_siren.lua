--[[ Naga Siren AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity.nIllusionsCreated = 0
	thisEntity.nMaxIllusions = 10
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorMirrorImage, BehaviorEnsnare, BehaviorRipTide, BehaviorSong, BehaviorRunAway } )
	
    --[[ Turn on Radiance
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_radiance" then
			thisEntity.RadianceAbility = item
		end
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.RadianceAbility:entindex(),
		Queue = false,
	})
	]]
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()

	local orders = nil
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, thisEntity:GetDayTimeVisionRange(), false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( DOTA_TEAM_BADGUYS, 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex()
		}
	elseif thisEntity.lastTargetPosition ~= nil then
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = thisEntity.lastTargetPosition
		}
	else
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end

	return orders
end

BehaviorNone.Continue = BehaviorNone.Begin

--------------------------------------------------------------------------------------------------------

BehaviorMirrorImage = {}

function BehaviorMirrorImage:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	if thisEntity.nIllusionsCreated == thisEntity.nMaxIllusions then
		return desire
	end

	self.mirrorImageAbility = thisEntity:FindAbilityByName( "aghsfort_naga_siren_mirror_image" )
	if not self.mirrorImageAbility or not self.mirrorImageAbility:IsFullyCastable() then
		return desire
	end

	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if ( #enemies >= 0 )  then
		desire = #enemies + 1
	end

	return desire
end

function BehaviorMirrorImage:Begin()
	--print( "BehaviorMirrorImage:Begin()" )
	if self.mirrorImageAbility and self.mirrorImageAbility:IsFullyCastable() then
		thisEntity.nIllusionsCreated = thisEntity.nIllusionsCreated + 1
		local order = 
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.mirrorImageAbility:entindex(),
		}
		return order
	end

	return nil

end

BehaviorMirrorImage.Continue = BehaviorMirrorImage.Begin

--------------------------------------------------------------------------------------------------------

BehaviorEnsnare = {}

function BehaviorEnsnare:Evaluate()
	--print( "BehaviorEnsnare:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.ensnareAbility = thisEntity:FindAbilityByName( "naga_siren_ensnare" )
	if self.ensnareAbility and self.ensnareAbility:IsFullyCastable() then
		local nRange = 600
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorEnsnare:Begin()
	--print( "BehaviorEnsnare:Begin()" )

	self.target = nil
	local bestDistance = 0
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), thisEntity, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local hTarget = enemies[#enemies]
	if not hTarget:IsStunned() then
		if self.ensnareAbility and self.ensnareAbility:IsFullyCastable() then
			--print( "Casting Star Fall" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = self.ensnareAbility:entindex(),
				Queue = false,
			}
			return order
		end
	end

	return nil
end

BehaviorEnsnare.Continue = BehaviorEnsnare.Begin

--------------------------------------------------------------------------------------------------------

BehaviorRipTide = {}

function BehaviorRipTide:Evaluate()
	--print( "BehaviorRipTide:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.ripTideAbility = thisEntity:FindAbilityByName( "naga_siren_rip_tide" )
	if self.ripTideAbility and self.ripTideAbility:IsFullyCastable() then
		local nRange = 300
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorRipTide:Begin()
	--print( "BehaviorRipTide:Begin()" )

	if self.ripTideAbility and self.ripTideAbility:IsFullyCastable() then
		--print( "Casting Star Fall" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.ripTideAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorRipTide.Continue = BehaviorRipTide.Begin

--------------------------------------------------------------------------------------------------------

BehaviorSong = {}

function BehaviorSong:Evaluate()
	--print( "BehaviorSong:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.songAbility = thisEntity:FindAbilityByName( "naga_siren_song_of_the_siren" )
	if self.songAbility and self.songAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 65 ) then
			local nRange = 1000
			local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
			return desire
		end
	end
	
	return desire
end

function BehaviorSong:Begin()
	--print( "BehaviorSong:Begin()" )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_invulnerable", { duration = 1 } )
	if self.songAbility and self.songAbility:IsFullyCastable() then
		--print( "Casting Song of the Siren" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.songAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorSong.Continue = BehaviorSong.Begin

--------------------------------------------------------------------------------------------------------

BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0
	local retreatPoints = thisEntity.Encounter:GetRetreatPoints()
	if retreatPoints == nil then
		print( "*** WARNING: This AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
		return 0
	end

	local happyPlaceIndex =  RandomInt( 1, #retreatPoints )
	self.escapePoint = retreatPoints[ happyPlaceIndex ]:GetAbsOrigin()

	local hSongModifier = thisEntity:FindModifierByName( "modifier_naga_siren_song_of_the_siren_aura" )
	if hSongModifier ~= nil then
		--print("Naga Siren is singing!")
		desire = 5
	end

	return desire
end


function BehaviorRunAway:Begin()
	--print( "BehaviorRunAway:Begin()" )
	self.startEscapeTime = GameRules:GetGameTime()

	-- move towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

function BehaviorRunAway:IsDone( )
	return ( GameRules:GetGameTime() > ( self.startEscapeTime + 6 ) ) or
		( ( thisEntity:GetAbsOrigin() - self.escapePoint ):Length2D() < 200 )
end

function BehaviorRunAway:Think( )
	-- keep moving towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

BehaviorRunAway.Continue = BehaviorRunAway.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorMirrorImage, BehaviorEnsnare, BehaviorRipTide, BehaviorSong, BehaviorRunAway }
