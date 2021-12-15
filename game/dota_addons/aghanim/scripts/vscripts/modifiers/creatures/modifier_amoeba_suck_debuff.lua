modifier_amoeba_suck_debuff = class({})

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:OnCreated( kv )
	if IsServer() then
		self.drag_speed = self:GetAbility():GetSpecialValueFor( "drag_speed" )
		self.baby_drag_speed = self:GetAbility():GetSpecialValueFor( "baby_drag_speed" )
		self.fLastThinkTime = GameRules:GetGameTime()
		self:StartIntervalThink( 0 )

		local hOwner = self:GetAuraOwner()
		if hOwner ~= nil and hOwner:IsNull() == false and hOwner:IsAlive() == true then
			local vOrigin = hOwner:GetAbsOrigin()

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_black_hole_scepter_pull_debuff.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, vOrigin )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_debuff:OnIntervalThink()
	if IsServer() then

		if self:GetParent() ~= nil and self:GetParent():IsNull() == false and self:GetParent():IsAlive() == true then
			local nDragSpeed = self.drag_speed
			if self:GetParent():GetUnitName() == "npc_dota_creature_amoeba_baby" then
				nDragSpeed = self.baby_drag_speed
			end

			local dt = GameRules:GetGameTime() - self.fLastThinkTime
			self.fLastThinkTime = GameRules:GetGameTime()

			local hOwner = self:GetAuraOwner()
			if hOwner ~= nil and hOwner:IsNull() == false and hOwner:IsAlive() == true then
				local vOrigin = hOwner:GetAbsOrigin()
				vOrigin.z = 0
				local vPos = self:GetParent():GetAbsOrigin()
				vPos.z = 0
				local vPullDir = vOrigin - vPos

				local fDistToDestination = vPullDir:Length2D()
				local fMaxTravelDistance = nDragSpeed * dt
				local fTravelDistance = math.min( fDistToDestination, fMaxTravelDistance )

				local vPullVec
				if fDistToDestination == 0 then
					vPullVec = Vector( 0, 0, 0 )
				else
					vPullVec = fTravelDistance * vPullDir:Normalized()
				end

				self:GetParent():SetAbsOrigin( self:GetParent():GetAbsOrigin() + vPullVec )
			end
		end
	end
end
