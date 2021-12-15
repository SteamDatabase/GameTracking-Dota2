item_oblivions_locket = class({})
LinkLuaModifier( "modifier_item_oblivions_locket", "modifiers/modifier_item_oblivions_locket", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_oblivions_locket:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )

		local kv =
		{
			duration = -1,
			extra_spell_damage_percent = self:GetSpecialValueFor( "extra_spell_damage_percent" ),
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ghost_state", kv )
	end
end

--------------------------------------------------------------------------------

function item_oblivions_locket:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_ghost_state" )
	end
end

--------------------------------------------------------------------------------

function item_oblivions_locket:GetIntrinsicModifierName()
	return "modifier_item_oblivions_locket"
end
