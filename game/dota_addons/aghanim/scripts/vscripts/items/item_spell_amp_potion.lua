
item_spell_amp_potion = class({})
LinkLuaModifier( "modifier_item_spell_amp_potion", "modifiers/modifier_item_spell_amp_potion", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_spell_amp_potion:Precache( context )
	PrecacheResource( "particle", "particles/generic_gameplay/spell_amp_potion_owner.vpcf", context )
end

--------------------------------------------------------------------------------

function item_spell_amp_potion:OnSpellStart()
	if IsServer() then
		local kv =
		{
			duration = self:GetSpecialValueFor( "buff_duration" ),
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_item_spell_amp_potion", kv )

		EmitSoundOn( "SpellAmpPotion.Activate", self:GetCaster() )

		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------
