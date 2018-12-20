modifier_rubick_boss_passive = class({})


_G.TELEKINESIS_MINIONS =
{
	{
		szUnitName =  "npc_dota_creature_rubick_melee_creep",
		nPerSpawn = 6,
		nWeight = 3,
	},
	{
		szUnitName =  "npc_dota_creature_rubick_ogre_seal",
		nPerSpawn = 1,
		nWeight = 1,
	},
}

_G.FADE_BOLT_MINIONS =
{
	{
		szUnitName =  "npc_dota_creature_rubick_melee_creep",
		nPerSpawn = 6,
		nWeight = 4,
	},
	{
		szUnitName =  "npc_dota_creature_rubick_ogre_seal",
		nPerSpawn = 2,
		nWeight = 1,
	},
	{
		szUnitName =  "npc_dota_creature_broodmother",
		nPerSpawn = 1,
		nWeight = 1,
	},
}

_G.SPELL_STEAL_MINIONS =
{
	{
		szUnitName =  "npc_dota_creature_rubick_melee_creep",
		nPerSpawn = 6,
		nWeight = 11,
	},
	{
		szUnitName =  "npc_dota_creature_storegga",
		nPerSpawn = 1,
		nWeight = 1,
	},
	{
		szUnitName =  "npc_dota_creature_medium_spectre",
		nPerSpawn = 1,
		nWeight = 1,
	},
	{
		szUnitName =  "npc_dota_creature_rubick_ogre_seal",
		nPerSpawn = 1,
		nWeight = 2,
	},
}

_G.SPELL_STEAL_SPELLS =
{
	"rubick_chaos_meteor",
	"rubick_boss_freezing_field",
	"rubick_boss_ghostship",
	"rubick_boss_mystic_flare",
--	"rubick_boss_black_hole",
}


TELEKINESIS_CYCLES = 9
SPELL_STEAL_PROJECTILES_PER_THINK = 1

BONUS_CHICKEN =
{
	szUnitName = "npc_dota_creature_bonus_chicken",
	nPerSpawn = 1,
}

BONUS_PENGUIN =
{
	szUnitName = "npc_dota_sled_penguin",
	nPerSpawn = 1,
}


MAX_SUMMONED_UNIT_COUNT = 40
SUMMONED_UNITS = { }
DISABLE_SUMMONING = false

TELEKINESIS_POSITIONS =
{
	Vector( 1660, -4146, 384 ),
	Vector( 2359, -92, 384 ),
	Vector( 2278, 1372, 384 ),
	Vector( 4122, 497, 384 ),
	Vector( 4119, 657, 384 ),
	
}

FADE_BOLT_POSITIONS =
{
	Vector( 3204, 705, 256 ),
	Vector( 1264, 175, 256 ),
	Vector( 877, -2428, 256 ),
	Vector( 946, -2508, 256 ),
	Vector( -280, -1660, 256 ),
}

CHAOTIC_MODE = false

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:IsAura()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetModifierAura()
	if IsServer() then
		if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS then
			return ""
		end

		if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS then
			return ""
		end

		if self:GetParent().Phase == RUBICK_PHASES.SPELL_STEAL then
			return ""
		end
	end
	
	return ""
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetAuraRadius()
	if IsServer() then
		if self:GetParent().Phase == RUBICK_PHASES.NORMAL then
			return 0
		end
	end
	return FIND_UNITS_EVERYWHERE
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:OnCreated( kv )
	if IsServer() then
		self.hTelekinesis = self:GetCaster():FindAbilityByName( "rubick_telekinesis" )
		self.hBossBlink = self:GetCaster():FindAbilityByName( "rubick_boss_blink" )
		self.hTelekinesisLand = self:GetCaster():FindAbilityByName( "rubick_telekinesis_land" )
		self.FadeBoltsAbility = self:GetCaster():FindAbilityByName( "rubick_boss_linear_fade_bolts" )
		self.fade_bolt_interval = self:GetAbility():GetSpecialValueFor( "fade_bolt_interval" )

		self.flPhaseRepeatTime = 999999
		self.flPhaseEndTime = 0
		self.flThinkTime = 0.5
		self.hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
		self:StartIntervalThink( self.flThinkTime )
	end
end


--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() == false then
			return
		end

		local Friendlies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		for _,Unit in pairs ( Friendlies ) do
			if Unit ~= nil and not Unit:IsNull() and Unit:GetAggroTarget() == nil and Unit ~= self:GetCaster() then
				if not self.hAncient:IsNull() then
					ExecuteOrderFromTable({
						UnitIndex = Unit:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
						Position = self.hAncient:GetOrigin(),
					})
				end
			end
		end

		if #Friendlies > MAX_SUMMONED_UNIT_COUNT then
			--print( "Disable summoning, reached max count." )
			DISABLE_SUMMONING = true
		else
			--print( "Renable summoning." )
			DISABLE_SUMMONING = false
		end


		if self:GetCaster().bChangePhase == true then
			self:GetCaster().bChangePhase = false
			self.flPhaseRepeatTime = 0
		end	

		if GameRules:GetGameTime() > self.flPhaseRepeatTime then
			self:BeginPhase()
		end

		if self.flPhaseEndTime > GameRules:GetGameTime() then
			self:GetCaster().bInActivePhase = true
			if self:GetCaster().Phase == RUBICK_PHASES.TELEKINESIS then
				self:TelekinesisPhase_Think()
			end
			if self:GetCaster().Phase == RUBICK_PHASES.FADE_BOLTS then
				self:FadeBoltsPhase_Think()
			end
			if self:GetCaster().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetCaster().Phase == RUBICK_PHASES.INSANE then
				self:SpellStealPhase_Think()
			end
		else
			self:GetCaster():RemoveModifierByName( "modifier_rubick_boss_flying" )
			if self:GetCaster().bInActivePhase == true then
				self:GetCaster().bInActivePhase = false
				if self:GetCaster().Phase == RUBICK_PHASES.TELEKINESIS then
					self:TelekinesisPhase_End()
				end
				if self:GetCaster().Phase == RUBICK_PHASES.FADE_BOLTS then
					self:FadeBoltsPhase_End()
				end
				if self:GetCaster().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetCaster().Phase == RUBICK_PHASES.INSANE then
					self:SpellStealPhase_End()
				end
			end
		end
		if self.TargetPreviewFXs ~= nil then
			for k,FX in pairs ( self.TargetPreviewFXs ) do
				if FX ~= nil then
					if GameRules:GetGameTime() > FX.destroy_time then
						ParticleManager:DestroyParticle( FX.idx, true )
						table.remove( self.TargetPreviewFXs, k )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:BeginPhase()
	if IsServer() then
		if self:GetCaster().Phase == RUBICK_PHASES.TELEKINESIS then
			self:TelekinesisPhase_Begin()
		end

		if self:GetCaster().Phase == RUBICK_PHASES.FADE_BOLTS then
			self:FadeBoltsPhase_Begin()
		end

		if self:GetCaster().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetCaster().Phase == RUBICK_PHASES.INSANE then
			self:SpellStealPhase_Begin()
		end
		self.flPhaseEndTime = GameRules:GetGameTime() + PHASE_DURATION
		self.flPhaseRepeatTime = GameRules:GetGameTime() + PHASE_DURATION + TRIGGER_PHASE_CD
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:CreateMinions( vPos )
	if IsServer() then
		if DISABLE_SUMMONING == true then
			return
		end

		local MINIONS_TABLE = nil
		local Minion = nil
		local MinionsCreated = {}

		if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS then
			MINIONS_TABLE = TELEKINESIS_MINIONS
		end
		if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS then
			MINIONS_TABLE = FADE_BOLT_MINIONS
		end
		if self:GetParent().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetParent().Phase == RUBICK_PHASES.INSANE then
			MINIONS_TABLE = SPELL_STEAL_MINIONS
		end

		if MINIONS_TABLE == nil then
			print( "ERROR - Minions Table is nil" )
		end

		local nTotalWeight = 0
		for _,v in pairs ( MINIONS_TABLE ) do
			nTotalWeight = nTotalWeight + v.nWeight
		end

		local nRoll = RandomInt( 0, nTotalWeight )
		local nAccumWeight = 0
		for _,entry in pairs( MINIONS_TABLE ) do
			nAccumWeight = nAccumWeight + entry.nWeight
			if nRoll <= nAccumWeight then
				MinionToSpawn = entry
				break
			end
		end	

		if MinionToSpawn ~= nil then	
			local nTeam = self:GetCaster():GetTeamNumber()

			for i=1,MinionToSpawn.nPerSpawn do
				
				local hMinion = CreateUnitByName( MinionToSpawn.szUnitName, vPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hMinion then
					table.insert( MinionsCreated, hMinion )
					table.insert( SUMMONED_UNITS, hMinion )
					hMinion:AddNewModifier( self:GetCaster(), self, "modifier_rubick_boss_minion_building_damage", {} )
				end	
			end
		else
			print( "ERROR - MinionToSpawn is nil" )
		end

		return MinionsCreated
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetCenterOfEnemyHeroes()
	local vCenterOfHeroes = nil
	local Heroes = HeroList:GetAllHeroes()
	if #Heroes == 0 then
		return vec3_invalid
	end

	local nValidHeroes = 0
	for _,hero in ipairs( Heroes ) do
		if hero ~= nil and hero:IsRealHero() and hero:IsAlive() and hero ~= self:GetParent() then
			if vCenterOfHeroes == nil then
				vCenterOfHeroes = hero:GetOrigin()
			else
				vCenterOfHeroes = vCenterOfHeroes + hero:GetOrigin()
			end
			nValidHeroes = nValidHeroes + 1
		end
	end

	if vCenterOfHeroes == nil or nValidHeroes == 0 then
		return vec3_invalid
	end
		
	return ( vCenterOfHeroes / nValidHeroes )
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_Begin()
	if IsServer() then
		self.hTelekinesis:EndCooldown()
		self.hTelekinesisLand:EndCooldown()
		self.hBossBlink:EndCooldown()

		self.MinionsThisLoop = {}
		self.bPickedUpMinions = false
		self.bThrewMinions = false
		self.TargetPreviewFXs = {}
		self.nNextTargetFX = nil
		self.bBlinkInProgress = false
		self.vTKBlinkLocation = nil
		self.flTelekinesisLoopTimeLeft = -1
		self.nCompletedCycles = 0
		self.nTelekinesisNumCyclesNeeded = TELEKINESIS_CYCLES
		self.flPerTelekinesisTime = PHASE_DURATION / self.nTelekinesisNumCyclesNeeded -- total time to pick up and land
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_Think()
	if IsServer() then
		self.flTelekinesisLoopTimeLeft = self.flTelekinesisLoopTimeLeft - self.flThinkTime
		--print( "Telekinesis Loop Time Left: " .. self.flTelekinesisLoopTimeLeft )
		if self.flTelekinesisLoopTimeLeft > 0 then
			if self.MinionsThisLoop and #self.MinionsThisLoop == 0 then
				self:TelekinesisPhase_SpawnMinionsAndCastTelekinesis()
			else
				self:TelekinesisPhase_CastTelekinesisLand()
			end
		else
			self:TelekinesisPhase_ResetLoop()
			self:TelekinesisPhase_CastBlink()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_CastBlink()
	if IsServer() then
		self.hBossBlink:EndCooldown()
		-- A central position to all player heroes, but offset slightly.  I want to be close to them, but not -too- close.
		local vNewLocation = self:GetCenterOfEnemyHeroes() + ( RandomVector( 1 ) * 2000 )

		self.vTKBlinkLocation = vNewLocation
		self:GetCaster():CastAbilityOnPosition( self.vTKBlinkLocation, self.hBossBlink, self:GetCaster():GetPlayerOwnerID() )
		self.bBlinkInProgress = true
	--	print( "Blink to a different place!" )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_SpawnMinionsAndCastTelekinesis()
	if IsServer() then
	--	print( "Start spawning minions.." )
	--	print( "I have " .. self.flTelekinesisLoopTimeLeft .. " to complete my loop." )

		if self.bBlinkInProgress == true then
		--	print( "Can't, blink is in progress" ) 
			return
		end
	
		self.MinionsThisLoop = self:CreateMinions( self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 100 )
		if self.MinionsThisLoop ~= nil then
			print( "Created " .. #self.MinionsThisLoop .. " minions, try to pick 'em up" )
			self.hTelekinesis:EndCooldown()	
			self:GetCaster():CastAbilityOnTarget( self.MinionsThisLoop[1], self.hTelekinesis, self:GetCaster():GetPlayerOwnerID() )
		end
	end	
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_CastTelekinesisLand()
	if IsServer() then
		if self.bPickedUpMinions and not self.bThrewMinions and self.nNextTargetFX == nil then
			local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
			if #Heroes > 0 then
				local HeroTarget = Heroes[RandomInt( 1, #Heroes)]
				if HeroTarget ~= nil then
					--print( "Throwing my units at " .. HeroTarget:GetUnitName() )
					self.hTelekinesisLand:EndCooldown()
					self:GetCaster():CastAbilityOnPosition( HeroTarget:GetOrigin(), self.hTelekinesisLand, self:GetCaster():GetPlayerOwnerID()  )
					self.vLastThrowTarget = HeroTarget:GetOrigin()
					self.nNextTargetFX = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( self.nNextTargetFX, 0, HeroTarget:GetOrigin() )
					ParticleManager:SetParticleControl( self.nNextTargetFX, 1, Vector( 3.0 , 0, 0 ) )
					ParticleManager:SetParticleControl( self.nNextTargetFX, 2, HeroTarget:GetOrigin()  )

					local AngleY = 0
					for i=1,8 do
						local vDirection = HeroTarget:GetOrigin() - self:GetCaster():GetOrigin()
						local angle = VectorToAngles( vDirection ) 
						angle.y = AngleY
						local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControl( nFXIndex, 0, HeroTarget:GetOrigin() + RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) * 300 )
						ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.9 , 0, 0 ) )
						ParticleManager:SetParticleControl( nFXIndex, 2, HeroTarget:GetOrigin() + RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) * 300   )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
						AngleY = AngleY + 45
					end
				--	print( "Issuing throw command with " .. self.flTelekinesisLoopTimeLeft .. " time remaining." )
				
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_ResetLoop()
	if IsServer() then
		self.MinionsThisLoop = {}
		self.bThrewMinions = false
		self.bPickedUpMinions = false
		self.nCompletedCycles = self.nCompletedCycles + 1

		self.flTelekinesisLoopTimeStart = GameRules:GetGameTime()
		self.flTelekinesisLoopTimeLeft = self.flPerTelekinesisTime
	--	print( "Starting new loop @ " .. self.flTelekinesisLoopTimeStart )
	--	print( "I have " .. self.flTelekinesisLoopTimeLeft .. " to complete my loop." )
	end
end
		
--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:TelekinesisPhase_End()
	self.hBossBlink:EndCooldown()
	local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #Heroes > 0 then
		local HeroTarget = Heroes[RandomInt( 1, #Heroes)]
		if HeroTarget ~= nil then
			self.bBlinkInProgress = true
			self:GetCaster():CastAbilityOnPosition( HeroTarget:GetOrigin() + RandomVector( 1 ) * 400, self.hBossBlink, self:GetCaster():GetPlayerOwnerID() )
		end
	end

end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:FadeBoltsPhase_Begin()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_rubick_boss_flying", {} )
		self.bFadeBoltCastInFlight = false
		self.bHasCastFadeBoltAtLocation = false
		self:FadeBoltsPhase_ChangeFlyDirection()
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:FadeBoltsPhase_Think()
	if IsServer() then
		local flDist = ( self:GetCaster():GetOrigin() - self.vFlyLocation ):Length2D()
		if flDist < 100.0 and self.bHasCastFadeBoltAtLocation == false and self.FadeBoltsAbility:IsCooldownReady() then
			self:FadeBoltsPhase_CastFadeBolts()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:FadeBoltsPhase_ChangeFlyDirection()
	if IsServer() then
		local vNewLocation = FADE_BOLT_POSITIONS[RandomInt( 1, #FADE_BOLT_POSITIONS)]
		
		ExecuteOrderFromTable({
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vNewLocation,
		})
		self.vFlyLocation = vNewLocation
		self.bHasCastFadeBoltAtLocation = false
		self:CreateMinions( self:GetCaster():GetOrigin() )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:FadeBoltsPhase_CastFadeBolts()
	if IsServer() then
		if self.bFadeBoltCastInFlight == false then
			self.bFadeBoltCastInFlight = true
			self.bHasCastFadeBoltAtLocation = true
			local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
			if #Heroes > 0 then
				self:GetCaster():CastAbilityOnPosition( Heroes[1]:GetOrigin(), self.FadeBoltsAbility, self:GetCaster():GetPlayerOwnerID() )
			end		
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:FadeBoltsPhase_End()
	self:GetCaster():RemoveModifierByName( "modifier_rubick_boss_flying" )
	self:TelekinesisPhase_End()
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:SpellStealPhase_Begin()
	if IsServer() then
		self:GetAbility().SpellStealProjectiles = {}
		self.szSpellNameForProjectile = SPELL_STEAL_SPELLS[RandomInt(1,#SPELL_STEAL_SPELLS)]

		self:GetParent():StartGesture( ACT_DOTA_CHANNEL_ABILITY_5 )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetCaster():GetOrigin() )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:SpellStealPhase_Think()
	if IsServer() then
		self:SpellStealPhase_CastSpellStealProjectile()
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:SpellStealPhase_CastSpellStealProjectile()
	if IsServer() then
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		if #Heroes > 0 then
			local nProjectileCount = SPELL_STEAL_PROJECTILES_PER_THINK
			local flTimeToReach = 1.5
			if self:GetParent().Phase == RUBICK_PHASES.INSANE then
				--nProjectileCount = nProjectileCount + 1
				flTimeToReach = 1.25
			end
			for i=1,nProjectileCount do
				
				local szSpellName = self.szSpellNameForProjectile
				if CHAOTIC_MODE == true or self:GetCaster().Phase == RUBICK_PHASES.INSANE then
					szSpellName = SPELL_STEAL_SPELLS[RandomInt(1,#SPELL_STEAL_SPELLS)]
				end

				local nRandom = RandomInt( 0, 4 )
				if nRandom == 4 and not DISABLE_SUMMONING then
					self:CreateMinions( self:GetCaster():GetOrigin() )
					return
				end

				--print( szSpellName )

				local hTargetHero = Heroes[RandomInt(1,#Heroes)]
				if hTargetHero ~= nil then
					local hThinker = CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_rubick_boss_spell_steal_thinker", { duration = -1 }, hTargetHero:GetOrigin(), self:GetCaster():GetTeamNumber(), false ) 
					local hBuff = hThinker:FindModifierByName( "modifier_rubick_boss_spell_steal_thinker" )
					if hThinker ~= nil and hBuff ~= nil then
						local vTarget = hThinker:GetOrigin()
						vTarget.z = vTarget.z + 64

						hThinker:SetOrigin( vTarget )

						local flDist = (vTarget - self:GetCaster():GetOrigin()):Length2D()
						
						local flSpeed = flDist / flTimeToReach

						local projectile =
						{
							Target = hThinker,
							Source = self:GetCaster(),
							Ability = self:GetAbility(),
							--EffectName = "particles/econ/items/rubick/rubick_arcana/rubick_arc_spell_steal_default.vpcf",
							iMoveSpeed = flSpeed,--self:GetSpecialValueFor( "spell_steal_proj_speed" ),
							vSourceLoc = self:GetCaster():GetOrigin(),
							bDodgeable = false,
							bProvidesVision = false,
						}

						

						local nFXIndex = ParticleManager:CreateParticle( "particles/rubick/rubick_frosthaven_spellsteal.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 1, hThinker, PATTACH_ABSORIGIN, nil, vTarget, true )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 2, Vector ( flSpeed, 0, 0 ) ) 

						ProjectileManager:CreateTrackingProjectile( projectile )

						hThinker.nFXIndex = nFXIndex

						local SpellStealInfo =
						{
							nProjHandle = nHandle,
							Thinker = hThinker,
						}

						
						if hBuff ~= nil then
							hBuff:SetSpell( szSpellName )
						end
						table.insert( self:GetAbility().SpellStealProjectiles, SpellStealInfo )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:SpellStealPhase_End()
	self:GetParent():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_5 )
	ParticleManager:DestroyParticle( self.nPreviewFX, false )
	self:TelekinesisPhase_End()
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,

	}
	return funcs
end
--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetModifierPercentageCooldownStacking( params )
	if IsServer() then
		if self:GetParent().Phase == RUBICK_PHASES.NORMAL then
			return 45
		end
		if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS then
			return 50
		end
		if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS then
			return 55
		end
		if self:GetParent().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetParent().Phase == RUBICK_PHASES.INSANE then
			return 60
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:GetModifierSpellAmplify_Percentage( params )
	if IsServer() then
		if self:GetParent().Phase == RUBICK_PHASES.NORMAL then
			return 115
		end
		if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS then
			return 140
		end
		if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS then
			return 165
		end
		if self:GetParent().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetParent().Phase == RUBICK_PHASES.INSANE then
			return 190
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit:GetOwnerEntity() == self:GetCaster() then
			for i = 1,#SUMMONED_UNITS do
				local unit = SUMMONED_UNITS[i]
				if unit == hUnit then
					table.remove( SUMMONED_UNITS, i )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:OnAbilityFullyCast( params )
	if IsServer() then
		local hAbility = params.ability

		if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS and self.flPhaseEndTime > GameRules:GetGameTime() then
			if hAbility:GetAbilityName() == "rubick_telekinesis" then
				local flDuration = self.flTelekinesisLoopTimeLeft
				for _,Minion in pairs( self.MinionsThisLoop ) do
					if Minion ~= nil then
						--print( "Adding modifiers to minions for " .. self.flTelekinesisLoopTimeLeft - 0.25 .. " seconds." )
						Minion:AddNewModifier( self:GetCaster(), self.hTelekinesis, "modifier_invulnerable", { duration = flDuration } )
						local hBuff = Minion:FindModifierByName( "modifier_rubick_telekinesis" )
						if hBuff == nil then
							Minion:AddNewModifier( self:GetCaster(), self.hTelekinesis, "modifier_rubick_telekinesis", { duration = flDuration } )
						else
							hBuff:SetDuration( flDuration, true )
						end
					end
				end
				self.bPickedUpMinions = true
			end
			if hAbility:GetAbilityName() == "rubick_telekinesis_land" then
				local Minion = self.MinionsThisLoop[1]
				if self.nNextTargetFX ~= nil and Minion ~= nil then
					local hTKModifier = Minion:FindModifierByName( "modifier_rubick_telekinesis" )
					if hTKModifier then
						--ParticleManager:SetParticleControl( self.nNextTargetFX, 1, Vector( hTKModifier:GetRemainingTime() , 0, 0 ) )
						local FX = { idx = self.nNextTargetFX, destroy_time = ( GameRules:GetGameTime() + hTKModifier:GetRemainingTime() ) }
						table.insert( self.TargetPreviewFXs, FX )
						self.nNextTargetFX = nil
						local kv = { duration = hTKModifier:GetRemainingTime(), vDamageCenter = self.vLastThrowTarget }
						local hBuff = Minion:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_rubick_boss_telekinesis_land_damage", kv )
						hBuff.vDamageCenter = self.vLastThrowTarget
					end
				end
				self.bThrewMinions = true
			end
			if hAbility:GetAbilityName() == "rubick_boss_blink" then
				self.bBlinkInProgress = false
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:OnAbilityEndChannel( params )
	if IsServer() then
		local hAbility = params.ability
		if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS and self.flPhaseEndTime > GameRules:GetGameTime() then
			if hAbility:GetAbilityName() == "rubick_boss_linear_fade_bolts" then
				self.bFadeBoltCastInFlight = false
				self:FadeBoltsPhase_ChangeFlyDirection()
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_passive:CheckState()
	local state =
	{
		
	}

	if IsServer() then
		if self:GetParent() and self:GetParent():FindModifierByName( "modifier_monkey_king_fur_army_soldier" ) then
			return state
		end

		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_STUNNED] = false
		state[MODIFIER_STATE_SILENCED] = false
		state[MODIFIER_STATE_PROVIDES_VISION] = true

		if self.flPhaseEndTime > GameRules:GetGameTime() then
			if self:GetParent().Phase == RUBICK_PHASES.TELEKINESIS then
				state[MODIFIER_STATE_INVISIBLE] = false
				state[MODIFIER_STATE_OUT_OF_GAME] = false
				state[MODIFIER_STATE_NO_UNIT_COLLISION] = false
				state[MODIFIER_STATE_DISARMED] = true
				state[MODIFIER_STATE_SILENCED] = false
				state[MODIFIER_STATE_ROOTED] = false
				--state[MODIFIER_STATE_INVULNERABLE] = true
				state[MODIFIER_STATE_MUTED] = false
				--state[MODIFIER_STATE_PROVIDES_VISION] = false
				--state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
				--state[MODIFIER_STATE_UNSELECTABLE] = true
				--state[MODIFIER_STATE_INVISIBLE] = true
			end
			if self:GetParent().Phase == RUBICK_PHASES.FADE_BOLTS then
				state[MODIFIER_STATE_INVISIBLE] = false
				state[MODIFIER_STATE_OUT_OF_GAME] = false
				state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
				state[MODIFIER_STATE_DISARMED] = true
				state[MODIFIER_STATE_SILENCED] = false
				state[MODIFIER_STATE_ROOTED] = false
				state[MODIFIER_STATE_INVULNERABLE] = false
				state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false
				state[MODIFIER_STATE_MUTED] = false
				state[MODIFIER_STATE_UNSELECTABLE] = true
				return state
			end

			if self:GetParent().Phase == RUBICK_PHASES.SPELL_STEAL or self:GetParent().Phase == RUBICK_PHASES.INSANE then
				state[MODIFIER_STATE_DISARMED] = true
				state[MODIFIER_STATE_ROOTED] = true
				state[MODIFIER_STATE_INVULNERABLE] = true
				state[MODIFIER_STATE_SILENCED] = true
				state[MODIFIER_STATE_OUT_OF_GAME] = true
				state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
				state[MODIFIER_STATE_PROVIDES_VISION] = false
				state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
				state[MODIFIER_STATE_UNSELECTABLE] = true
				state[MODIFIER_STATE_INVISIBLE] = true
				return state
			end
			
			
		else
			
			state[MODIFIER_STATE_OUT_OF_GAME] = false
			state[MODIFIER_STATE_NO_UNIT_COLLISION] = false
			state[MODIFIER_STATE_DISARMED] = false
			state[MODIFIER_STATE_SILENCED] = false
			state[MODIFIER_STATE_ROOTED] = false
			state[MODIFIER_STATE_INVULNERABLE] = false
			state[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false
			state[MODIFIER_STATE_MUTED] = false
		end
		
	end
	return state
end

--------------------------------------------------------------------------------



