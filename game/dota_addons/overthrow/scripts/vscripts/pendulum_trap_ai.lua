--[[ pendulum_trap_ai.lua ]]

---------------------------------------------------------------------------
-- AI for the Pendulum Trap
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
	print("Pendulum has hit a hero!")
	local triggerName = thisEntity:GetName()
	local target = Entities:FindByName( nil, triggerName .. "_target" )
	local level = trigger.activator:GetLevel()
	local hero = trigger.activator:GetName()
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	if heroHandle:IsOutOfGame() == true then
		--print("Phase Shift")
		return
	end
	if heroHandle ~= nil then
		--print("Pendulum should do 10000 damage")
		local pendulumTrap = thisEntity:FindAbilityByName("pendulum_trap")
		--thisEntity:CastAbilityOnTarget(heroHandle, pendulumTrap, -1 )
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
end

