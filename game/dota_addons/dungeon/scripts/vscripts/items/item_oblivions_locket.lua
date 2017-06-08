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

--------------------------------------------------------------------------------

function item_oblivions_locket:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
end

--------------------------------------------------------------------------------

function item_oblivions_locket:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_oblivions_locket:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	
	return self.BaseClass.IsMuted( self )
end
