treant_great_protector = class({})
LinkLuaModifier( "modifier_treant_great_protector", "modifiers/modifier_treant_great_protector", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function treant_great_protector:OnSpellStart()
	EmitSoundOn( "Hero_Treant.NaturesGuise.On", self:GetCaster() )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_treant_great_protector", { duration = self:GetSpecialValueFor( "duration" ) } )
end

--------------------------------------------------------------------------------
