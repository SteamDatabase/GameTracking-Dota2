creature_mirana_global_vision = class({})
LinkLuaModifier( "modifier_creature_mirana_global_vision", "modifiers/modifier_creature_mirana_global_vision", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_mirana_global_vision:OnSpellStart()
	--self.duration = self:GetSpecialValueFor( "duration" )

	if IsServer() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		print( string.format( "found %d enemies", #enemies ) )
		for _, hHero in pairs( enemies ) do
			print( "adding global vision modifier to hero" )
			hHero:AddNewModifier( GetCaster(), self, "modifier_creature_mirana_global_vision", { } );
		end
	end
end

--------------------------------------------------------------------------------