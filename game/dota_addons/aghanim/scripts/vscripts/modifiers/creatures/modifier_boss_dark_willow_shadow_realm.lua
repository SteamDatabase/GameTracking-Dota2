
modifier_boss_dark_willow_shadow_realm = class({})

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:OnCreated( kv )
	
	self.speed_boost = self:GetAbility():GetSpecialValueFor( "speed_boost" )
	self.num_adds = self:GetAbility():GetSpecialValueFor( "num_adds" )
	self.stun_radius = self:GetAbility():GetSpecialValueFor( "stun_radius" )
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	self.pass_thru_damage = self:GetAbility():GetSpecialValueFor( "pass_thru_damage" )
	self.pass_thru_slow_duration = self:GetAbility():GetSpecialValueFor( "pass_thru_slow_duration" ) 

	self.hHitTargets = {}

	if IsServer() then
		self.num_adds = self.num_adds + math.ceil( ( ( 100 - self:GetParent():GetHealthPercent() ) * self.num_adds / 100 ) )

		self.flAddInterval = self:GetRemainingTime() / self.num_adds
		self.flNextAddTime = GameRules:GetGameTime() + self.flAddInterval

		self:StartIntervalThink( 0.1 )

		--[[
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		if #enemies > 0 then 

			local hEnemyTarget = enemies[ RandomInt( 1, #enemies ) ]
			if hEnemyTarget then 
				local nFXIndexCrown = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_ley_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControlEnt( nFXIndexCrown, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndexCrown, 1, hEnemyTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemyTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndexCrown )

				EmitSoundOn( "Hero_DarkWillow.Ley.Cast", self:GetCaster() )

				hEnemyTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_dark_willow_cursed_crown", { duration = self.delay } )
			end
		end	
		]]
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:OnIntervalThink()
	if IsServer() == false then 
		return 
	end

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.stun_radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then 
			local bHitEnemy = true 
			for _,hHitEnemy in pairs ( self.hHitTargets ) do
				if hHitEnemy == enemy then 
					bHitEnemy = false
					break 
				end 
			end

			if bHitEnemy then 
				EmitSoundOn( "Hero_DarkWillow.Shadow_Realm.Attack", self:GetCaster() )
				
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_dark_willow_shadow_realm_debuff", { duration = self.pass_thru_slow_duration } )

				local DamageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self.pass_thru_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				
				ApplyDamage( DamageInfo )

				table.insert( self.hHitTargets, enemy )

				-- local hSummon = CreateUnitByName( "npc_dota_creature_dark_willow_flower", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				-- if hSummon ~= nil then
				-- 	local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/boss_dark_willow/bramble_toss.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				-- 	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
				-- 	ParticleManager:SetParticleControl( nFXIndex, 1, hSummon:GetAbsOrigin() )
				-- 	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 50, 1.5, 1 ) );
				-- 	ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
				-- 	ParticleManager:ReleaseParticleIndex( nFXIndex )
				-- 	hSummon:SetDisableResistance( 0 )
				-- 	hSummon:SetUltimateDisableResistance( 0 )
				-- 	hSummon:SetOwner( self:GetCaster() )
				-- 	hSummon:SetDeathXP( 0 )
				-- 	hSummon:SetMinimumGoldBounty( 0 )
				-- 	hSummon:SetMaximumGoldBounty( 0 )
				-- end
			end
		end
	end

	if GameRules:GetGameTime() >= self.flNextAddTime then 
		self.flNextAddTime = GameRules:GetGameTime() + self.flAddInterval 

		
		local hSummon = CreateUnitByName( "npc_dota_creature_dark_willow_flower", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hSummon ~= nil then
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/boss_dark_willow/bramble_toss.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, hSummon:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 50, 1.5, 1 ) );
			ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )


			hSummon:SetDisableResistance( 0 )
			hSummon:SetUltimateDisableResistance( 0 )
			hSummon:SetOwner( self:GetCaster() )
			hSummon:SetDeathXP( 0 )
			hSummon:SetMinimumGoldBounty( 0 )
			hSummon:SetMaximumGoldBounty( 0 )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:GetModifierMoveSpeed_AbsoluteMin( params )
	return self.speed_boost
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm:GetActivityTranslationModifiers( params )
	return "surge"
end
