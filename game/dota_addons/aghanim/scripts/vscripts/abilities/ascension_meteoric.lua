ascension_meteoric = class( {} )

LinkLuaModifier( "modifier_ascension_meteoric_display", "modifiers/modifier_ascension_meteoric_display", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_meteoric_thinker", "modifiers/modifier_ascension_meteoric_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_meteoric:Precache( hContext )

end

--------------------------------------------------------------------------------

function ascension_meteoric:Spawn()
	-- So the modifier can be seen
	if IsServer() == true then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_meteoric_display", nil )
	end
end


--------------------------------------------------------------------------------

function ascension_meteoric:OnSpellStart()
	if not IsServer() then
		return
	end

	EmitSoundOn( "DOTA_Item.MeteorHammer.Channel", self:GetCaster() )

	local flDuration = self:GetSpecialValueFor( "duration" )
	CreateModifierThinker( self:GetCaster(), self, "modifier_ascension_meteoric_thinker", { duration = flDuration }, self:GetCursorTarget():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
end

