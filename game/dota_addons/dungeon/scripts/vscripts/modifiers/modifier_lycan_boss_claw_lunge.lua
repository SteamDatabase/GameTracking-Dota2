modifier_lycan_boss_claw_lunge = class({})

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		self.lunge_width = self:GetAbility():GetSpecialValueFor( "lunge_width" )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end


--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:GetOverrideAnimation( params )
	return ACT_DOTA_RUN_STATUE
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		me:SetOrigin( self:GetAbility().vProjectileLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_boss_claw_lunge:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end