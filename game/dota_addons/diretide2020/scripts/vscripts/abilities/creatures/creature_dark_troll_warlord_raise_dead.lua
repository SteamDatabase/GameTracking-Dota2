creature_dark_troll_warlord_raise_dead = class({})

----------------------------------------------------------------------------------------

function creature_dark_troll_warlord_raise_dead:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", context )
end

----------------------------------------------------------------------------------------

function creature_dark_troll_warlord_raise_dead:OnSpellStart()
    if IsServer() then
    	local radius = self:GetSpecialValueFor( "radius" )
    	local max_skeletons_per_cast = self:GetSpecialValueFor( "max_skeletons_per_cast" )
    	local vecDeadUnits = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false )
		if #vecDeadUnits > 0 then
			for _,hCorpse in pairs( vecDeadUnits ) do
				if hCorpse.nConsumed == nil or hCorpse.nConsumed == FlipTeamNumber( self:GetCaster():GetTeamNumber() ) then
					local hSkeleton = CreateUnitByName( "npc_dota_creature_skeleton", hCorpse:GetAbsOrigin(), true, nil, nil, self:GetCaster():GetTeamNumber() )
					if hSkeleton then
						FindClearSpaceForUnit( hSkeleton, hSkeleton:GetAbsOrigin(), true )
						hSkeleton:SetRequiresReachingEndPath( true )
						
						hSkeleton:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
						hSkeleton.Diretide_bIsCore = false
				
						hSkeleton:SetMustReachEachGoalEntity( true )
						hSkeleton:SetDeathXP( 0 )
						hSkeleton:SetMaximumGoldBounty( 0 )
						hSkeleton:SetMinimumGoldBounty( 0 )

						-- if self:GetCaster().hWaveManager ~= nil then
						-- 	self:GetCaster().hWaveManager:AddSpawnedUnit( hSkeleton, true )
						-- end

						local nSummonFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nSummonFX, 0, hSkeleton, PATTACH_POINT_FOLLOW, "attach_hitloc", hSkeleton:GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt( nSummonFX, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt( nSummonFX, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nSummonFX )

						ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, hSkeleton ) )
						EmitSoundOn( "n_creep_TrollWarlord.RaiseDead", hSkeleton )
						if hCorpse.nConsumed == nil then
							hCorpse.nConsumed = self:GetCaster():GetTeamNumber()
						else
							hCorpse.nConsumed = 10
						end
						max_skeletons_per_cast = max_skeletons_per_cast - 1
						if max_skeletons_per_cast == 0 then
							break
						end

						GameRules.Diretide:AddExtraSpawnedUnit( hSkeleton )
					end
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------
