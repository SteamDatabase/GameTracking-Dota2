vengefulspirit_magic_missile_lua = class({})
LinkLuaModifier( "modifier_vengefulspirit_magic_missile_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vengefulspirit_magic_missile_lua:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "magic_missile_speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_VengefulSpirit.MagicMissile", self:GetCaster() )
end

--------------------------------------------------------------------------------

function vengefulspirit_magic_missile_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		EmitSoundOn( "Hero_VengefulSpirit.MagicMissileImpact", hTarget )
		local magic_missile_stun = self:GetSpecialValueFor( "magic_missile_stun" )
		local magic_missile_damage = self:GetSpecialValueFor( "magic_missile_damage" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = magic_missile_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_vengefulspirit_magic_missile_lua", { duration = magic_missile_stun } )
	end

	return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
