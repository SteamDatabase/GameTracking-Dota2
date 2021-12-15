modifier_boss_winter_wyvern_cold_embrace_thinker = class({})

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:IsAura()
	return self.bIsAura
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:GetModifierAura()
	return  "modifier_boss_winter_wyvern_cold_embrace_debuff"
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:GetAuraRadius()
	return self.freeze_radius
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:GetAuraDuration()
	return 0.5
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:OnCreated( kv )
	self.bIsAura = false
	if IsServer() then 
		self.freeze_radius = self:GetAbility():GetSpecialValueFor( "freeze_radius" )
		self.freeze_damage = self:GetAbility():GetSpecialValueFor( "freeze_damage" )
		self.freeze_debuff_duration = self:GetAbility():GetSpecialValueFor( "freeze_debuff_duration" )
		self.freeze_delay = self:GetAbility():GetSpecialValueFor( "freeze_delay" )

		self:StartIntervalThink( self.freeze_delay )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( self.freeze_radius, self.freeze_delay, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex2, 15, Vector( 100, 155, 255 ) )
		ParticleManager:SetParticleControl( nFXIndex2, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )
	end
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:OnIntervalThink()
	if IsServer() then 
		self.bIsAura = true 
		--print( self:GetRemainingTime() )
		EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Splinter", self:GetParent() )
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		
		-- local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		-- ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		-- ParticleManager:ReleaseParticleIndex( nFXIndex )

	--	self:GetParent():SetHullRadius( 84.0 )

		local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.freeze_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		for _,ent in pairs( entities ) do
			if not ( ent:IsNull() ) and ent ~= nil and ent:IsInvulnerable() == false then
				

				if ent:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
					local damageInfo = 
					{
						victim = ent,
						attacker = self:GetCaster(),
						damage = self.freeze_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}

					ApplyDamage( damageInfo )
				
					--ent:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_large_frostbitten_icicle", { duration = self.freeze_debuff_duration } )
					EmitSoundOn( "Hero_Winter_Wyvern.ColdEmbrace", ent )
				end
			end
		end

		--ResolveNPCPositions( self:GetParent():GetAbsOrigin(), 128.0 )

		self:StartIntervalThink( -1 )
	end
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_thinker:OnDestroy()
	if IsServer() then 
		if self.nFXIndex then 
			ParticleManager:DestroyParticle( self.nFXIndex, false )
		end
		UTIL_Remove( self:GetParent() )
	end
end

-------------------------------------------------------------------------------