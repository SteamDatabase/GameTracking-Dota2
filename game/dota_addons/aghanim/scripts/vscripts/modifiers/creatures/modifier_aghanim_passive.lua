
modifier_aghanim_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_aghanim_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_aghanim_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_aghanim_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	if IsServer() then
		if self:GetParent() and self:GetParent().AI and self:GetParent().AI.bDefeated == true then
			state[MODIFIER_STATE_INVULNERABLE] = true
		end
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:OnCreated( kv )
	self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
	if IsServer() then
		self:GetParent().bAbsoluteNoCC = true
		self:GetParent().bNoNullifier = true
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:OnRefresh( kv )
	self.status_resist = self:GetAbility():GetSpecialValueFor( "status_resist" )
end

-----------------------------------------------------------------------------------------

function modifier_aghanim_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_DEATH_PREVENTED,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:GetModifierStatusResistanceStacking( params )
	return self.status_resist 
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:GetMinHealth( params )
	if IsServer() then
		if GameRules.Aghanim:GetAscensionLevel() < 3 then
			return math.floor( self:GetParent():GetMaxHealth() * 0.1 )
		end
	end
 	return 1
end 

--------------------------------------------------------------------------------

function modifier_aghanim_passive:OnDeathPrevented( params )
	if IsServer() then
		if self:GetParent() == params.unit and self:GetParent().AI and self:GetParent().AI.Encounter and self:GetParent().AI.bDefeated == false then 
			print( "Game Over - Players win!  Play Aghanim Victory Sequence" )
			for nPlayerID = 0,AGHANIM_PLAYERS-1 do
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hPlayerHero then
					hPlayerHero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invulnerable", { duration = -1 } )
				end
			end

			local Angles = self:GetParent():GetAnglesAsVector()
			CustomGameEventManager:Send_ServerToAllClients( "begin_aghanim_victory", { ent_index = self:GetParent():entindex(), yaw = Angles.y } )

			self:GetParent().AI.bDefeated = true
			self:GetParent():Interrupt()
			self:GetParent():InterruptChannel()
			self:GetParent():Purge( false, true, false, true, true )
			--self:GetParent():SetAbsAngles( 0, 270, 0 )
			self:GetParent().AI.Encounter:BeginVictorySequence()
			
			EmitSoundOn( "Aghanim.ShardAttack.Channel", self:GetCaster() )
			if GameRules.Aghanim:GetAscensionLevel() < 3 then 	
				self:GetParent():StartGestureFadeWithSequenceSettings( ACT_DOTA_CAST_ABILITY_3 )
			else
				self:GetParent():StartGestureFadeWithSequenceSettings( ACT_DOTA_SPAWN )
			end
			self.nOutroPhase = 1
			self:StartIntervalThink( 2.0 )		
		end
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_aghanim_passive:OnIntervalThink()
	if IsServer() then
		 
		if self.nOutroPhase == 1 then
			if GameRules.Aghanim:GetAscensionLevel() < 3 then 
				EmitSoundOn( "Aghanim.ShardAttack.Wave", self:GetCaster() )
				local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_self_dmg.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 2500, 2500, 2500 ) )

				for nPlayerID = 0,AGHANIM_PLAYERS-1 do
					local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if hPlayerHero then
						hPlayerHero:RemoveModifierByName( "modifier_invulnerable" )
						hPlayerHero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghanim_crystal_attack_debuff", { duration = -1 } )
						hPlayerHero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = -1 } )
						hPlayerHero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invulnerable", { duration = -1 } )

						local nFXIndex2 = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
						ParticleManager:ReleaseParticleIndex( nFXIndex2 )
						EmitSoundOn( "Hero_Leshrac.Pulse_Nova_Strike", hPlayerHero )
					end
				end
				self:GetParent():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
			else
				for nPlayerID = 0,AGHANIM_PLAYERS-1 do
					local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if hPlayerHero then
						hPlayerHero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_intro", { duration = -1 } )
					end
				end

				self:GetParent():FadeGesture( ACT_DOTA_SPAWN )
			end

			local AlliedUnits = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,Ally in pairs( AlliedUnits ) do
				if Ally:GetUnitName() == "npc_dota_boss_aghanim_crystal" or Ally:GetUnitName() == "npc_dota_boss_aghanim_minion" or Ally:GetUnitName() == "npc_dota_thinker" or Ally:GetUnitName() == "npc_dota_boss_aghanim_spear" then
					Ally:ForceKill( false )
				end
			end

			self.nOutroPhase = self.nOutroPhase + 1
			self:StartIntervalThink( 2.0 )
			self:GetParent():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
			self:GetParent():StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY )
			return
		end

		if self.nOutroPhase == 2 then	
			self.nPortalFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/portal_summon.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( self.nPortalFX, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControlForward( self.nPortalFX, 0, self:GetParent():GetForwardVector() )
			
			self.nOutroPhase = self.nOutroPhase + 1
			self:StartIntervalThink( 0.1 )
			return
		end

		if self.nOutroPhase == 3 then
			if self:GetParent().Encounter and self:GetParent().Encounter.nVictoryState ~= self:GetParent().Encounter.AGH_VICTORY_BOWING then
				return
			end

			EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
			EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_outro_linger.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControlForward( nFXIndex, 0, self:GetParent():GetForwardVector() )

			self:GetParent():FadeGesture( ACT_DOTA_VICTORY )
			self:GetParent():StartGestureFadeWithSequenceSettings( ACT_DOTA_DIE )
			self.nOutroPhase = self.nOutroPhase + 1
			self:StartIntervalThink( 5.67 )
			return
		end

		if self.nOutroPhase == 4 then			
			self:GetParent().bOutroComplete = true
			ParticleManager:DestroyParticle( self.nPortalFX, false )

			StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
			StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )
			
			self:StartIntervalThink( -1 )
			self:GetParent():AddEffects( EF_NODRAW )
			
			for nPlayerID = 0,AGHANIM_PLAYERS-1 do
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hPlayerHero then
					hPlayerHero:RemoveModifierByName( "modifier_stunned" )
					hPlayerHero:RemoveModifierByName( "modifier_aghanim_crystal_attack_debuff" )
					hPlayerHero:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY )
				end
			end
			return
		end
		
	end
end