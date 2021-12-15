ascension_attack_speed = class( {} )

LinkLuaModifier( "modifier_ascension_attack_speed", "modifiers/modifier_ascension_attack_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascension_last_stand_display", "modifiers/modifier_ascension_last_stand_display", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_attack_speed:Precache( context )
	PrecacheResource( "particle", "particles/items2_fx/mask_of_madness.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_attack_speed:OnSpellStart()

	if not IsServer() then
		return
	end

	local flDuration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_attack_speed", { duration = flDuration } )

end

