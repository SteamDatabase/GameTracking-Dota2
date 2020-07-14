
modifier_aghanim_summon_portals_thinker = class({})

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:OnCreated( kv )
	if IsServer() then
		self.nMode = kv.mode 
		self.hTarget = EntIndexToHScript( kv.target_entindex )
		self.nDepth = kv.depth

		local vFwd = nil
		if self.hTarget == nil then
			vFwd = self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()
			vFwd = vFwd:Normalized()
		else
			vFwd = self.hTarget:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
			vFwd = vFwd:Normalized()
		end

		local szEffect = nil
		if self.nMode == self:GetAbility().PORTAL_MODE_ALL_SPEARS and self.hTarget then
			self:CreateSpear()
			szEffect = "particles/creatures/aghanim/portal_summon.vpcf"
			self:StartIntervalThink( 0.1 )
		else
			self:CreateEnemies()
			szEffect = "particles/creatures/aghanim/portal_summon.vpcf"
		end

		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )

		self.nPortalFX = ParticleManager:CreateParticle( szEffect, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPortalFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nPortalFX, 0, vFwd )

		AddFOWViewer( DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 300.0, self:GetDuration(), false )
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), 300, false )
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:CreateSpear()
	if IsServer() then
		self.hSpear = CreateUnitByName( "npc_dota_boss_aghanim_spear", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber() )
		if self.hSpear then
			self.hSpear:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
			self.hSpear:SetOwner( self:GetCaster() )
			self.hSpear:AddEffects( EF_NODRAW )
			self.hSpear:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_rooted", {} )
			self.hSpear:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_hero_statue_pedestal", {} )
			
			--self.hSpear:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghanim_portal_spawn_effect", {} )
			self.hSpear:FaceTowards( self.hTarget:GetAbsOrigin() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}
	return funcs
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:GetModifierIgnoreCastAngle( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:OnIntervalThink()
	if IsServer() then
		if self.hSpear then
			self.hSpear:RemoveEffects( EF_NODRAW )
			self.hSpear:FaceTowards( self.hTarget:GetAbsOrigin() )
		end
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:CreateEnemies()
	if IsServer() then
		self.Summons = {}
		if 1 then
			nCount = 2
			for n=1,nCount do 
				local vSpawnPos = self:GetParent():GetAbsOrigin() + RandomVector( 25 * nCount )
				local hSummon = CreateUnitByName( "npc_dota_creature_aghanim_minion", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hSummon ~= nil then
					table.insert( self.Summons, hSummon )
					hSummon.nDisableResistance = hSummon:GetDisableResistance( )
					hSummon.nUltimateDisableResistance = hSummon:GetUltimateDisableResistance( )
					hSummon:SetDisableResistance( 0 )
					hSummon:SetUltimateDisableResistance( 0 )
					hSummon:SetOwner( self:GetCaster() )
					hSummon:SetDeathXP( 0 )
					hSummon:SetMinimumGoldBounty( 0 )
					hSummon:SetMaximumGoldBounty( 0 )
					hSummon:AddEffects( EF_NODRAW )
					hSummon:SetAbsAngles( 0, RandomFloat( 0, 360 ), 0 )
					hSummon:SetMaterialGroup( "1" )
					hSummon:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghanim_portal_spawn_effect", { duration = self:GetRemainingTime() } )
	
				end
			end
		else
			local PossibleSummons = GameRules.Aghanim:GetSummonsForAghanim()
			local Summon = nil

			while Summon == nil and self.nDepth > 1 do
				for _,CurSummon in pairs( PossibleSummons ) do
					if CurSummon[ "depth" ] == self.nDepth then
						Summon = CurSummon
						break
					end
				end

				if Summon == nil then
					self.nDepth = self.nDepth - 1
				end
			end

			if Summon then
				local nCount = math.max( 1, 5 - math.floor( self.nDepth / 2 ) )
				for n=1,nCount do 
					local vSpawnPos = self:GetParent():GetAbsOrigin() + RandomVector( 25 * nCount )
					local hSummon = CreateUnitByName( Summon[ "unit_name" ], vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					if hSummon ~= nil then
						table.insert( self.Summons, hSummon )
						hSummon.nDisableResistance = hSummon:GetDisableResistance( )
						hSummon.nUltimateDisableResistance = hSummon:GetUltimateDisableResistance( )
						hSummon:SetDisableResistance( 0 )
						hSummon:SetUltimateDisableResistance( 0 )
						hSummon:SetOwner( self:GetCaster() )
						hSummon:SetDeathXP( 0 )
						hSummon:SetMinimumGoldBounty( 0 )
						hSummon:SetMaximumGoldBounty( 0 )
						hSummon:AddEffects( EF_NODRAW )
						hSummon:SetAbsAngles( 0, RandomFloat( 0, 360 ), 0 )
						hSummon:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghanim_portal_spawn_effect", { duration = self:GetRemainingTime() } )
		
					end
				end
			end
		end		
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:OnDestroy()
	if IsServer() then
		if self.nMode == self:GetAbility().PORTAL_MODE_ALL_SPEARS then
			self:LaunchSpear()
		else
			self:ReleaseEnemies()
		end
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", self:GetParent() )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self:GetParent() )

		ParticleManager:DestroyParticle( self.nPortalFX, false )
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:LaunchSpear()
	if IsServer() then
		if self.hSpear ~= nil then
			self.hSpear:AddEffects( EF_NODRAW )
			self.hSpear:ForceKill( false )
		end

		local hSpear = self:GetCaster():FindAbilityByName( "aghanim_spear" )
		if hSpear and self.hTarget then
			hSpear:EndCooldown()

			EmitSoundOn(  "SeasonalConsumable.TI10.Portal.Emit", self:GetParent() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_portal_emit.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			hSpear:LaunchSpear( self.hTarget:GetAbsOrigin(), self:GetParent():GetAbsOrigin() )
		else
			print( "No spear, or no target?" )
		end
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_summon_portals_thinker:ReleaseEnemies()
	if IsServer() then
		for _, Summon in pairs ( self.Summons ) do
			EmitSoundOn(  "SeasonalConsumable.TI10.Portal.Emit", Summon )
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_portal_emit.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, Summon:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			Summon:RemoveModifierByName( "modifier_aghanim_portal_spawn_effect" )
			Summon:SetAcquisitionRange( 5000 )
			Summon:SetDayTimeVisionRange( 5000 )
			Summon:SetNightTimeVisionRange( 5000 )
			Summon:SetDisableResistance( Summon.nDisableResistance )
			Summon:SetUltimateDisableResistance( Summon.nUltimateDisableResistance )
			Summon.bBossMinion = true
			FindClearSpaceForUnit( Summon, Summon:GetAbsOrigin(), false )
		end
	end
end