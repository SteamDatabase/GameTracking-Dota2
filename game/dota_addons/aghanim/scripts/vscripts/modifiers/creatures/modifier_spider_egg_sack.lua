
modifier_spider_egg_sack = class({})

-------------------------------------------------------------------

function modifier_spider_egg_sack:IsHidden()
	return true
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = false,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:OnCreated( kv )
	if IsServer() then
		self.spider_min = self:GetAbility():GetSpecialValueFor( "spider_min" )
		self.spider_max = self:GetAbility():GetSpecialValueFor( "spider_max" )
		self.trigger_radius = self:GetAbility():GetSpecialValueFor( "trigger_radius" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

		self.bBurst = false
		self.bTriggered = false
		self:StartIntervalThink( 0.25 )

	end
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Burst( nil )
		end
	end
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:OnIntervalThink()
	if IsServer() then
		if self.bTriggered == false then
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.trigger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #enemies > 0 then
				self.bTriggered = true
				return
			end
		else
			self:Burst( nil )
			self:StartIntervalThink( -1 )
		end
	end
end

-------------------------------------------------------------------

function modifier_spider_egg_sack:Burst( hHero )
	if IsServer() then
		if self.bBurst == true then
			return
		end

		local hTarget = hHero
		if hHero == nil then
			hTarget = self:GetParent()
		end 

		for i=0,RandomInt( self.spider_min, self.spider_max ) do
			local nMaxDistance = 25
			local vSpawnLoc = nil

			local nMaxAttempts = 3
			local nAttempts = 0

			repeat
				if nAttempts > nMaxAttempts then
					vSpawnLoc = nil
					printf( "WARNING - modifier_spider_egg_sack - failed to find valid spawn loc for newborn spider" )
					break
				end

				local vPos = self:GetParent():GetAbsOrigin() + RandomVector( nMaxDistance )
				vSpawnLoc = FindPathablePositionNearby( vPos, 0, 50 )
				nAttempts = nAttempts + 1
			until ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vSpawnLoc ) )

			if vSpawnLoc == nil then
				vSpawnLoc = self:GetParent():GetOrigin()
			end

			if vSpawnLoc ~= nil then
				CreateUnitByName( "npc_dota_creature_newborn_spider", vSpawnLoc, true, nil, nil, DOTA_TEAM_BADGUYS )
			else
				printf( "WARNING - modifier_spider_egg_sack: failed to spawn newborn spider" )
			end
		end

		self.bBurst = true

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius / 2, 0.4, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs ( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				--print( "Add modifier for " .. self.duration )
				enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_venomancer_poison_nova", { duration = self.duration } )
			end
		end
		
		EmitSoundOn( "Broodmother.LarvalParasite.Burst", self:GetParent() )
		EmitSoundOn( "EggSac.Burst", self:GetParent() )
		self:GetParent():AddEffects( EF_NODRAW )
		self:GetParent():ForceKill( false )
	end
end

