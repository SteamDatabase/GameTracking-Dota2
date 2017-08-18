
---------------------------------------------------------------------------------

function CDungeon:OnPlayerEnterPlateau( hPlayerHero )
	--print( string.format( "%s entered plateau zone, apply weather modifier", hPlayerHero:GetUnitName() ) )

	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )
	local hWeatherDummies = {}
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == "npc_dota_weather_dummy" ) and hCreature:IsAlive() then
			table.insert( hWeatherDummies, hCreature )
		end
	end

	local hWeatherDummy = hWeatherDummies[ 1 ]

	if hWeatherDummy == nil then
		print( "CDungeon:OnPlayerEnterPlateau - ERROR: Weather dummy not found" )
		return
	end

	local hWeatherAbility = hWeatherDummy:FindAbilityByName( "weather_snowstorm" )

	if ( not hPlayerHero:HasModifier( "modifier_weather_snowstorm" ) ) then
		--print( "   add new modifier: modifier_weather_snowstorm" )
		if ( hPlayerHero ) then
			--print( string.format( "   hero name: %s, is alive?: %s", hPlayerHero:GetUnitName(), tostring( hPlayerHero:IsAlive() ) ) )
		end
		hPlayerHero:AddNewModifier( hWeatherDummy, hWeatherAbility, "modifier_weather_snowstorm", { duration = -1 } )
	end
end

---------------------------------------------------------------------------------

function CDungeon:OnPlayerExitPlateau( hPlayerHero )
	--print( string.format( "%s exited plateau zone, remove weather modifier", hPlayerHero:GetUnitName() ) )

	hPlayerHero:RemoveModifierByName( "modifier_weather_snowstorm" )
	hPlayerHero:RemoveModifierByName( "modifier_weather_snowstorm_cold" )
	hPlayerHero:RemoveModifierByName( "modifier_weather_snowstorm_effect" )
end

---------------------------------------------------------------------------------

