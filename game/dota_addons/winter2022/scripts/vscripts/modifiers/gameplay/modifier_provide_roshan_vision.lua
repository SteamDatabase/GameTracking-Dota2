
if modifier_provide_roshan_vision == nil then
	modifier_provide_roshan_vision = class({})
end

--------------------------------------------------------------------------------

function modifier_provide_roshan_vision:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_provide_roshan_vision:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_provide_roshan_vision:OnCreated( kv )
	if IsServer() then
		local nOverheadFX = ParticleManager:CreateParticle( "particles/roshan/target_hero_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddParticle( nOverheadFX, false, false, -1, true, true )

		--[[
		local nFXIndex = ParticleManager:CreateParticle( "particles/roshan/target_hero_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		local vOverheadPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, 250 )
		ParticleManager:SetParticleControl( nFXIndex, 0, vOverheadPos )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		]]

		--[[
		local vOverheadPos = self:GetParent():GetAbsOrigin() + Vector( 0, 0, 250 )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, vOverheadPos, false )
		]]
	end
end

--------------------------------------------------------------------------------

function modifier_provide_roshan_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_provide_roshan_vision:GetModifierProvidesFOWVision( params )
	if params.target ~= nil and params.target:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 then
		return 1
	end

	return 0
end

--------------------------------------------------------------------------------
