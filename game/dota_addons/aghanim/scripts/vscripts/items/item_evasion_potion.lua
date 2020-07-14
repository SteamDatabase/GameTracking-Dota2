
item_evasion_potion = class({})
LinkLuaModifier( "modifier_item_evasion_potion", "modifiers/modifier_item_evasion_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_evasion_potion:Precache( context )
	PrecacheResource( "particle", "particles/generic_gameplay/evasion_potion_owner.vpcf", context )
end

--------------------------------------------------------------------------------

function item_evasion_potion:OnSpellStart()
	if IsServer() then
		local kv =
		{
			duration = self:GetSpecialValueFor( "buff_duration" ),
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_evasion_potion", kv )

		EmitSoundOn( "EvasionPotion.Activate", self:GetCaster() )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
