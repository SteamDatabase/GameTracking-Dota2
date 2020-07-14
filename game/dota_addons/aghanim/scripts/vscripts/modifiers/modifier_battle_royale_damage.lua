-- This is the modifier that punishes players for not being in the active room

modifier_battle_royale_damage = class({})

--------------------------------------------------------------------------------

function modifier_battle_royale_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_battle_royale_damage:OnCreated( kv )
	if IsServer() then
		self.flStartTime = GameRules:GetGameTime()
		self:OnIntervalThink()
		self:StartIntervalThink( 1.0 )
	end
end

-----------------------------------------------------------------------

function modifier_battle_royale_damage:OnIntervalThink()

	-- If the player is disconnected, should we give them a break? Not sure...
	local nPlayerID = self:GetParent():GetPlayerOwnerID()
	if PlayerResource:GetConnectionState( nPlayerID ) == 3 then
		return
	end

	local vecStartPos = self:GetParent():GetAbsOrigin()
	vecStartPos.z = vecStartPos.z + 4000

	local nFXIndex  = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vecStartPos )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local flTimeSinceStart = GameRules:GetGameTime() - self.flStartTime
	local flDamagePercent = flTimeSinceStart / 10
	if flDamagePercent > 1 then
		flDamagePercent = 1
	end
	flDamagePercent = SimpleSpline( flDamagePercent )
	flDamagePercent = ( 1 - flDamagePercent ) * 0.03 + flDamagePercent * 0.15 -- Linear Interpolation

  	local damageInfo = 
	{
		victim = self:GetParent(),
		attacker = self:GetParent(),
		damage = flDamagePercent * self:GetParent():GetMaxHealth(),
		damage_type = DAMAGE_TYPE_PURE,
		ability = nil,
	}
	ApplyDamage( damageInfo )

	EmitSoundOn( "BattleRoyaleDamage", self:GetParent() )	

end