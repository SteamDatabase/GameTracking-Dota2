modifier_gaoler_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:OnCreated( kv )
	self.vision_circle_distance = self:GetAbility():GetSpecialValueFor( "vision_circle_distance" )
	if IsServer() then
		self.hDummy = CreateUnitByName( "npc_dota_gaoler_dummy", self:GetParent():GetOrigin() + self:GetParent():GetForwardVector() * self.vision_circle_distance, true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
		if self.hDummy == nil then
			self:Destroy()
			return
		end 
		self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/gaoler_lamp.vpcf", PATTACH_CUSTOMORIGIN , nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.hDummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.hDummy:GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector ( 400, 400, 400 ) )
		ParticleManager:SetParticleFoWProperties( self.nFXIndex, 0, -1, 420 )

		self.nDir = RandomInt( 0, 1 )
		self:StartIntervalThink( 0.1 )
	end
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:OnDestroy()
	if IsServer() then
		if self.hDummy ~= nil then
			ParticleManager:DestroyParticle( self.nFXIndex, true )
			UTIL_Remove( self.hDummy )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_gaoler_passive:OnIntervalThink()
	if IsServer() then
		if self.hDummy ~= nil and not self.hDummy:IsNull() then
			local vNewPos = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector() * self.vision_circle_distance
			local vOffsetDir = self:GetParent():GetRightVector()
			if self.nDir == 1 then
				vOffsetDir = -vOffsetDir
			end
			self.nDir = RandomInt( 0, 1 )
			self.hDummy:SetOrigin( vNewPos + vOffsetDir * RandomInt( 0, 10 ) )
		--	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN , nil )
		--	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self.hDummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.hDummy:GetOrigin(), true )
		--	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector ( 300, 300, 300 ) )
		--	ParticleManager:ReleaseParticleIndex( self.nFXIndex )
		end
	end
end

-----------------------------------------------------------------------------------------