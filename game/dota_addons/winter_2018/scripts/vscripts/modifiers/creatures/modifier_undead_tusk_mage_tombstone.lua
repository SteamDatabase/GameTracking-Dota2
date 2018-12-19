
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
		self.hSkeletons = {}

		if GameRules.holdOut.hFort then
			self.hFort = GameRules.holdOut.hFort
		else
			local hFort = GameRules.holdOut.FindAndGetFort()
			if hFort then
				self.hFort = hFort
			else
				print( "ERROR - modifier_undead_tusk_mage_tombstone: Could not set initial goal entity" )
				self:Destroy()
				return
			end
		end

		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.skeleton_interval = self:GetAbility():GetSpecialValueFor( "skeleton_interval" )
		self.skeletons_per_tick = self:GetAbility():GetSpecialValueFor( "skeletons_per_tick" )
		self.max_skeletons = self:GetAbility():GetSpecialValueFor( "max_skeletons" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/undead_tusk_mage_sigil.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, -self.radius ) )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		EmitSoundOn( "Hero_Tusk.FrozenSigil", self:GetParent() )

		self:StartIntervalThink( self.skeleton_interval )
	end
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Tusk.FrozenSigil", self:GetParent() )
		self:GetParent():AddEffects( EF_NODRAW )
		UTIL_Remove( self:GetParent() )
	end
end

---------------------------------------------------------

function modifier_undead_tusk_mage_tombstone:OnIntervalThink()
	if IsServer() then
		if self.hFort == nil then
			print( "ERROR [modifier_undead_tusk_mage_tombstone:OnIntervalThink]: I have no self.hFort so won't be able to give skeletons an initial goal entity. Removing tombstone." )
			Destroy()
			return
		end

		for k, hSkeleton in pairs( self.hSkeletons ) do
			if hSkeleton == nil or hSkeleton:IsNull() or hSkeleton:IsAlive() == false then
				table.remove( self.hSkeletons, k )
			end
		end

		for i = 1, self.skeletons_per_tick do
			if #self.hSkeletons < self.max_skeletons then
				--print( string.format( "modifier_undead_tusk_mage_tombstone - This tombstone owns less than %d skels, so making another one now", self.max_skeletons ) )

				local vSpawnPos = self:GetParent():GetAbsOrigin() + RandomVector( 150 )
				local hSkeleton = CreateUnitByName( "npc_dota_creature_tusk_skeleton", vSpawnPos, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
				if hSkeleton ~= nil then
					table.insert( self.hSkeletons, hSkeleton )

					if self.hFort then
						hSkeleton:SetInitialGoalEntity( self.hFort )
					else
						print( string.format( "ERROR - modifier_undead_tusk_mage_tombstone: Could not set initial goal entity for %s", hSkeleton:GetUnitName() ) )
					end

					hSkeleton:SetOwner( self:GetParent() )
					hSkeleton:SetDeathXP( 0 )
					hSkeleton:SetMinimumGoldBounty( 0 )
					hSkeleton:SetMaximumGoldBounty( 0 )

					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeleton ) )

					EmitSoundOn( "Tombstone.RaiseDead", hSkeleton )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
