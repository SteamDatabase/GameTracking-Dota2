modifier_sand_king_boss_burrowstrike = class ({})

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:OnCreated( kv )
	if IsServer() then
		self.vTarget = Vector( kv["x"], kv["y"], kv["z"] )
		self.vDir = self.vTarget - self:GetParent():GetOrigin()
		self.vDir = self.vDir:Normalized()

		local flHealthPct = self:GetParent():GetHealthPercent() / 100
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" ) + ( self:GetAbility():GetSpecialValueFor( "scaling_speed" ) * ( 1 - flHealthPct ) )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

		self:GetParent():AddEffects( EF_NODRAW )
		self.nFXIndex = -1
		self.nFXIndex2 = -1
		self.nFXIndex3 = -1
		self:OnIntervalThink()
		self:StartIntervalThink( 0.33 )
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveEffects( EF_NODRAW )
		local kv = 
		{
			x = self.vDir.x,
			y = self.vDir.y,
			z = self.vDir.z,
		}
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sand_king_boss_burrowstrike_end", kv )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:OnIntervalThink()
	if IsServer() then
		if self.nFXIndex ~= -1 then
			ParticleManager:DestroyParticle( self.nFXIndex, false )
		end
		if self.nFXIndex2 ~= -1 then
			ParticleManager:DestroyParticle( self.nFXIndex2, false )
		end
		if self.nFXIndex3 ~= -1 then
			ParticleManager:DestroyParticle( self.nFXIndex3, false )
		end

		self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControlForward( self.nFXIndex, 0, self:GetParent():GetForwardVector() )
		self.nFXIndex2 = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex2, 0, self:GetParent():GetOrigin() + RandomVector( 1 ) * RandomInt( 50, 150 ) )
		ParticleManager:SetParticleControlForward( self.nFXIndex2, 0, self:GetParent():GetRightVector() )
		self.nFXIndex3 = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex3, 0, self:GetParent():GetOrigin() + RandomVector( 1 ) * RandomInt( 50, 150 ) )
		ParticleManager:SetParticleControlForward( self.nFXIndex3, 0, -self:GetParent():GetRightVector() )

		EmitSoundOn( "Hero_NyxAssassin.Burrow.In", self:GetParent() )

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies > 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vNewLocation = self:GetParent():GetOrigin() + self.vDir * self.speed * dt
		me:SetOrigin( vNewLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrowstrike:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end


