modifier_aghanim_spell_swap_crystal = class({})

---------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:IsHidden()
	return true
end

---------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:IsPurgable()
	return false
end

---------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:GetEffectName()
	return "particles/creatures/aghanim/aghanim_crystal_spellswap_ambient.vpcf"
end

----------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

----------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnCreated( kv )
	if IsServer() then
		self.num_crystal_hits = self:GetAbility():GetSpecialValueFor( "num_crystal_hits" )

		self:GetParent():SetBaseMaxHealth( self.num_crystal_hits * 2 )
		self:GetParent():SetMaxHealth( self.num_crystal_hits * 2 )
		self:GetParent():SetHealth( self.num_crystal_hits * 2 )

		self.flRotationTime = 12.0
		self.flRotationDist = 300.0
		self.flHeight = RandomFloat( 120.0, 180.0 )
		self.flRotation = RandomFloat( 0, 360 )
		self.flRecoverTime = -1

		self:StartIntervalThink( 0.25 )
		
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() > self.flRecoverTime then
			self.flRotationTime = 12.0
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flRotation = self.flRotation + ( 2.0 * dt * math.pi / self.flRotationTime )
		local flX = self.flRotationDist * math.sin( self.flRotation )
		local flY = self.flRotationDist * math.cos( self.flRotation )
		if self:GetCaster() and self:GetParent() then
			local vNewLocation = self:GetCaster():GetAbsOrigin() + Vector( flX, flY, self:GetParent():GetAbsOrigin().z )
			me:SetOrigin( vNewLocation )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local flHeight = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() ) + self.flHeight
		local vNewLocation = self:GetParent():GetAbsOrigin()
		vNewLocation.z = flHeight
		me:SetOrigin( vNewLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:GetAbsoluteNoDamagePhysical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:GetAbsoluteNoDamageMagical( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:GetAbsoluteNoDamagePure( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_aghanim_spell_swap_crystal:OnAttacked( params )
	if IsServer() then
		if self:GetParent() == params.target then
			local nDamage = 0
			if params.attacker then
				local bDeathWard = params.attacker:FindModifierByName( "modifier_aghsfort_witch_doctor_death_ward" ) ~= nil
				local bValidAttacker = params.attacker:IsRealHero() or bDeathWard
				if not bValidAttacker then
					return 0
				end
			
				nDamage = 2
				if params.attacker:FindModifierByName( "modifier_aghsfort_snapfire_lil_shredder_buff" ) or bDeathWard then
					nDamage = 1
				end

				self.flRotationTime = 36.0
				self.flRecoverTime = GameRules:GetGameTime() + 1.0
				self:GetParent():ModifyHealth( self:GetParent():GetHealth() - nDamage, nil, true, 0 )

				EmitSoundOn( "Hero_Wisp.Spirits.Target", self:GetParent() )

				local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_crystal_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end
	end

	return 0
end