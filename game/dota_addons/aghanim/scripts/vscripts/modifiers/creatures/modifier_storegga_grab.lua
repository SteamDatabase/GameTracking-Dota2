
modifier_storegga_grab = class({})

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnCreated( kv )
	if IsServer() then
		self.grab_radius = self:GetAbility():GetSpecialValueFor( "grab_radius" )
		self.min_hold_time = self:GetAbility():GetSpecialValueFor( "min_hold_time" )
		self.max_hold_time = self:GetAbility():GetSpecialValueFor( "max_hold_time" )

		self:StartIntervalThink( kv["initial_delay"] )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_crit_blur.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_grab:OnIntervalThink()
	if IsServer() then
		if self.hTarget == nil then
			return
		end

		local flDist = ( self.hTarget:GetOrigin() - self:GetParent():GetOrigin() ):Length2D()
		if flDist > 700 then
			return
		end
	
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_buff", {} )
		if hBuff ~= nil then
			local flHoldTime = RandomFloat( self.min_hold_time, self.max_hold_time )
			self:GetCaster().flThrowTimer = GameRules:GetGameTime() + flHoldTime
			hBuff.hThrowObject = self.hTarget
			self.hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_storegga_grabbed_debuff", { hold_time = flHoldTime + 10.0  } )		
			
		end
		self:Destroy()
		return
	end
end
