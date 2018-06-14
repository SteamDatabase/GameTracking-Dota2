
modifier_juggernaut_shrink = class({})

--------------------------------------------------------------------------------

function modifier_juggernaut_shrink:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_juggernaut_shrink:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_juggernaut_shrink:OnCreated( kv )
	if IsServer() then
		self.stage = 1
		self:GetParent().stage = self.stage -- AI file will want to know about this
	end
end

--------------------------------------------------------------------------------

function modifier_juggernaut_shrink:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_juggernaut_shrink:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker

		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end

		local hUnit = params.unit

		if hUnit == self:GetParent() then
			local fHealthPct = self:GetParent():GetHealthPercent()
			local OldStage = self.stage

			if fHealthPct >= 50 and self.stage ~= 1 then
				self.stage = 1
			elseif fHealthPct < 50 and self.stage ~= 2 then
				self.stage = 2
			end

			if OldStage ~= self.stage then
				local szMoveSpeed = "stage" .. tostring( self.stage ) .. "_movespeed"
				local nMoveSpeed = self:GetAbility():GetSpecialValueFor( szMoveSpeed )
				self:GetParent():SetBaseMoveSpeed( nMoveSpeed )

				local szModelScale = "stage" .. tostring( self.stage ) .. "_modelscale"
				local fModelScale = self:GetAbility():GetSpecialValueFor( szModelScale )
				self:GetParent():SetModelScale( fModelScale )

				self:GetParent().stage = self.stage
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
