modifier_boss_visage_passive = class({})

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_boss_visage_passive:CheckState()
	local state = {}

	if IsServer() then
		state[MODIFIER_STATE_HEXED] = false
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_SILENCED] = false
		state[MODIFIER_STATE_STUNNED] = self:GetParent().bStone
		state[MODIFIER_STATE_FROZEN] = self:GetParent().bStone
		state[MODIFIER_STATE_FEARED] = false
		state[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true
		state[MODIFIER_STATE_INVULNERABLE] = self:GetParent().bStone
		state[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = self:GetParent().bStone
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
		state[MODIFIER_STATE_UNSELECTABLE] = self:GetParent().bStone
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:OnCreated( kv )
	self.stone_threshold = self:GetAbility():GetSpecialValueFor( "stone_threshold" )
	self.soul_assumption_count = self:GetAbility():GetSpecialValueFor( "soul_assumption_count" )
	self.soul_assumption_damage = self:GetAbility():GetSpecialValueFor( "soul_assumption_damage" )
	self.soul_assumption_speed = self:GetAbility():GetSpecialValueFor( "soul_assumption_speed" )
	self.stone_duration = self:GetAbility():GetSpecialValueFor( "stone_duration" )
	self.familiar_wake_interval = self:GetAbility():GetSpecialValueFor( "familiar_wake_interval" )
	self.flStoneEndTime = -1
	self.flNextFamiliarTime = -1
	self.flAssumptionTime = -1
	self.nBonusSouls = 0
	self.Familiars = {}
	self.nStoneFX = -1
	self.nChannelFX = -1

	self:GetParent().bStone = false

	if IsServer() then
		self:StartIntervalThink( 0.25 )
		self.flDamageRemaining = self.stone_threshold
		self:GetAbility().Familiars = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		for k,v in pairs ( self:GetAbility().Familiars ) do
			if v:GetUnitName() ~= "npc_dota_boss_visage_familiar" then
				table.remove( self:GetAbility().Familiars, k )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:OnIntervalThink()
	if IsServer() then
		if self:GetParent().bStone == true and ( GameRules:GetGameTime() > self.flStoneEndTime ) then
			self:EndStoneForm()
		end

		if self.flNextFamiliarTime ~= -1 and ( GameRules:GetGameTime() > self.flNextFamiliarTime ) then
			local StoneFamiliars = {}
			for k,v in pairs ( self:GetAbility().Familiars ) do
				if v:FindModifierByName( "modifier_boss_visage_familiar_stone_form_buff" ) then
					table.insert( StoneFamiliars, v )
				end
			end

			if #StoneFamiliars > 0 then
				self:GetAbility():WakeFamiliar( StoneFamiliars[ RandomInt( 1, #StoneFamiliars ) ] ) 
				self.flNextFamiliarTime = GameRules:GetGameTime() + self.familiar_wake_interval
			end
		end

		if self.flAssumptionTime ~= -1 and ( GameRules:GetGameTime() > self.flAssumptionTime ) then
			ParticleManager:DestroyParticle( self.nChannelFX, false )
			self:DoSoulAssumption()
			self.flAssumptionTime = -1
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:GetModifierIgnoreCastAngle( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:GetModifierDisableTurning( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() and self:GetParent().bStone == false then
			self.flDamageRemaining = self.flDamageRemaining - params.damage
			if self.flDamageRemaining <= 0 then
				self:BeginStoneForm()
			end

			if self.flNextFamiliarTime == -1 then
				self.flNextFamiliarTime = GameRules:GetGameTime() + self.familiar_wake_interval
			end
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:DoSoulAssumption()
	if IsServer() then
		local hAliveHeroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		local nNumberAlivePlayers = #hAliveHeroes
		local nSouls = self.soul_assumption_count - ( AGHANIM_PLAYERS - nNumberAlivePlayers )
		nSouls = nSouls + self.nBonusSouls
		self.nBonusSouls = self.nBonusSouls + 1

		for _,hHero in pairs ( hAliveHeroes ) do
			nSouls = nSouls - 1
			self:LaunchSoulAssumption( hHero )
		end

		local PossibleFamiliars = deepcopy( self:GetAbility().Familiars )
		for i=1,nSouls do
			local nIdx = math.random( 1, #PossibleFamiliars )
			local hTargetFamiliar = PossibleFamiliars[ nIdx ]
			self:LaunchSoulAssumption( hTargetFamiliar )
			table.remove( PossibleFamiliars, nIdx )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:BeginStoneForm()
	if IsServer() then
		self:GetParent().bStone = true
		self.flStoneEndTime = GameRules:GetGameTime() + self.stone_duration
		self.flAssumptionTime = GameRules:GetGameTime() + 2.0

		self:GetParent():AddNewModifier( self:GetParent(), self, "modifier_boss_visage_familiar_statue_stone_form", { duration = self.stone_duration } )

		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:EndStoneForm()
	if IsServer() then
		print( "Ending Stone Form!" )
		self:GetParent().bStone = false
		self.flStoneEndTime = 9999999999999999999999999999
		self.flDamageRemaining = self.stone_threshold

		if self.nStoneFX ~= -1 then
			ParticleManager:DestroyParticle( self.nStoneFX, false )
			self.nStoneFX = -1
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_passive:LaunchSoulAssumption( hTarget )
	if hTarget == nil or IsServer() == false then
		return
	end

	local projectile =
	{
		Target = hTarget,
		Source = self:GetCaster(),
		Ability = self:GetAbility(),
		EffectName = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf",
		iMoveSpeed = self:GetAbility():GetSpecialValueFor( "soul_assumption_speed" ),
		vSourceLoc = self:GetCaster():GetOrigin(),
		bDodgeable = false,
		bProvidesVision = false,
		bIgnoreObstructions = true,
		iSourceAttachment = 1,
	}

	ProjectileManager:CreateTrackingProjectile( projectile )
	EmitSoundOn( "Hero_Visage.SoulAssumption.Cast", self:GetParent() )
end

