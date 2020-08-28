aghanim_summon_portals = class( {} )

LinkLuaModifier( "modifier_aghanim_portal_spawn_effect", "modifiers/creatures/modifier_aghanim_portal_spawn_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_summon_portals_thinker", "modifiers/creatures/modifier_aghanim_summon_portals_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghanim_summon_portals:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti10/portal/portal_open_bad.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/portal_summon.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_portal_summon.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_portal_emit.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/ti10/portal/portal_emit_large.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_ghost.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_stomp_magical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_magical.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_creature_aghanim_minion", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_boss_aghanim_spear", context, -1 )

	self.PORTAL_MODE_ALL_SPEARS = 0
	self.PORTAL_MODE_ALL_ENEMIES = 1
	self.PORTAL_MODE_BOTH = 2

	self.nLastPortalMode = self.PORTAL_MODE_ALL_ENEMIES
	self.nMode = 0
	self.nDepthRemaining = 20
	self.nPortals = 0
	self.nNumPortalsThisCast = 0
	self.flPortalSummmonTime = self:GetSpecialValueFor( "portal_time" )
	self.flStartGestureTime = 999999999999
	
	self.bSynchedPortalRelease = false
end

--------------------------------------------------------------------------------

function aghanim_summon_portals:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghanim_summon_portals:OnAbilityPhaseStart()
	if IsServer() then
		self.nPortals = self:GetPortalCount()
		self.flPortalSummmonTime = self:GetSpecialValueFor( "portal_time" )
		
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_portal_summon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		EmitSoundOn( "Hero_ElderTitan.EchoStomp.Channel", self:GetCaster() )

		self.staff_crush_radius = self:GetSpecialValueFor( "staff_crush_radius" )
		self.staff_crush_damage = self:GetSpecialValueFor( "staff_crush_damage" )
		self.staff_crush_stun_duration = self:GetSpecialValueFor( "staff_crush_stun_duration" )
		self.staff_crush_delay = self:GetSpecialValueFor( "staff_crush_delay" )


		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()
		vToTarget.z = 0
		vToTarget = vToTarget:Normalized()

		self.vStaffEndPos = self:GetCaster():GetAbsOrigin() + ( vToTarget * 200.0 )--+ ( self:GetCaster():GetRightVector() * -30 )
		self.vStaffEndPos = GetGroundPosition( self.vStaffEndPos, self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_crystal_attack_telegraph.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.vStaffEndPos )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.staff_crush_radius, 1.6, 1.6 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 255, 0, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
	return true
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:OnChannelThink( flInterval )
	if IsServer() then
		if self.nPortals > 0 and GameRules:GetGameTime() > self.flNextPortalTime then
			self.flNextPortalTime = GameRules:GetGameTime() + self.flPortalInterval
			if self.nNumPortalsInLine > 0 then
				self:CreateNextPortalAlongLine()
				self.nNumPortalsInLine = self.nNumPortalsInLine - 1
				self.nNumPortalsThisCast = self.nNumPortalsThisCast + 1
			end

			if self.nNumPortalsNearHeroes > 0 then
				self:CreateNearHeroPortal()
				self.nNumPortalsNearHeroes = self.nNumPortalsNearHeroes - 1
				self.nNumPortalsThisCast = self.nNumPortalsThisCast + 1
			end
		end

		if self.bHasStaffCrushed == false then
			self.staff_crush_delay = self.staff_crush_delay - flInterval
			if self.staff_crush_delay < 0 then
				self.bHasStaffCrushed = true
				self:StaffCrush()
			end
		end

		if GameRules:GetGameTime() > self.flStartGestureTime then
			self:GetCaster():StartGesture( ACT_DOTA_IDLE )
			self.flStartGestureTime = 9999999999999
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		self:GetCaster():RemoveGesture( ACT_DOTA_IDLE )
	end
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:OnSpellStart()
	if IsServer() then
		self.flStartGestureTime = GameRules:GetGameTime() + 2.5
		self.bHasStaffCrushed = false

		self.flPortalInterval = self:GetChannelTime() / self.nPortals 
		self.flNextPortalTime = -1
		self.nDepthRemaining = self:GetSpecialValueFor( "total_portal_depth" )
		self.nLastPortalMode = self.nMode
		self.nMode = self:GetPortalMode()

		self.nNumPortalsThisCast = 0

		self.nNumPortalsInLine = self:GetSpecialValueFor( "base_portals" ) 
		self.nNumPortalsNearHeroes = self.nPortals - self.nNumPortalsInLine

		if self.nMode == self.PORTAL_MODE_ALL_SPEARS then
			local vMidPoint = nil
			
			local vLineDir = nil
			self.Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )

			vMidPoint = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 500
			vLineDir = self:GetCaster():GetRightVector()

			vLineDir.z = 0.0
			vLineDir = vLineDir:Normalized()

			local nPortalsRemaining = self.nNumPortalsInLine - 1 
			local flLineStep = 450
			local flTotalLineDist = flLineStep * self.nNumPortalsInLine
			local vFirstPortalPos = vMidPoint - ( vLineDir * ( flLineStep * nPortalsRemaining  / 2 )  )

			self.SpearLinePositions = {}
			table.insert( self.SpearLinePositions, vFirstPortalPos )
			
			for i=1,nPortalsRemaining do
				local vNewPortalPos = vFirstPortalPos + ( vLineDir * i * flLineStep )
				table.insert( self.SpearLinePositions, vNewPortalPos )
			end
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:StaffCrush()
	if IsServer() then
		
		local nFXCastIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_stomp_magical.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXCastIndex, 0, self.vStaffEndPos )
		ParticleManager:SetParticleControl( nFXCastIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXCastIndex )

		EmitSoundOn( "Hero_ElderTitan.EchoStomp", self:GetCaster() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vStaffEndPos, self:GetCaster(), self.staff_crush_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.staff_crush_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self,
				}

				ApplyDamage( damageInfo )
				
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.staff_crush_stun_duration } )

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_magical.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
				local vDirection = enemy:GetOrigin() - self.vStaffEndPos
				vDirection.z = 0.0
				vDirection = vDirection:Normalized()

				ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, vDirection )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:GetPortalCount()
	if IsServer() then
		local nBasePortals = self:GetSpecialValueFor( "base_portals" )
		local nHealthPctPerPortal = self:GetSpecialValueFor( "portal_health_pct" )
		local nAdditionalPortals = math.floor( ( 100 - self:GetCaster():GetHealthPercent() )  / nHealthPctPerPortal )

		return nBasePortals + nAdditionalPortals
	end

	return 0
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:GetPortalMode()
	if IsServer() then	
		return self.PORTAL_MODE_ALL_SPEARS		
	end
	return 0
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:CreateNearHeroPortal()
	if IsServer() then
		local nCountLeft = self.nNumPortalsNearHeroes 
		if nCountLeft <= 0 then
			return
		end

		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
		if #Heroes == 0 then
			return
		end

		local hTarget = Heroes[ RandomInt( 1, #Heroes ) ]
		if hTarget == nil then
			return
		end

		local vToAghanim = self:GetCaster():GetAbsOrigin() - hTarget:GetAbsOrigin() 
		vToAghanim.z = 0.0
		vToAghanim = vToAghanim:Normalized()

		local vPos = hTarget:GetAbsOrigin() - vToAghanim * RandomFloat( self:GetSpecialValueFor( "min_portal_offset" ), self:GetSpecialValueFor( "max_portal_offset" ) )
		if GridNav:CanFindPath( hTarget:GetAbsOrigin(), vPos ) == false then
			return
		end

		local flDuration = 0.5 + ( self:GetChannelStartTime() + self:GetChannelTime() ) - GameRules:GetGameTime() - ( nCountLeft * 0.3 )

		local kv =
		{
			duration = flDuration,
			mode = self.PORTAL_MODE_ALL_SPEARS,
			depth = 0,
			target_entindex = hTarget:entindex(),
		}

		CreateModifierThinker( self:GetCaster(), self, "modifier_aghanim_summon_portals_thinker", kv, vPos, self:GetCaster():GetTeamNumber(), false )
	end
end

-------------------------------------------------------------------------------

function aghanim_summon_portals:CreateNextPortalAlongLine()
	if IsServer() then
		local nCountLeft = #self.SpearLinePositions 
		if nCountLeft == 0 then
			return
		end

		local vPos = self.SpearLinePositions[ 1 ]
		
		local hTarget = nil
		if #self.Heroes == 0 then
			local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
			if #Heroes == 0 then
				return
			end
			hTarget = Heroes[ RandomInt( 1, #Heroes ) ]
		else
			local nIndex = RandomInt( 1, #self.Heroes )
			hTarget = self.Heroes[ nIndex ]
			table.remove( self.Heroes, nIndex )
		end
		 
		if hTarget == nil then
			return
		end

		local flDuration = 0.5 + ( self:GetChannelStartTime() + self:GetChannelTime() ) - GameRules:GetGameTime() - ( nCountLeft * 0.3 )
		table.remove( self.SpearLinePositions, 1 )

		local kv =
		{
			duration = flDuration,
			mode = self.PORTAL_MODE_ALL_SPEARS,
			depth = 0,
			target_entindex = hTarget:entindex(),
		}

		CreateModifierThinker( self:GetCaster(), self, "modifier_aghanim_summon_portals_thinker", kv, vPos, self:GetCaster():GetTeamNumber(), false )
	end
end

-------------------------------------------------------------------------------