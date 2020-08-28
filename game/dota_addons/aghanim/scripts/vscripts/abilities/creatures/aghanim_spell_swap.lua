
aghanim_spell_swap = class({})

LinkLuaModifier( "modifier_aghanim_spell_swap", "modifiers/creatures/modifier_aghanim_spell_swap", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_spell_swap_crystal", "modifiers/creatures/modifier_aghanim_spell_swap_crystal", LUA_MODIFIER_MOTION_BOTH )

----------------------------------------------------------------------------------------

function aghanim_spell_swap:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_spell_swap_beam.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_tether_hit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_spellswap_replenish.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_spellswap_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_destroy.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_impact.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context )

	PrecacheResource( "model", "models/gameplay/aghanim_crystal.vmdl", context )
end

--------------------------------------------------------------------------------

function aghanim_spell_swap:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghanim_spell_swap:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end


-------------------------------------------------------------------------------

function aghanim_spell_swap:GetChannelTime()
	if IsServer() then
		local flChannelTime = self.BaseClass.GetChannelTime( self )
		local nHealthPct = self:GetCaster():GetHealthPercent()
		if nHealthPct < 50 then
			flChannelTime = flChannelTime - 1.0
		end
		if nHealthPct < 25 then
			flChannelTime = flChannelTime - 1.0
		end
		return flChannelTime
	end
	return self.BaseClass.GetChannelTime( self )
end

-------------------------------------------------------------------------------

function aghanim_spell_swap:OnChannelThink( flInterval )
	if IsServer() then
	end
end

-------------------------------------------------------------------------------

function aghanim_spell_swap:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		for _,nFXIndex in pairs ( self.nBeamFXIndices ) do
			ParticleManager:DestroyParticle( nFXIndex, true )
		end

		StopSoundOn( "Hero_Pugna.LifeDrain.Loop", self:GetCaster() )

		for k,hHero in pairs ( self.Heroes ) do
			if hHero ~= nil and hHero:IsRealHero() then
				hHero:RemoveModifierByName( "modifier_arc_warden_spark_wraith_purge" )
				hHero:AddNewModifier( self:GetCaster(), self, "modifier_aghanim_spell_swap", {} )	
			end
		end
	end
end

--------------------------------------------------------------------------------

function aghanim_spell_swap:OnSpellStart()
	if IsServer() then
		self.nBeamFXIndices = {} 

		local hSummonPortals = self:GetCaster():FindAbilityByName( "aghanim_summon_portals" )
		if hSummonPortals then
			local kv =
			{
				duration = self:GetChannelTime(),
				mode = hSummonPortals.PORTAL_MODE_ALL_ENEMIES,
				depth = 0,
				target_entindex = -1,
			}

			local vRightPos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetRightVector() * 300
			local vLeftPos = self:GetCaster():GetAbsOrigin() - self:GetCaster():GetRightVector() * 300
			CreateModifierThinker( self:GetCaster(), self, "modifier_aghanim_summon_portals_thinker", kv, vRightPos, self:GetCaster():GetTeamNumber(), false )
			CreateModifierThinker( self:GetCaster(), self, "modifier_aghanim_summon_portals_thinker", kv, vLeftPos, self:GetCaster():GetTeamNumber(), false )
		end

		EmitSoundOn( "Hero_Pugna.LifeDrain.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_Pugna.LifeDrain.Loop", self:GetCaster() )

		self.Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
		for k,hHero in pairs ( self.Heroes ) do
			if hHero ~= nil and hHero:IsRealHero() then

				local nNumAghDummies = 0
				for j=1,4 do		
					local szName = tostring( "aghanim_empty_spell" .. j )
					local hDummyAbility = hHero:FindAbilityByName( szName )
					if hDummyAbility then
						nNumAghDummies = nNumAghDummies + 1
					end
				end	

				if nNumAghDummies == 4 then
					print( "I have 4 agh dummies!  Getting slowed." )
					hHero:AddNewModifier( self:GetCaster(), self, "modifier_arc_warden_spark_wraith_purge", { duration = self:GetChannelTime() } )
				end
				
				local nBeamFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_spell_swap_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )

				local szAttachment = "attach_hand_R"
				if RandomInt( 0, 1 ) == 1 then
					szAttachment = "attach_lower_hand_R"
				end
				ParticleManager:SetParticleControlEnt( nBeamFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, szAttachment, self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nBeamFX, 1, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nBeamFX, 11, Vector( 1, 0, 0 ) )

				table.insert( self.nBeamFXIndices, nBeamFX )	
			end
		end
	end
end

--------------------------------------------------------------------------------