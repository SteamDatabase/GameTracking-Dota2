modifier_tiny_trample = class({})

--------------------------------------------------------------------------------

function modifier_tiny_trample:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )
	self.hHitTargets = {}
	if IsServer() then
		self:StartIntervalThink( 0.05 )
		EmitSoundOn( "Hero_Centaur.Stampede.Movement", self:GetParent() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false  );

		local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndexB );
	end
end

--------------------------------------------------------------------------------

function modifier_tiny_trample:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) and ( not self:HasHitTarget( enemy ) ) then
					self:AddHitTarget( enemy )
					self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_phantom_assassin_stiflingdagger_caster", {} )
					self:GetParent():PerformAttack( enemy, false, false, true, true, false, false, true )
					self:GetParent():RemoveModifierByName( "modifier_phantom_assassin_stiflingdagger_caster" )

					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )

					EmitSoundOn( "Hero_Tiny.Trample", enemy )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_craggy_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy );
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true );
					ParticleManager:SetParticleControlOrientation( nFXIndex, 1, enemy:GetForwardVector(), enemy:GetRightVector(), enemy:GetUpVector() );
					ParticleManager:ReleaseParticleIndex( nFXIndex );
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_tiny_trample:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_tiny_trample:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movespeed_pct
end

--------------------------------------------------------------------------------

function modifier_tiny_trample:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state

end

--------------------------------------------------------------------------------

function modifier_tiny_trample:HasHitTarget( hTarget )
	for _, target in pairs( self.hHitTargets ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_tiny_trample:AddHitTarget( hTarget )
	table.insert( self.hHitTargets, hTarget )
end

