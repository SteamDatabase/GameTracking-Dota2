
item_lifestone = class({})
LinkLuaModifier( "modifier_item_lifestone", "modifiers/modifier_item_lifestone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_lifestone_pact", "modifiers/modifier_item_lifestone_pact", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_lifestone:GetIntrinsicModifierName()
	return "modifier_item_lifestone"
end

--------------------------------------------------------------------------------

function item_lifestone:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		if hCaster:HasModifier( "modifier_item_lifestone_pact" ) then
			hCaster:RemoveModifierByName( "modifier_item_lifestone_pact" )
		else
			hCaster:AddNewModifier( hCaster, self, "modifier_item_lifestone_pact", { duration = -1 } )
		end
	end
end
