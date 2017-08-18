
modifier_siltbreaker_torrents_thinker = class({})

-----------------------------------------------------------------------------

function modifier_siltbreaker_torrents_thinker:OnCreated( kv )
	if IsServer() then
		self.torrent_delay = self:GetAbility():GetSpecialValueFor( "torrent_delay" )
		self.torrent_radius = self:GetAbility():GetSpecialValueFor( "torrent_radius" )
		self.torrent_damage = self:GetAbility():GetSpecialValueFor( "torrent_damage" )
		self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )
		self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )

		self:StartIntervalThink( self.torrent_delay )

		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_spell_torrent_bubbles.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_torrents_thinker:OnIntervalThink()
	if IsServer() then
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )

		EmitSoundOn( "TempleGuardian.Wrath.Explosion", self:GetParent() )
		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.torrent_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = hEnemy,
					attacker = self:GetCaster(),
					damage = self.torrent_damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )

				local kv =
				{
					center_x = self:GetParent():GetOrigin().x,
					center_y = self:GetParent():GetOrigin().y,
					center_z = self:GetParent():GetOrigin().z,
					should_stun = true, 
					duration = self.knockback_duration,
					knockback_duration = self.knockback_duration,
					knockback_distance = self.knockback_distance,
					knockback_height = self.knockback_height,
				}
				hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )
			end
		end

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

