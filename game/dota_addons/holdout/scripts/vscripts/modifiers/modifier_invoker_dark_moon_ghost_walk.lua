modifier_invoker_dark_moon_ghost_walk = class({})

SPAWNER_POSITIONS = {
	SPAWNER_1_POS = Vector( -896, 3648, 608 ),
	SPAWNER_2_POS = Vector( -2496, -1664, 288 ),
	SPAWNER_3_POS = Vector( 320, -3840, 352 ),
	SPAWNER_4_POS = Vector( 5376, -3264, 352 )
}

PHASE_NONE = -1
PHASE_QUAS = 0
PHASE_WEX = 1
PHASE_EXORT = 2

CREEP_WAVE_CD = 30

REPEAT_PHASE_TIME = 40
MAX_FORGED_SPIRIT_COUNT = 40
SUMMONED_UNITS = { }

NORMAL_FORGED_SPIRITS = { }

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetModifierAura()
	if IsServer() then
		if self:GetParent().Phase == PHASE_QUAS then
			return "modifier_crystal_maiden_crystal_nova"
		end

		if self:GetParent().Phase == PHASE_WEX then
			return "modifier_invoker_dark_moon_ghost_walk_debuff"
		end

		if self:GetParent().Phase == PHASE_EXORT then
			return "modifier_item_radiance_debuff"
		end
	end
	
	return ""
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetAuraRadius()
	if IsServer() then
		if self:GetParent().Phase == PHASE_NONE then
			return 0
		end
	end
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
	if IsServer() then
		self.invis_time = 20 --self:GetAbility():GetSpecialValueFor( "invis_time" )
		self.nFXIndex = -1
		self.LastFXPhase = -1
		self.flCurrentThinkInterval = 1
		self.flPhaseInvisExpireTime = 0
		self.flPhaseRepeatTime = 99999
		self.bPhaseHasEnded = false
		self.hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )

		self:StartIntervalThink( self.flCurrentThinkInterval )
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:OnIntervalThink()
	if IsServer() then
		local phase = self:GetParent().Phase
		print( "Current Phase " .. phase )
		print( "FXPhase " .. self.LastFXPhase )
		if self.LastFXPhase ~= phase then
			if self.bPhaseHasEnded == false then
				self:EndPhase( self.LastFXPhase )
			else
				self:BeginPhase( phase )
			end
		end

		-- Tell Forged Spirits to attack-move the ancient
		for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
			if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
				if not self.hAncient:IsNull() then
					print( "make forged spirits attack move the ancient" )
					ExecuteOrderFromTable({
						UnitIndex = hForgedSpirit:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
						Position = self.hAncient:GetOrigin(),
					})
				end
			end
		end

		if self.flPhaseInvisExpireTime > GameRules:GetGameTime() then
			if phase == PHASE_QUAS then
				self:QuasPhase()
			end
			if phase == PHASE_WEX then
				self:WexPhase()
			end
			if phase == PHASE_EXORT then
				self:ExortPhase()
			end
			self.flCurrentThinkInterval = math.max( self.flCurrentThinkInterval - 0.02, 0.05 )
			self:StartIntervalThink( self.flCurrentThinkInterval )
			print( "Started New think " .. self.flCurrentThinkInterval )
		else
			self:StartIntervalThink( 1 )
		end

		if GameRules:GetGameTime() > self.flPhaseRepeatTime then
			self.LastFXPhase = PHASE_NONE
			self.flPhaseRepeatTime = 99999
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:EndPhase( phase )
	if IsServer() then
		print( "Ending Phase" )
		self:StartIntervalThink( 3 )
		self.flCurrentThinkInterval = 1
		self.bPhaseHasEnded = true
		StopSoundOn( "Hero_Tusk.FrozenSigil", self:GetCaster() )
		StopSoundOn( "Hero_DoomBringer.ScorchedEarthAura", self:GetCaster() )
		StopSoundOn( "Hero_Razor.Storm.Loop", self:GetCaster() )

		EmitSoundOn( "Hero_Invoker.GhostWalk", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:BeginPhase( phase )
	if IsServer() then
		print( "Beginning Phase" )
		self.LastFXPhase = phase
		self.bPhaseHasEnded = false
		self.flPhaseRepeatTime = GameRules:GetGameTime() + REPEAT_PHASE_TIME
		self.flPhaseInvisExpireTime = GameRules:GetGameTime() + self.invis_time

		if self.FXIndex ~= -1 then
			ParticleManager:DestroyParticle( self.nFXIndex, true )
		end
		
		if phase == PHASE_QUAS then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( self.nFXIndex , 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.aura_radius, self.aura_radius, self.aura_radius ) )
			self:AddParticle( self.nFXIndex, false, false, -1, false, false )

			EmitSoundOn( "Hero_Tusk.FrozenSigil", self:GetCaster() )
		end

		if phase == PHASE_WEX then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_magnetic_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 20.0, 20.0, 20.0 ) )
			ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( self.aura_radius, self.aura_radius, self.aura_radius ) )
			self:AddParticle( self.nFXIndex, false, false, -1, false, false )

			self:GetCaster():EmitSoundParams( "Hero_Razor.Storm.Loop", 0, 0.75, 20.0 )
		end

		if phase == PHASE_EXORT then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.aura_radius, 1, 1 ) )
			self:AddParticle( self.nFXIndex, false, false, -1, false, false )

			EmitSoundOn( "Hero_DoomBringer.ScorchedEarthAura", self:GetCaster() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:GetModifierPercentageCooldownStacking( params )
	if IsServer() then
		if self:GetParent().Phase == PHASE_EXORT then
			print( "CDReduction")
			return 25
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit:GetUnitName() ==  "npc_dota_creature_invoker_forged_spirit" then
			for i = 1,#SUMMONED_UNITS do
				local unit = SUMMONED_UNITS[i]
				if unit == hUnit then
					table.remove( SUMMONED_UNITS, i )
					print("removing from table")
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:CheckState()
	local state =
	{
		
	}

	if IsServer() then
		if self.flPhaseInvisExpireTime > GameRules:GetGameTime() then
			state[MODIFIER_STATE_INVISIBLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
			state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
			state[MODIFIER_STATE_DISARMED] = true
			state[MODIFIER_STATE_SILENCED] = true
			state[MODIFIER_STATE_ROOTED] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
			state[MODIFIER_STATE_MUTED] = true
			state[MODIFIER_STATE_PROVIDES_VISION] = false
		else
			state[MODIFIER_STATE_INVISIBLE] = false
			state[MODIFIER_STATE_OUT_OF_GAME] = false
			state[MODIFIER_STATE_NO_UNIT_COLLISION] = false
			state[MODIFIER_STATE_DISARMED] = false
			state[MODIFIER_STATE_SILENCED] = false
			state[MODIFIER_STATE_ROOTED] = false
			state[MODIFIER_STATE_INVULNERABLE] = false
			state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false
			state[MODIFIER_STATE_MUTED] = false
			state[MODIFIER_STATE_PROVIDES_VISION] = true
		end
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_STUNNED] = false
		state[MODIFIER_STATE_SILENCED] = false
	end
	return state
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase()
	if IsServer() then
		if self:GetParent():IsAlive() == false then
			return
		end

		-- make a wave of units on regular interval
		--[[
		if ( self.timeLastWaveCreated == nil ) or ( GameRules:GetGameTime() > self.timeLastWaveCreated + CREEP_WAVE_CD ) then
			self:ExortPhase_CreateUnitWave()
		end
		]]

		if ( self.timeNextBigSpell == nil ) or ( GameRules:GetGameTime() > self.timeNextBigSpell ) then
			self:ExortPhase_CastBigSpell()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_CastBigSpell()
	local nSpellToCast = RandomInt( 0, 2 )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		if nSpellToCast == 0 then
			self:ExortPhase_Meteor( enemies )
		elseif nSpellToCast == 1 then
			self:ExortPhase_SunStrike( enemies )
		elseif nSpellToCast == 2 then
			self:ExortPhase_CreateUnitsNearby( enemies )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_CreateUnitWave()
	print( "creating wave of Forged Spirits" )
	-- Make a bunch of Forged Spirits at the map spawner locations
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPosition in pairs( SPAWNER_POSITIONS ) do
			for i = 1, 4 do
				if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
					local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPosition, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					table.insert( SUMMONED_UNITS, hForgedSpirit )
				end
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			print( "make forged spirits attack move the ancient" )
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	self.timeLastWaveCreated = GameRules:GetGameTime()
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_CreateUnitsNearby()
	print( "CreateUnitsNearby()" )

	local bSpellCast = false

	local nSpawnCount = 4
	local randomPositionsNearby = { }
	for i = 1, nSpawnCount do
		local vRandomOffset = Vector( RandomInt( -500, 500 ), RandomInt( -500, 500 ), 0 )
		randomPositionsNearby[ i ] = self:GetCaster():GetAbsOrigin() + vRandomOffset
	end

	-- Make a bunch of units around boss
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPos in pairs( randomPositionsNearby ) do
			if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
				local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				table.insert( SUMMONED_UNITS, hForgedSpirit )
				bSpellCast = true
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 1
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_Meteor( enemies )
	local bSpellCast = false

	local nMeteors = 3

	for i = 1, nMeteors do
		local enemy = enemies[RandomInt( 1, #enemies) ]
		local hMeteor = self:GetCaster():FindAbilityByName( "invoker_chaos_meteor" )
		if hMeteor ~= nil then
			if hMeteor.precache == nil then
				hMeteor:OnSpellStart()
				hMeteor.precache = true
			end

			local vRandom = RandomVector( 700.0 )

			local vDir = enemy:GetOrigin() - ( enemy:GetOrigin() + vRandom )
			vDir = vDir:Normalized()
			vDir.z = 0.0
			local kv = 
			{
				duration = hMeteor:GetSpecialValueFor( "land_time" ),
				travel_speed = hMeteor:GetSpecialValueFor( "travel_speed" ),
				vision_distance = hMeteor:GetSpecialValueFor( "vision_distance" ),
			 	travel_distance = 700,
				dir_x = vDir.x,
				dir_y = vDir.y,
			}

			CreateModifierThinker( self:GetCaster(), hMeteor, "modifier_invoker_chaos_meteor_land", kv, enemy:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
			EmitSoundOnLocationForAllies( enemy:GetOrigin(), "Hero_Invoker.ChaosMeteor.Cast", enemy )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, ( enemy:GetOrigin() + vRandom ) + Vector( 0, 0, 1100 ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() + Vector( 0, 0, 90 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.4, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			bSpellCast = true
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 0.4
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_SunStrike( enemies )
	local bSpellCast = false

	for _,enemy in pairs( enemies ) do
		if enemy ~= nil then
			local hSunStrike = self:GetCaster():FindAbilityByName( "invoker_sun_strike" )
			if hSunStrike ~= nil then	
				local kv = 
				{
					duration = hSunStrike:GetSpecialValueFor( "delay" ),
					area_of_effect = hSunStrike:GetSpecialValueFor( "area_of_effect" ),
					vision_distance = hSunStrike:GetSpecialValueFor( "vision_distance" ),
				 	vision_duration = hSunStrike:GetSpecialValueFor( "vision_duration" ),
					damage = 1075 --hSunStrike:GetSpecialValueFor( "damage" ),
				}

				local vTarget = enemy:GetOrigin() + enemy:GetForwardVector() * 100

				CreateModifierThinker( self:GetCaster(), hSunStrike, "modifier_invoker_sun_strike", kv, vTarget, self:GetCaster():GetTeamNumber(), false )

				EmitSoundOnLocationForAllies( vTarget, "Hero_Invoker.SunStrike.Charge", enemy )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, vTarget )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 1, 1 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				bSpellCast = true
			end
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 0.6
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:ExortPhase_ForgedSpirit( enemies )
	-- Make a few Forged Spirits near each player
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() and hForgeSpiritAbility:IsFullyCastable() then
		for _, hEnemy in pairs( enemies ) do
			for i = 1, 4 do
				if #NORMAL_FORGED_SPIRITS < 10 then
					local vRandomOffset = Vector( RandomInt( -200, 200 ), RandomInt( -200, 200 ), 0 )
					local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", hEnemy:GetAbsOrigin() + vRandomOffset, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					table.insert( NORMAL_FORGED_SPIRITS, hForgedSpirit )
				end
			end
		end
	end

	-- Tell Forged Spirits to attack-move towards the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( NORMAL_FORGED_SPIRITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			print( "make forged spirits attack move the ancient" )
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:WexPhase()
	if IsServer() then
		if self:GetParent():IsAlive() == false then
			return
		end

		-- make a wave of units on regular interval
		--[[
		if ( self.timeLastWaveCreated == nil ) or ( GameRules:GetGameTime() > self.timeLastWaveCreated + CREEP_WAVE_CD ) then
			self:WexPhase_CreateUnitWave()
		end
		]]

		if ( self.timeNextBigSpell == nil ) or ( GameRules:GetGameTime() > self.timeNextBigSpell ) then
			self:WexPhase_CastBigSpell()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:WexPhase_CastBigSpell()
	local nSpellToCast = RandomInt( 0, 1 )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		if nSpellToCast == 0 then
			self:WexPhase_Tornados( enemies )
		elseif nSpellToCast == 1 then
			self:WexPhase_CreateUnitsNearby( enemies )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:WexPhase_CreateUnitWave()
	print( "creating wave of Forged Spirits" )
	-- Make a bunch of Forged Spirits at the map spawner locations
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPosition in pairs( SPAWNER_POSITIONS ) do
			for i = 1, 4 do
				if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
					local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPosition, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					table.insert( SUMMONED_UNITS, hForgedSpirit )
				end
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	self.timeLastWaveCreated = GameRules:GetGameTime()
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:WexPhase_CreateUnitsNearby()
	print( "CreateUnitsNearby()" )

	local bSpellCast = false

	local nSpawnCount = 4
	local randomPositionsNearby = { }
	for i = 1, nSpawnCount do
		local vRandomOffset = Vector( RandomInt( -500, 500 ), RandomInt( -500, 500 ), 0 )
		randomPositionsNearby[ i ] = self:GetCaster():GetAbsOrigin() + vRandomOffset
	end

	-- Make a bunch of units around boss
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPos in pairs( randomPositionsNearby ) do
			if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
				local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				table.insert( SUMMONED_UNITS, hForgedSpirit )
				bSpellCast = true
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 1
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:WexPhase_Tornados( enemies )
	local bSpellCast = false

	for enemyIndex, enemy in pairs( enemies ) do
		if enemy ~= nil then
			local bChance = RandomInt( 1, 10 ) > 2
			if bChance then
				local hTornado = self:GetCaster():FindAbilityByName( "invoker_tornado" )						
				if hTornado ~= nil then	
					local vRandomPosAroundCaster = self:GetCaster():GetAbsOrigin() + Vector( RandomInt( -2500, 2500 ), RandomInt( -2500, 2500 ), 0 )
					local vDir = enemy:GetOrigin() - vRandomPosAroundCaster
					vDir.z = 0
					vDir = vDir:Normalized()
					local info = 
					{
						EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
						Ability = hTornado,
						Source = self:GetCaster(),
						vSpawnOrigin = vRandomPosAroundCaster,
						fDistance = 4500,
						vVelocity = vDir * 450,
						fStartRadius = 170,
						fEndRadius = 170,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						bProvidesVision = false,
					}

					ProjectileID = ProjectileManager:CreateLinearProjectile( info )
					EmitSoundOn( "Hero_Invoker.Tornado.Cast", self:GetCaster() )

					bSpellCast = true
				end
			end
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 4.5
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:QuasPhase()
	if IsServer() then
		if self:GetParent():IsAlive() == false then
			return
		end

		-- make a wave of units on regular interval
		--[[
		if ( self.timeLastWaveCreated == nil ) or ( GameRules:GetGameTime() > self.timeLastWaveCreated + CREEP_WAVE_CD ) then
			self:QuasPhase_CreateUnitWave()
		end
		]]

		if ( self.timeNextBigSpell == nil ) or ( GameRules:GetGameTime() > self.timeNextBigSpell ) then
			self:QuasPhase_CastBigSpell()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:QuasPhase_CastBigSpell()
	local nSpellToCast = RandomInt( 0, 1 )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		if nSpellToCast == 0 then
			self:QuasPhase_ColdFeets( enemies )
		elseif nSpellToCast == 1 then
			self:QuasPhase_CreateUnitsNearby( enemies )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:QuasPhase_CreateUnitWave()
	print( "creating wave of Forged Spirits" )
	-- Make a bunch of Forged Spirits at the map spawner locations
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPosition in pairs( SPAWNER_POSITIONS ) do
			for i = 1, 4 do
				if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
					local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPosition, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					table.insert( SUMMONED_UNITS, hForgedSpirit )
				end
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	self.timeLastWaveCreated = GameRules:GetGameTime()
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:QuasPhase_CreateUnitsNearby()
	print( "CreateUnitsNearby()" )

	local bSpellCast = false

	local nSpawnCount = 3
	local randomPositionsNearby = { }
	for i = 1, nSpawnCount do
		local vRandomOffset = Vector( RandomInt( -500, 500 ), RandomInt( -500, 500 ), 0 )
		randomPositionsNearby[ i ] = self:GetCaster():GetAbsOrigin() + vRandomOffset
	end

	-- Make a bunch of units around boss
	local hForgeSpiritAbility = self:GetCaster():FindAbilityByName( "invoker_forge_spirit" )
	if not hForgeSpiritAbility:IsNull() then
		for _, vPos in pairs( randomPositionsNearby ) do
			if #SUMMONED_UNITS < MAX_FORGED_SPIRIT_COUNT then
				local hForgedSpirit = CreateUnitByName( "npc_dota_creature_invoker_forged_spirit", vPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				table.insert( SUMMONED_UNITS, hForgedSpirit )
				bSpellCast = true
			end
		end
	end

	-- Tell Forged Spirits to attack-move the ancient
	local hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	for _, hForgedSpirit in pairs( SUMMONED_UNITS ) do
		if not hForgedSpirit:IsNull() and hForgedSpirit:GetAggroTarget() == nil then
			ExecuteOrderFromTable({
				UnitIndex = hForgedSpirit:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = hAncient:GetOrigin(),
			})
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 1
	end
end

--------------------------------------------------------------------------------

function modifier_invoker_dark_moon_ghost_walk:QuasPhase_ColdFeets( enemies )
	local bSpellCast = false
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil then
			local hColdFeetDebuff = enemy:FindModifierByName( "modifier_cold_feet" )
			local hColdFeetStun = enemy:FindModifierByName( "modifier_ancientapparition_coldfeet_freeze" )
			if hColdFeetDebuff == nil and hColdFeetStun == nil then
				EmitSoundOn( "Hero_Ancient_Apparition.ColdFeetCast", enemy )
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_cold_feet", kv )
				bSpellCast = true
			end
		end
	end

	if bSpellCast then
		self.timeNextBigSpell = GameRules:GetGameTime() + 3
	end
end

--------------------------------------------------------------------------------

