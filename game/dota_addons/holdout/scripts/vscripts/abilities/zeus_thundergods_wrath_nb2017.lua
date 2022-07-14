zeus_thundergods_wrath_nb2017 = class({})

--------------------------------------------------------------------------------

function zeus_thundergods_wrath_nb2017:OnAbilityPhaseStart()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true );
		EmitSoundOn( "Hero_Zuus.GodsWrath.PreCast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function zeus_thundergods_wrath_nb2017:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, true )
	end
end

--------------------------------------------------------------------------------

function zeus_thundergods_wrath_nb2017:OnSpellStart()	
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( self.nFXIndex )

		local heroes = HeroList:GetAllHeroes()
		for i=1,#heroes do
			local hero = heroes[i]
			if hero ~= nil and hero:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				local vStartPosition = hero:GetOrigin() + Vector( 0, 0, 4000.0 )
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				EmitSoundOn( "Hero_Zuus.GodsWrath.Target" , hero )

				local hCloud = CreateUnitByName( "npc_dota_zeus_cloud", hero:GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				hCloud:SetOwner( self:GetCaster() )
				hCloud:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
				hCloud:AddNewModifier( self:GetCaster(), self, "modifier_zuus_cloud", {} )
				hCloud:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor( "cloud_duration" ) } )
				FindClearSpaceForUnit( hCloud, hero:GetOrigin(), true )
			end
		end
	end
end

--------------------------------------------------------------------------------
