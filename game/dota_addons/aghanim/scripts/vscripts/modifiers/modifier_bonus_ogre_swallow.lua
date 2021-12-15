
modifier_bonus_ogre_swallow = class({})

----------------------------------------------------------------------------------

function modifier_bonus_ogre_swallow:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_bonus_ogre_swallow:IsPurgable()
	return false
end


----------------------------------------------------------------------------------

function modifier_bonus_ogre_swallow:OnCreated( kv )
	if IsServer() then
		--Cast effect

		local vDir = self:GetParent():GetOrigin() - self:GetCaster():GetOrigin()
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )

		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true );
		ParticleManager:SetParticleControl( nFXIndex, 2, vDir );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		--EmitSoundOn( "Hero_Hoodwink.Taunt_2021.Pos", self:GetCaster() );

		self:GetParent():AddEffects( EF_NODRAW )

		self:StartIntervalThink(1.0)
	end
end
-----------------------------------------------------------------------

function modifier_bonus_ogre_swallow:OnIntervalThink()
	if IsServer() then
		local vOrigin = self:GetCaster():GetAbsOrigin()
		FindClearSpaceForUnit(self:GetParent(),vOrigin,true)
	end
end
--------------------------------------------------------------------------------

function modifier_bonus_ogre_swallow:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveEffects( EF_NODRAW )
	end
end




--------------------------------------------------------------------------------

function modifier_bonus_ogre_swallow:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,

	}

	return state
end
