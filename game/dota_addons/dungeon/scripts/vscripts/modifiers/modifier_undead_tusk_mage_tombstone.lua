modifier_undead_tusk_mage_tombstone = class({})

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:IsHidden()
	return true
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:OnCreated()
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.skeleton_interval = self:GetAbility():GetSpecialValueFor( "skeleton_interval" )
		self:OnIntervalThink()
		self:StartIntervalThink( self.skeleton_interval )

		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/undead_tusk_mage_sigil.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, -self.radius ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "flame_attachment", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Hero_Tusk.FrozenSigil", self:GetParent() )
	end
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Tusk.FrozenSigil", self:GetParent() )
		self:GetParent():AddEffects( EF_NODRAW )
	end
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
				local hSkeleton = CreateUnitByName( "npc_dota_creature_tusk_skeleton", enemy:GetOrigin() + RandomVector( 50 ), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
				if hSkeleton ~= nil then
					hSkeleton.bSummoned = true
					if self:GetParent().zone ~= nil then
						self:GetParent().zone:AddEnemyToZone( hSkeleton )
					end
					
					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeleton ) )
				end
			end
		end
	end
end