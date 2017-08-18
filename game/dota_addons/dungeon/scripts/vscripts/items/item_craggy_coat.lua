item_craggy_coat = class({})
LinkLuaModifier( "modifier_item_craggy_coat", "modifiers/modifier_item_craggy_coat", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_craggy_coat:GetIntrinsicModifierName()
	return "modifier_item_craggy_coat"
end

--------------------------------------------------------------------------------

function item_craggy_coat:Spawn()
	self.required_level = self:GetSpecialValueFor( "required_level" )
	self.boulder_damage = self:GetSpecialValueFor( "boulder_damage" )
	self.boulder_stun_duration = self:GetSpecialValueFor( "boulder_stun_duration" )
end

--------------------------------------------------------------------------------

function item_craggy_coat:OnHeroLevelUp()
	if IsServer() then
		if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			self:OnUnequip()
			self:OnEquip()
		end
	end
end

--------------------------------------------------------------------------------

function item_craggy_coat:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
			local damageinfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.boulder_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageinfo )
			EmitSoundOn( "n_mud_golem.Boulder.Target", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.boulder_stun_duration } )
		end
	end

	return true
end

--------------------------------------------------------------------------------

function item_craggy_coat:IsMuted()	
	if self.required_level > self:GetCaster():GetLevel() then
		return true
	end
	if not self:GetCaster():IsHero() then
		return true
	end
	return self.BaseClass.IsMuted( self )
end
