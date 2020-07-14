creature_landmine_detonate = class({})
LinkLuaModifier( "modifier_creature_landmine_detonate", "modifiers/creatures/modifier_creature_landmine_detonate", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_landmine_detonate:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_creature_landmine_detonate", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end
