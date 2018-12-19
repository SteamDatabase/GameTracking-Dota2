tiny_trample = class({})
LinkLuaModifier( "modifier_tiny_trample", "modifiers/modifier_tiny_trample", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tiny_trample:OnSpellStart()
	if IsServer() then
		self.hHitEntities = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tiny_trample", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end