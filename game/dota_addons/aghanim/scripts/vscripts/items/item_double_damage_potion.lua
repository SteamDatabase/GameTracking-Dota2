
item_double_damage_potion = class({})
LinkLuaModifier( "modifier_item_double_damage_potion", "modifiers/modifier_item_double_damage_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_double_damage_potion:OnSpellStart()
	if IsServer() then
		local kv =
		{
			duration = self:GetSpecialValueFor( "buff_duration" ),
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_double_damage_potion", kv )

		EmitSoundOn( "DoubleDamagePotion.Activate", self:GetCaster() )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
