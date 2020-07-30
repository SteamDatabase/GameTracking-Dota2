aghsfort_enraged_wildwing_tornado_blast = class({})

----------------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/wildwing_tornado_blast_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )

end
--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 175, 175, 175 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 140, 0 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		
		local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.travel_speed = self:GetSpecialValueFor( "travel_speed" )
		self.area_of_effect = self:GetSpecialValueFor( "area_of_effect" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.disable_duration = self:GetSpecialValueFor( "disable_duration" )
		self.travel_distance = self:GetSpecialValueFor( "travel_distance" )
		self.spawns_per_blast = self:GetSpecialValueFor( "spawns_per_blast" )
		self.harpy_spawn_amount = self:GetSpecialValueFor( "harpy_spawn_amount" )

		self.spawn_interval = (self.travel_distance / self.travel_speed) / self.harpy_spawn_amount - 0.1

		local info = {
			EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.area_of_effect,
			fEndRadius = self.area_of_effect,
			vVelocity = vDirection * self.travel_speed,
			fDistance = self.travel_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		}


		self.flLastThinkTime = GameRules:GetGameTime()
		self.nProjID = ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Ability.TornadoBlast.Cast" , self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:OnProjectileThink( vLocation )
	if GameRules:GetGameTime() - self.flLastThinkTime >= self.spawn_interval then 
		self.flLastThinkTime = GameRules:GetGameTime()

		if self:GetCaster().Encounter and self:GetCaster().Encounter:GetRoom() and self:GetCaster().Encounter:GetRoom():IsInRoomBounds( vLocation ) then
			self:SpawnHarpy(vLocation)
		end
	end
end


--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = this,
		}

		ApplyDamage( damage )
		if not hTarget:FindModifierByName("modifier_aghsfort_wildwing_tornado_blast_debuff") then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_aghsfort_wildwing_tornado_blast_debuff", { duration = self.disable_duration} )
		end
	end

	return false
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function aghsfort_enraged_wildwing_tornado_blast:SpawnHarpy( vLocation )
	if IsServer() then
 		
 		for i = 1, self.harpy_spawn_amount do
	 		local hHarpy = CreateUnitByName( "npc_aghsfort_creature_tornado_harpy", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	 		local nMaxDistance = 200
	 		local vLoc = FindPathablePositionNearby(vLocation, 150, nMaxDistance )
			if self:GetCaster().Encounter and self:GetCaster().Encounter:GetRoom() and self:GetCaster().Encounter:GetRoom():IsInRoomBounds( vLoc ) then
				
		 		if hHarpy ~= nil then 
					hHarpy:SetInitialGoalEntity( self:GetCaster().hInitialGoalEntity )
					hHarpy:SetDeathXP( 0 )
					hHarpy:SetMinimumGoldBounty( 0 )
					hHarpy:SetMaximumGoldBounty( 0 )

					local kv =
					{
						vLocX = vLoc.x,
						vLocY = vLoc.y,
						vLocZ = vLoc.z,
					}
					hHarpy:AddNewModifier( self:GetCaster(), self, "modifier_frostivus2018_broodbaby_launch", kv )
				end
			end
		end
		
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, vLocation, true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 29, 55, 184 ) )


		self.flLastHarpyTime = GameRules:GetGameTime()
		EmitSoundOn( "Creature_Bomb_Squad.LandMine.Plant", hHarpy )

	end

	return
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------