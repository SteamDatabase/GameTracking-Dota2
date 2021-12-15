
modifier_storegga_avalanche_thinker = class({})

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:OnCreated( kv )
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.movement = self:GetAbility():GetSpecialValueFor( "movement" )

		self.Avalanches = {}

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		self.hAvalancheTarget = enemies[RandomInt(1, #enemies)]

		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_avalanche_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		local vNewAvalancheDir1 = RandomVector( 1 )
		local vNewAvalancheDir2 = RandomVector( 1 )
		if self.hAvalancheTarget ~= nil and self.hAvalancheTarget:IsAlive() then
			vNewAvalancheDir2 = self.hAvalancheTarget:GetOrigin() - self:GetCaster():GetOrigin()
		else
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			self.hAvalancheTarget = enemies[RandomInt(1, #enemies)]
			if self.hAvalancheTarget ~= nil then
				vNewAvalancheDir2 = self.hAvalancheTarget:GetOrigin() - self:GetCaster():GetOrigin()
			end
		end
		
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Storegga.Avalanche", self:GetCaster() )

		local hTiny = CreateUnitByName( "npc_dota_creature_small_storegga", self:GetParent():GetOrigin(), true, self:GetParent(), self:GetParent():GetOwner(), self:GetParent():GetTeamNumber() )
		if hTiny ~= nil then
			hTiny:SetControllableByPlayer( self:GetParent():GetPlayerOwnerID(), false )
			hTiny:SetOwner( self:GetParent() )
			hTiny.bBossMinion = true
			if self:GetParent().Encounter then
				self:GetParent().Encounter:SuppressRewardsOnDeath( hTiny )
			end
		end
	
		vNewAvalancheDir1 = vNewAvalancheDir1:Normalized()
		vNewAvalancheDir2 = vNewAvalancheDir2:Normalized()

		local vRadius = Vector( self.radius * .72, self.radius * .72, self.radius * .72 )
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/creatures/storegga/storegga_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex1, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex1, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex1, 0, vNewAvalancheDir1 )
		self:AddParticle( nFXIndex1, false, false, -1, false, false )

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/creatures/storegga/storegga_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, vRadius )
		ParticleManager:SetParticleControlForward( nFXIndex2, 0, vNewAvalancheDir2 )
		self:AddParticle( nFXIndex2, false, false, -1, false, false )

		local Avalanche1 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir1,
			nFX = nFXIndex1,
		}
		local Avalanche2 = 
		{
			vCurPos = self:GetCaster():GetOrigin(),
			vDir = vNewAvalancheDir2,
			nFX = nFXIndex2,
		}
		
		table.insert( self.Avalanches, Avalanche1 )
		table.insert( self.Avalanches, Avalanche2 )

		for _,ava in pairs ( self.Avalanches ) do
			local vNewPos = ava.vCurPos + ava.vDir * self.movement
			vNewPos.z = GetGroundHeight( vNewPos, self:GetCaster() )
			ava.vCurPos = vNewPos


			ParticleManager:SetParticleControl( ava.nFX, 0, vNewPos )


			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vNewPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.slow_duration } )
				end
			end
		end
	end
end
