
require( "utility_functions" )

modifier_passive_autocast = class({})

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:OnCreated( kv )
	if IsServer() then
		self.nCastBehavior = kv[ "cast_behavior" ]
		self.nTargetType = kv[ "target_type" ]
		self.flHealthPercent = kv[ "health_percent" ]
		self.nRange = kv[ "range" ]
		self.flNextCastTime = GameRules:GetGameTime()

		-- If waiting for CD, then don't cast immediately
		if self.nCastBehavior == ASCENSION_CAST_WHEN_COOLDOWN_READY then
			local flCooldownTime = self:GetAbility():GetCooldownTimeRemaining()
			if flCooldownTime > 0 then
				self.flNextCastTime = GameRules:GetGameTime() + flCooldownTime + RandomFloat( 0.1, 1.0 );
			else
				self.flNextCastTime = GameRules:GetGameTime() + RandomFloat( 1.0, 3.0 );
			end
		end

		--print( "modifier_passive_autocast created " .. self:GetParent():GetUnitName() .. " " .. self:GetAbility():GetAbilityName() .. " " .. self.nCastBehavior .. " " .. self.nTargetType )

		if self.nCastBehavior == ASCENSION_CAST_WHEN_COOLDOWN_READY or 
			self.nCastBehavior == ASCENSION_CAST_ON_LOW_HEALTH or 
			self.nCastBehavior == ASCENSION_CAST_ON_NEARBY_ENEMY
			then
			self:StartIntervalThink( 0.1 )
		elseif self.nCastBehavior == ASCENSION_CAST_ON_DEATH then
			if bitand( self:GetAbility():GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNRESTRICTED ) == 0 then
				print( "*** WARNING: OnDeath behaviors must have DOTA_ABILITY_BEHAVIOR_UNRESTRICTED set " .. self:GetAbility():GetAbilityName() )
			end
		end

		if self.nTargetType == ASCENSION_TARGET_NO_TARGET then
			if bitand( self:GetAbility():GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) ~= 0 then
				self.nTargetType = ASCENSION_TARGET_RANDOM_PLAYER
				print( "*** WARNING: DOTA_ABILITY_BEHAVIOR_UNIT_TARGET didn't specify a target type " .. self:GetAbility():GetAbilityName() )
			end
		end

	end
end

--------------------------------------------------------------------------------

function modifier_passive_autocast:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:GetAttributes()
	-- Needed because we may have many ascension abilities on the same unit
	-- and we need one passive_autocast modifier per ability
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
 
 --------------------------------------------------------------------------------

function modifier_passive_autocast:OnTakeDamage( params )
	if IsServer() == false then
		return 0
	end

	if params.unit ~= self:GetParent() then
		return 0
	end

	if self.nCastBehavior ~= ASCENSION_CAST_ON_TAKE_MAGIC_DAMAGE then
		return 0
	end

	if params.damage_type ~= DAMAGE_TYPE_MAGICAL then
		return 0
	end

	self:CastModifierAbility( params.attacker )
	return 0 
end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:OnIntervalThink()

	if not IsServer() then
		return
	end

	local hCaster = self:GetCaster()
	if hCaster == nil then
		return
	end

	if self.flNextCastTime < 0 or self.flNextCastTime > GameRules:GetGameTime() then
		return
	end

	if self.nCastBehavior == ASCENSION_CAST_ON_LOW_HEALTH then
		if hCaster:GetHealthPercent() > self.flHealthPercent then
			return
		end
	end

	-- For CAST ON NEARBY ENEMY, check for enemies within range
	if self.nCastBehavior == ASCENSION_CAST_ON_NEARBY_ENEMY then
		local vecEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), 
			nil, self.nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		if #vecEnemies == 0 then
			return
		end
	end

	-- Specifically for firefily + wave blaster, wait until leap
	if self:GetAbility():GetAbilityName() == "aghsfort_ascension_firefly" then
		if hCaster:GetUnitName() == "npc_dota_creature_wave_blaster" then
			if hCaster:FindModifierByName( "modifier_aghsfort_waveblaster_leap" ) == nil then
				return
			end
		end
	end

	self:CastModifierAbility( nil )

end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:SelectClumpedPlayer()

	local vecPlayers = GetAliveHeroesInRoom( )
	local hBestTarget = nil
	local flClumpAmount = 1000000000

	for i=1,#vecPlayers do
		local hTarget = vecPlayers[i]
		local flDist = 0
		for j=1,#vecPlayers do
			if i~=j then
				local flCurDist = ( hTarget:GetAbsOrigin() - vecPlayers[j]:GetAbsOrigin() ):Length2D()
				if self.nRange ~= nil and flCurDist > self.nRange then
					flCurDist = self.nRange
				end
				flDist = flDist + flCurDist
			end
		end
		if flDist < flClumpAmount then
			hBestTarget = hTarget
			flClumpAmount = flDist
		end
	end
	return hBestTarget

end

-----------------------------------------------------------------------------------------

function modifier_passive_autocast:CastModifierAbility( hAttackerUnit )

	if self.flNextCastTime < 0 or self.flNextCastTime > GameRules:GetGameTime() then
		return
	end

	if self:GetAbility() == nil or self:GetAbility():IsFullyCastable() == false then
		return
	end

	local hCaster = self:GetCaster()
	if hCaster == nil then
		return
	end

	-- NOTE: This is a little tricky. We're trying to completely avoid using 
	-- orders / behaviors for the passive so it doesn't interrupt normal AI behavior
	-- However, for dummy casters, it's no problem since we know those are the 
	-- global encounter entity used for environmental effects so there's nothing to interrupt

	local bIsDummyCaster = hCaster:GetUnitName() == "npc_dota_dummy_caster"
	local nBehavior = self:GetAbility():GetBehavior()

	--print( "modifier_passive_autocast cooldown-based cast " .. self:GetParent():entindex() .. " " .. self:GetParent():GetUnitName() .. " " .. self:GetAbility():GetAbilityName() )

	if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED ) ~= 0 then

		if not bIsDummyCaster then
			print( "*** WARNING: Channeled behaviors cannot be autocast from normal units " .. self:GetAbility():GetAbilityName() )
			return
		end

		ExecuteOrderFromTable({
			UnitIndex = hCaster:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
			Queue = false,
		})

	else

		local hTarget = nil
		if self.nTargetType == ASCENSION_TARGET_RANDOM_PLAYER then
			local vecPlayers = GetAliveHeroes( )
			local nPlayerCount = #vecPlayers
			if nPlayerCount > 0 then
				local nPlayer = math.random( 1, nPlayerCount )
				hTarget = vecPlayers[nPlayer]
			end
		elseif self.nTargetType == ASCENSION_TARGET_CLUMPED_PLAYER then
			hTarget = self:SelectClumpedPlayer()
		elseif self.nTargetType == ASCENSION_TARGET_ATTACKER then
			hTarget = hAttackerUnit
		end

		if hTarget == nil and self.nTargetType ~= ASCENSION_TARGET_NO_TARGET then
			return
		end

		hCaster:SetCursorCastTarget( hTarget )
		self:GetAbility():CastAbility()

	end

	if self.nCastBehavior ~= ASCENSION_CAST_ON_LOW_HEALTH then
		local flCooldown = self:GetAbility():GetEffectiveCooldown( -1 )
		self.flNextCastTime = GameRules:GetGameTime() + flCooldown + RandomFloat( 0.01, 1.0 )
	else
		-- Cast on low health only gets to cast once
		self.flNextCastTime = -1
	end

end

--------------------------------------------------------------------------------

function modifier_passive_autocast:OnDeath( params )
	if IsServer() then
		if self.nCastBehavior == ASCENSION_CAST_ON_DEATH then
			local hUnit = params.unit
			if hUnit:entindex() == self:GetParent():entindex() then
				--print( "modifier_passive_autocast death-based cast " .. self:GetParent():GetUnitName() .. " " .. self:GetAbility():GetAbilityName() )
				self:GetAbility():EndCooldown()
				self.flNextCastTime = GameRules:GetGameTime()
				self:CastModifierAbility( params.attacker )
			end
		end
	end
end

