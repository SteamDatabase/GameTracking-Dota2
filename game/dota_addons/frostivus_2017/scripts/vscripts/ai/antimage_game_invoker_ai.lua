local IDLE = 0
local TORNADO = 1
local DEAFENING_BLAST = 2
local TORNADO_DEAFENING = 3
local SUNSTRIKE = 4
local CHAOS_METEOR = 5
local SUNSTRIKE_CHAOS_METEOR = 6
local ROTATE_TORNADO = 7
local ROTATE_TORNADO_DEAFENING = 8

local TORNADO_SUNSTRIKE = 10
local DEAFENING_METEOR = 11
local EVERYTHING = 12

local NORTH = 0
local EAST  = 1
local SOUTH = 2
local WEST  = 3

function Spawn()
	thisEntity.state = IDLE
	thisEntity.cardinality = NORTH
	thisEntity.castRate = 1
	
	thisEntity.top_left  = Entities:FindByName( nil, "invoker_top_left"  ):GetAbsOrigin()
	thisEntity.top_right = Entities:FindByName( nil, "invoker_top_right" ):GetAbsOrigin()
	thisEntity.right_top = Entities:FindByName( nil, "invoker_right_top" ):GetAbsOrigin()
	thisEntity.right_bot = Entities:FindByName( nil, "invoker_right_bot" ):GetAbsOrigin()
	thisEntity.bot_right = Entities:FindByName( nil, "invoker_bot_right" ):GetAbsOrigin()
	thisEntity.bot_left  = Entities:FindByName( nil, "invoker_bot_left"  ):GetAbsOrigin()
	thisEntity.left_top  = Entities:FindByName( nil, "invoker_left_top"  ):GetAbsOrigin()
	thisEntity.left_bot  = Entities:FindByName( nil, "invoker_left_bot"  ):GetAbsOrigin()
	thisEntity.center    = Entities:FindByName( nil, "snow_tiny_center"  ):GetAbsOrigin()
	
	thisEntity.waiting = false
	thisEntity.rotateDelay = 4
	
	thisEntity.abilityList = {}
	for i=0,16 do
		if thisEntity:GetAbilityByIndex(i) ~= nil then
			table.insert(thisEntity.abilityList,thisEntity:GetAbilityByIndex(i))
		end
	end
	
	Timers:CreateTimer(0,
      function()
        return thisEntity:AIThink()
      end)
end

function thisEntity:AIThink()
	if self:IsNull() then return end
	if not self:IsAlive() then return end

	local state = thisEntity.state
	local castRate = thisEntity.castRate
	--print('Invoker Think', state)
	
	if state == IDLE then
		return 1
	elseif state == TORNADO then
		if not thisEntity:IsCastingAbility() then
			thisEntity:Teleport()
			thisEntity:CastTornado()
			return .55 * castRate
		end
	elseif state == DEAFENING_BLAST then
		if not thisEntity:IsCastingAbility() then
			thisEntity:Teleport()
			thisEntity:CastDeafeningBlast()
			return .6 * castRate
		end
	elseif state == TORNADO_DEAFENING then
		--tornado from left deafening from right
		if thisEntity.cardinality ~= 3 and thisEntity.cardinality ~= 1 then
			thisEntity.cardinality = 3
			thisEntity:Teleport()
		else
			if not thisEntity:IsCastingAbility() then
				if thisEntity.cardinality == EAST then
					thisEntity.cardinality = WEST
					thisEntity:Teleport()
					thisEntity:CastTornado()
					return .5 * castRate
				elseif thisEntity.cardinality == WEST then
					thisEntity.cardinality = EAST
					thisEntity:Teleport()
					thisEntity:CastDeafeningBlast()
					return .5 * castRate
				end
			end
		end
	elseif state == SUNSTRIKE then
		if not thisEntity:IsCastingAbility() then
			thisEntity:CastSunstrike()
			return .1 * castRate
		end
	elseif state == CHAOS_METEOR then
		if not thisEntity:IsCastingAbility() then
			thisEntity:CastChaosMeteor()
			return .3 * castRate
		end
	elseif state == SUNSTRIKE_CHAOS_METEOR then
		if not thisEntity:IsCastingAbility() then
			if RandomFloat(0,1) < .5 then
				thisEntity:CastSunstrike()
				return .1 * castRate
			else 
				thisEntity:CastChaosMeteor()
				return .35 * castRate
			end
		end
	elseif state == ROTATE_TORNADO then
		--rotate on a timed interval
		if not thisEntity.waiting then
			thisEntity.waiting = true
			Timers:CreateTimer(thisEntity.rotateDelay,function()
				thisEntity.cardinality = (thisEntity.cardinality + 1) % 4
				thisEntity.waiting = false
				if thisEntity.cardinality == 0 then
					thisEntity.rotateDelay = thisEntity.rotateDelay - 1
				end
			end)
		end
		if not thisEntity:IsCastingAbility() then
			thisEntity:Teleport()
			thisEntity:CastTornado()
			return .55 * castRate
		end
	elseif state == ROTATE_TORNADO_DEAFENING then
		--rotate and cast Deafening Blast and Tornado
		if not thisEntity:IsCastingAbility() then
			thisEntity.cardinality = (thisEntity.cardinality + 1) % 4
			thisEntity:Teleport()
			if RandomFloat(0,1) < .5 then
				thisEntity:CastDeafeningBlast()
				return .5 * castRate
			else 
				thisEntity:CastTornado()
				return .5 * castRate
			end
		end
	elseif state == 9 then
		thisEntity.cardinality = RandomInt(0,3)
		thisEntity:Teleport()
		local aggroTargets = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _,target in pairs(aggroTargets) do
			thisEntity:CastTornado(target:GetAbsOrigin())
			return .6
		end
	elseif state == TORNADO_SUNSTRIKE then
		--Tornado and Sunstrike
		if not thisEntity:IsCastingAbility() then
			if RandomFloat(0,1) < .4 then
				thisEntity:Teleport()
				thisEntity:CastTornado()
				return .5 * castRate
			else
				thisEntity:CastSunstrike()
				return .1 * castRate
			end
		end
	elseif state == DEAFENING_METEOR then
		--Deafening Blast and Chaos Meteor
		if not thisEntity:IsCastingAbility() then
			if RandomFloat(0,1) < .4 then
				thisEntity:Teleport()
				thisEntity:CastDeafeningBlast()
				return .5 * castRate
			else
				thisEntity:CastChaosMeteor()
				return .3 * castRate
			end
		end
	elseif state == EVERYTHING then
		--everything
		if not thisEntity:IsCastingAbility() then
			local randomPercent = RandomFloat(0,1)
			if randomPercent < .15 then
				thisEntity.cardinality = (thisEntity.cardinality + 1) % 4
				thisEntity:Teleport()
				thisEntity:CastTornado()
				return .5 * castRate
			elseif randomPercent < .3 then
				thisEntity.cardinality = (thisEntity.cardinality + 1) % 4
				thisEntity:Teleport()
				thisEntity:CastDeafeningBlast()
				return .5 * castRate
			elseif randomPercent < .65 then
				thisEntity:CastSunstrike()
				return .15 * castRate
			else
				thisEntity:CastChaosMeteor()
				return .25 * castRate
			end
		end		
	end
	
	return .1
end

--throws a tornado in the direction Invoker is standing
function thisEntity:CastTornado(target)
	local castPosition = target
	if target == nil then
		castPosition = thisEntity:GetPositionToCast()
	end
	local ability = thisEntity:FindAbilityByName("custom_invoker_tornado")
	thisEntity:CastAbilityOnPosition(castPosition,ability,-1)
end

--throws a deafening blast in the direction Invoker is standing
function thisEntity:CastDeafeningBlast()
	local castPosition = thisEntity:GetPositionToCast()
	local ability = thisEntity:FindAbilityByName("invoker_deafening_blast_datadriven")
	thisEntity:CastAbilityOnPosition(castPosition,ability,-1)
end

function thisEntity:CastSunstrike()
	local ability = thisEntity:FindAbilityByName("custom_invoker_sunstrike")
	thisEntity:CastAbilityOnPosition(GameMode:GetRandomPositionOnStage(),ability,-1)
end

function thisEntity:CastChaosMeteor()
	local ability = thisEntity:FindAbilityByName("custom_invoker_chaos_meteor")
	thisEntity:CastAbilityOnPosition(GameMode:GetRandomPositionOnStage(),ability,-1)
end

function thisEntity:CastEMP()
	local ability = thisEntity:FindAbilityByName("custom_invoker_EMP")
	thisEntity:CastAbilityOnPosition(thisEntity.center,ability,-1)
end

function thisEntity:CastIceWall(location)
	local ability = thisEntity:FindAbilityByName("custom_invoker_ice_wall")
	local direction = (thisEntity:GetPositionToCast() - thisEntity:GetAbsOrigin()):Normalized()
	thisEntity:SetForwardVector(direction)
	if location == nil then
		--by default cast on the center
		thisEntity:CastAbilityOnPosition(thisEntity.center,ability,-1)
	end
end

function thisEntity:Teleport(location)
	local teleportLocation 
	if location == nil then
		local cardinality = thisEntity.cardinality
		local lowerBound = nil
		local upperBound = nil
		local distance = 0
		
		if cardinality == NORTH then
			lowerBound = thisEntity.top_left
			upperBound = thisEntity.top_right
		elseif cardinality == SOUTH then
			lowerBound = thisEntity.bot_left
			upperBound = thisEntity.bot_right
		elseif cardinality == EAST then
			lowerBound = thisEntity.left_bot
			upperBound = thisEntity.left_top
		elseif cardinality == WEST then
			lowerBound = thisEntity.right_bot
			upperBound = thisEntity.right_top
		end
		
		while distance < 200 do
			teleportLocation = lowerBound + RandomFloat(0,1) * (upperBound - lowerBound)
			distance = math.abs((thisEntity:GetAbsOrigin() - teleportLocation):Length())
		end
	else
		teleportLocation = location
	end
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity)
	
	FindClearSpaceForUnit(thisEntity, teleportLocation, true)
end

function thisEntity:Reset()
	thisEntity.state = 0
	thisEntity.cardinality = 0
	thisEntity.castRate = 1
end

-------------------------------
-- Helper Functions          --
-------------------------------

function thisEntity:GetPositionToCast()
	local currentPosition = thisEntity:GetAbsOrigin()
	local cardinality = thisEntity.cardinality
	
	if cardinality == NORTH then
		return currentPosition + Vector(0,-100,0)
	elseif cardinality == SOUTH then
		return currentPosition + Vector(0,100,0)
	elseif cardinality == EAST then
		return currentPosition + Vector(100,0,0)
	elseif cardinality == WEST then
		return currentPosition + Vector(-100,0,0)
	end
end

function thisEntity:IsCastingAbility( )
	local abilityList = thisEntity.abilityList
	
	for i=1,#abilityList do
		if abilityList[i]:IsInAbilityPhase() then
			return true
		end
	end
	
	return false
end