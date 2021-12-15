
modifier_restorative_flower_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_restorative_flower_thinker:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
		self.heal_per_tick = self:GetAbility():GetSpecialValueFor( "heal_per_tick" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf", PATTACH_WORLDORIGIN, nil );
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 0, -self.radius ) );
		--GetParticleManager()->SetParticleControlEnt( iIndex, 2, GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff" );

		self:GetParent():EmitSound( "RestorativeFlower.Start" )
		self:GetParent():EmitSound( "RestorativeFlower.Loop" )

		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )
	end
end

----------------------------------------------------------------------------------------

function modifier_restorative_flower_thinker:OnIntervalThink()
	if IsServer() then
		--[[looks weird - the flower is an enemy so it can be attacked, so it needs to heal its enemies who are the heroes]]--
		local goodguys = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,goodguy in pairs( goodguys ) do
			if goodguy ~= nil then
				goodguy:Heal( self.heal_per_tick, self:GetAbility() )
				--		 	   PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
				goodguy:Purge( false,		  true,			 false,		true,		 false )
			end
		end
	end
end

----------------------------------------------------------------------------------------

function modifier_restorative_flower_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )

		self:GetParent():StopSound( "RestorativeFlower.Loop" )
		self:GetParent():EmitSound( "RestorativeFlower.End" )
	end
end