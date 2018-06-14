modifier_creature_armed_dynamite = class({})

--------------------------------------------------------------------------------

function modifier_creature_armed_dynamite:OnCreated( kv )
	if IsServer() then
		self.flDelay = 4
		self.flArmTime = GameRules:GetGameTime()
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_armed_dynamite:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		state[MODIFIER_STATE_INVISIBLE] = false
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_creature_armed_dynamite:OnIntervalThink()
	if IsServer() then
		local flNow = GameRules:GetGameTime()
		if (flNow - self.flArmTime) >= self.flDelay then
			self:Explode()
		end
		EmitSoundOn("Hero_Techies.LandMine.Priming", self:GetParent() );	
	end
end

function modifier_creature_armed_dynamite:Explode()

	local radius = 500
	local vPos = self:GetParent():GetOrigin()
	local Units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vPos, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	--printf( "%d units around %s", #Units, vPos )

	for _,hUnit in pairs( Units ) do

		--printf( "unit %s position = %s", hUnit:GetUnitName(), hUnit:GetAbsOrigin() )

		if hUnit:GetUnitName() == "npc_dota_cavern_gate_blocked" then
			local hGate = CCavernGate.GetGateFromPosition( hUnit:GetOrigin() )
			hGate:SetPath( nil, nil, CAVERN_PATH_TYPE_OPEN )
		else
			local flDamage = 1000
			for _, szGateName in pairs( DestructibleGateNames ) do
				if hUnit:GetUnitName() == szGateName then
					flDamage = 90000
				end
			end
			local DamageInfo =
			{
				victim = hUnit,
				attacker = self:GetParent(),
				ability = self:GetAbility(),
				damage = flDamage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			local flDamageDone = ApplyDamage( DamageInfo )
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, radius ) )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Techies.LandMine.Detonate", self:GetParent() )
	self:GetParent():ForceKill( false )

end