--[[ boulder_trap_ai.lua ]]

---------------------------------------------------------------------------
-- AI for the Boulder Trap
---------------------------------------------------------------------------

function PrintTable( t, indent )
	if type(t) ~= "table" then return end

	for k,v in pairs( t ) do
		if type( v ) == "table" then
			if ( v ~= t ) then
				print( indent .. tostring( k ) .. ":\n" .. indent .. "{" )
				PrintTable( v, indent .. "  " )
				print( indent .. "}" )
			end
		else
		print( indent .. tostring( k ) .. ":" .. tostring(v) )
		end
	end
end

function Fire(trigger)
	local index = 1
	if thisEntity:GetName() == "radiant_boulder_trap_npc" then
		index = 1
	elseif thisEntity:GetName() == "dire_boulder_trap_npc" then
		index = 2
	end
	
	--print("Boulder has hit a hero!")
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)

	if m_boulder_info[index].isBoulderFalling == false then
		print("Boulder "..index.." hit something but wasn't falling. Hit "..trigger.activator:GetName().." triggered by "..thisEntity.KillerToCredit:GetName().." at "..GameRules:GetDOTATime(false, false))
		return
	end
	
	if heroHandle == nil or heroHandle:IsNull() then
		return
	end
	
	local nResult = UnitFilter( heroHandle, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, DOTA_TEAM_GOODGUYS )
	--print( "$$$$Result: " .. nResult )
	if nResult ~= UF_SUCCESS then
		return
	end
	
	if heroHandle:IsPhantom() or trigger.activator:GetName() == thisEntity:GetName() or heroHandle.isDigSite == true then
		--print(trigger.activator:GetName().." cannot be hit by boulder")
		return
	end

	print(" Boulder hit "..trigger.activator:GetName().." triggered by "..thisEntity.KillerToCredit:GetName().." at "..GameRules:GetDOTATime(false, false))

	--print("Boulder should kill a hero")
	--local boulderTrap = thisEntity:FindAbilityByName("boulder_trap")
	--thisEntity:CastAbilityOnTarget(heroHandle, boulderTrap, -1 )
	-- Using Kill() instead of ability
	local killEffects = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_blood01.vpcf", PATTACH_POINT, heroHandle )
	ParticleManager:SetParticleControlEnt( killEffects, 0, heroHandle, PATTACH_POINT, "attach_hitloc", heroHandle:GetAbsOrigin(), false )
	heroHandle:Attribute_SetIntValue( "effectsID", killEffects )
	EmitSoundOn( "Conquest.Pendulum.Target", heroHandle )
	local killerEntity = thisEntity
	if thisEntity.KillerToCredit ~= nil then
		killerEntity = thisEntity.KillerToCredit
	end
	heroHandle:Kill( nil, killerEntity )
end

