ascension_drunken = class( {} )

LinkLuaModifier( "modifier_ascension_drunken_display", "modifiers/modifier_ascension_drunken_display", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_drunken:Precache( hContext )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", hContext )
	PrecacheResource( "particle", "particles/status_fx/status_effect_drunken_brawler.vpcf", hContext )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_evade.vpcf", hContext )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf", hContext )
end

--------------------------------------------------------------------------------

function ascension_drunken:Spawn()
	-- So the modifier can be seen
	if IsServer() == true then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_drunken_display", nil )
	end
end


--------------------------------------------------------------------------------

function ascension_drunken:OnSpellStart()

	if not IsServer() then
		return
	end

	--print( "casting drunken ")

	EmitSoundOn( "Hero_Brewmaster.Brawler.Cast", self:GetCaster() )

	local flDuration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_brewmaster_drunken_brawler", { duration = flDuration } )

end

