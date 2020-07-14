ascension_magic_immunity = class( {} )

LinkLuaModifier( "modifier_ascension_magic_immunity", "modifiers/modifier_ascension_magic_immunity", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_magic_immunity:Precache( hContext )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", hContext )
	PrecacheResource( "particle", "particles/status_fx/status_effect_avatar.vpcf", hContext )
end

--------------------------------------------------------------------------------

function ascension_magic_immunity:OnSpellStart()

	if not IsServer() then
		return
	end

	local flDuration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ascension_magic_immunity", { duration = flDuration } )

end

