modifier_trap_techies_land_mine = class({})

--------------------------------------------------------------------------------

function modifier_trap_techies_land_mine:OnCreated( kv )
	if IsServer() then
		if kv["radius_random_max"] then 
			self.radius = RandomInt( kv["radius"], kv["radius_random_max"] )
		else
			self.radius = kv["radius"]
		end
		self.activation_delay = kv["activation_delay"]
		self.damage = kv["damage"]
		self.percentage_damage = kv["percentage_damage"]
		self.invisible = tonumber(kv["invisible"]) ~= 0 or kv["invisible"] == "true"
		self.proximity_threshold = kv["proximity_threshold"]
		self:StartIntervalThink( 0.2 )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_techies_land_mine:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		state[MODIFIER_STATE_INVISIBLE] = self.invisible
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_trap_techies_land_mine:OnIntervalThink()
	if IsServer() then

		local flGameTimeNow = GameRules:GetGameTime()
		
		local eTARGETED_UNITS = DOTA_UNIT_TARGET_HERO
		local eIGNORED_UNITS = DOTA_UNIT_TARGET_FLAG_NONE

		local VisibleEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.proximity_threshold, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, eTARGETED_UNITS, eIGNORED_UNITS, 0, false )

		local DamageEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, eTARGETED_UNITS + DOTA_UNIT_TARGET_BASIC, eIGNORED_UNITS, 0, false )

		if self.explodeTime == nil then
			local bWasInvisible = self.invisible == true
			self.invisible = #VisibleEnemies <= 0
			if bWasInvisible and not self.invisible then
				self.explodeTime = flGameTimeNow + self.activation_delay
				EmitSoundOn("Hero_Techies.LandMine.Priming", self:GetParent() );	
			end
		end
	
		--printf("threshold %s, enemies %d", self.proximity_threshold, #enemies)

		local flExplodeTime = self.explodeTime
		if flExplodeTime == nil then
			flExplodeTime = 1e60
		end

		--printf("now %s explode %s", flGameTimeNow, flExplodeTime)

		if (flGameTimeNow < flExplodeTime) or self.invisible then
			return
		end

		for _, enemy in pairs( DamageEnemies ) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				local DamageInfo =
				{
					victim = enemy,
					attacker = self:GetParent(),
					ability = self:GetAbility(),
					damage = self.percentage_damage ~= nil and enemy:GetMaxHealth()*0.01*self.percentage_damage or self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( DamageInfo )
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Techies.LandMine.Detonate", self:GetParent() )
		self:GetParent():ForceKill( false )
	end
end