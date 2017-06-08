modifier_mini_weaver_bug_attack = class({})

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:IsHidden()
	return true
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:IsPurgable() 
	return false
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:OnCreated( kv )
	if IsServer() then
		self.destroy_attacks = self:GetAbility():GetSpecialValueFor( "destroy_attacks" )
		self.attack_rate = self:GetAbility():GetSpecialValueFor( "attack_rate" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		self.hTarget = EntIndexToHScript( kv["entindex"] )
		
		if self:ApplyHorizontalMotionController() == false or self.hTarget == nil then 
			print( self.hTarget )
			self:Destroy()
			return
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_weaver/weaver_swarm_debuff.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false  )

		self:OnIntervalThink()
		self:StartIntervalThink( self.attack_rate )
	end
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
		self:GetParent():RemoveHorizontalMotionController( self )
		if self.hTarget ~= nil then
			self.hTarget:RemoveModifierByName( "modifier_weaver_swarm_debuff" )
		end
	end
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:OnIntervalThink()
	if IsServer() then
		if self.hTarget == nil or self.hTarget:IsAlive() == false then
			self:Destroy()
		end

		if self.hTarget:IsInvulnerable() == false then
			local damageInfo = 
			{
				victim = self.hTarget,
				attacker = self:GetParent(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self:GetAbility(),
			}
			ApplyDamage( damageInfo )
		end
	end
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:CheckState()
	local state = 
	{
		MODIFIER_STATE_NO_UNIT_COLLISION,
		MODIFIER_STATE_NO_TEAM_MOVE_TO,
		MODIFIER_STATE_NO_TEAM_SELECT,
		MODIFIER_STATE_NOT_ON_MINIMAP,
		MODIFIER_STATE_MAGIC_IMMUNE,
	}
	return state
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACKED,
	}
	return funcs
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self.hTarget == nil then
			return
		end

		local vOrigin = self.hTarget:GetOrigin()
		local vForward = self.hTarget:GetForwardVector()
		local vAngles = self.hTarget:GetAnglesAsVector()

		local vNewPos = vOrigin + vForward * 64.0
		me:SetAbsOrigin( vNewPos )
		me:SetAbsAngles( vAngles.x, vAngles.y - 180, vAngles.z )
	end
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:GetAbsoluteNoDamagePhysical( params )
	return 1
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

function modifier_mini_weaver_bug_attack:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			self.destroy_attacks = self.destroy_attacks - 1
			if self.destroy_attacks <= 0 then
				self:Destroy()
			end
			self:GetParent():ModifyHealth( self:GetParent():GetHealth() - self:GetParent():GetHealth() * 0.5, self:GetAbility(), true, 0 )
		end
	end
end