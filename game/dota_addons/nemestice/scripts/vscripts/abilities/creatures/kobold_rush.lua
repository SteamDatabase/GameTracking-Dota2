kobold_rush = class({})

LinkLuaModifier( "modifier_kobold_rush", "modifiers/creatures/modifier_kobold_rush", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function kobold_rush:Precache( context )
end

--------------------------------------------------------------------------------

function kobold_rush:OnSpellStart()
	if IsServer() then
		local buff_duration = self:GetSpecialValueFor( "buff_duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_kobold_rush", { duration = buff_duration } )
	end
end

--------------------------------------------------------------------------------