
modifier_earthshaker_dirt_mound = class({})

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:IsHidden()
	return true
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:IsPurgable()
	return false
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:CheckState()
	local state =
	{
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = false,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
	}

	return state
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:OnCreated( kv )
	if IsServer() then
		self.spawn_min = self:GetAbility():GetSpecialValueFor( "spawn_min" )
		self.spawn_max = self:GetAbility():GetSpecialValueFor( "spawn_max" )
		self.trigger_radius = self:GetAbility():GetSpecialValueFor( "trigger_radius" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

		self.bBurst = false
		self.bTriggered = false

		self:StartIntervalThink( 0.25 )
	end
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:GetModifierProvidesFOWVision( params )
	return 1
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			self:Burst()
		end
	end
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:OnIntervalThink()
	if IsServer() then
		if self.bTriggered == false then
			local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.trigger_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			if #units > 0 then
				self.bTriggered = true

				return
			end
		else
			self:Burst()

			self:StartIntervalThink( -1 )
		end
	end
end

-------------------------------------------------------------------

function modifier_earthshaker_dirt_mound:Burst()
	if IsServer() then
		if self.bBurst == true then
			return
		end

		-- Get all the player heroes
		local nSearchRadius = 10000
		local nFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(),
				self:GetParent(), nSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO, nFlags, FIND_CLOSEST, false
		)

		local hAggroTarget = nil
		if #enemies >= 0 then
			printf( "modifier_earthshaker_dirt_mound - found enemies, setting hAggroTarget to closest one" )
			hAggroTarget = enemies[ 1 ]
		end

		for i = 0, RandomInt( self.spawn_min, self.spawn_max ) do
			local nMaxDistance = 25
			local vSpawnLoc = nil

			local nMaxAttempts = 3
			local nAttempts = 0

			repeat
				if nAttempts > nMaxAttempts then
					vSpawnLoc = nil
					printf( "WARNING - modifier_earthshaker_dirt_mound - failed to find valid spawn loc for muddite" )
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
				local hMinion = CreateUnitByName( "npc_dota_creature_earthshaker_minion", vSpawnLoc, true, nil, nil, DOTA_TEAM_BADGUYS )
				if hMinion ~= nil and hMinion:IsNull() == false and hAggroTarget ~= nil then
					--printf( "giving hMinion an AttackTargetOrder" )
					AttackTargetOrder( hMinion, hAggroTarget )
				end
			else
				printf( "WARNING - modifier_earthshaker_dirt_mound: failed to spawn newborn spider" )
			end
		end

		self.bBurst = true

		EmitSoundOn( "Broodmother.LarvalParasite.Burst", self:GetParent() )
		EmitSoundOn( "EggSac.Burst", self:GetParent() )

		self:GetParent():AddEffects( EF_NODRAW )
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------
