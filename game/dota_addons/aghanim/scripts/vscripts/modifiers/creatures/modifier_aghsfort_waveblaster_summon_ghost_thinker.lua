modifier_aghsfort_waveblaster_summon_ghost_thinker = class({})


function modifier_aghsfort_waveblaster_summon_ghost_thinker:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	end
end



------------------------------------------------------------------

function modifier_aghsfort_waveblaster_summon_ghost_thinker:OnDestroy()
	if IsServer() then
		local hCreep = CreateUnitByName( "npc_aghsfort_creature_wave_blaster_ghost", self:GetParent():GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hCreep ~= nil then
			hCreep:SetOwner( self:GetCaster() )
			hCreep:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
			hCreep:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
			hCreep:SetDeathXP( 0 )
			hCreep:SetMinimumGoldBounty( 0 )
			hCreep:SetMaximumGoldBounty( 0 )
		end

		local nExplosionFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf", PATTACH_CUSTOMORIGIN, NULL )
		ParticleManager:SetParticleControl( nExplosionFX, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nExplosionFX, 3, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nExplosionFX )
		EmitSoundOn( "Aghsfort_Abilty_Specials.Tusk.Snowball_Damage_End", hCreep )


		ParticleManager:DestroyParticle( self.nFXIndex, true )
		UTIL_Remove( self:GetParent() )
	end
end

------------------------------------------------------------------
			
				