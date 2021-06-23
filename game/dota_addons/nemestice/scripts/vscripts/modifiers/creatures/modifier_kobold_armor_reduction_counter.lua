if modifier_kobold_armor_reduction_counter == nil then
	modifier_kobold_armor_reduction_counter = class({})
end

------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:GetTexture()
	return "slardar_amplify_damage"
end

------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:IsDebuff()
	return true
end

----------------------------------------

function modifier_kobold_armor_reduction_counter:OnCreated( kv )
	self:OnRefresh( kv )

	--print( '^^^modifier_kobold_armor_reduction_counter:OnCreated - making particles!' )
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/medallion_of_courage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true );
	self:AddParticle( nFXIndex, false, false, -1, false, true );	
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:OnRefresh( kv )
	if IsServer() == true then
		--printf( "^^^SERVER - COUNTER STACK IS AT %d", self:GetStackCount() )
		self:SendBuffRefreshToClients()
	end
end

--------------------------------------------------------------------------------

function modifier_kobold_armor_reduction_counter:OnStackCountChanged( nOldStackCount )
	if IsServer() == false then
		return
	end

	--printf( "^^^SERVER - COUNTER STACK COUNT CHANGED - STACK COUNT IS %d", self:GetStackCount() )
	self:SendBuffRefreshToClients()
end
