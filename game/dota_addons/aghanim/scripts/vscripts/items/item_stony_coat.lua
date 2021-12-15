item_stony_coat = class({})
LinkLuaModifier( "modifier_item_stony_coat", "modifiers/modifier_item_stony_coat", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_stony_coat:Precache( context )
	PrecacheResource( "particle", "particles/neutral_fx/mud_golem_hurl_boulder.vpcf", context )
end

--------------------------------------------------------------------------------

function item_stony_coat:GetIntrinsicModifierName()
	return "modifier_item_stony_coat"
end

--------------------------------------------------------------------------------

function item_stony_coat:Spawn()
	if IsServer() == false then
		return
	end

	self.boulder_damage = self:GetSpecialValueFor( "boulder_damage" )
	self.boulder_stun_duration = self:GetSpecialValueFor( "boulder_stun_duration" )
end

--------------------------------------------------------------------------------

function item_stony_coat:OnProjectileHit( hTarget, vLocation )
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
