modifier_ice_boss_trapping_shards = class({})

-----------------------------------------------------------------------------------------

function modifier_ice_boss_trapping_shards:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_trapping_shards:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_trapping_shards:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_ice_boss_trapping_shards:OnCreated( kv )

	if IsServer() then
		for k, v in pairs(kv) do
			if k == "duration_ticks" then
				self.duration_ticks = v
			elseif k == "damage_per_second" then
				self.damage_per_second = v
			end
		end

		self.aryFXIndexes = {}
		self.num_ticks = 0
		self:ApplyShard()
		self:StartIntervalThink( 1 )
	end
end


-----------------------------------------------------------------------------------------

function modifier_ice_boss_trapping_shards:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

----------------------------------------

function modifier_ice_boss_trapping_shards:RemoveAllShards()
	for i = 1, #self.aryFXIndexes do
		ParticleManager:DestroyParticle( self.aryFXIndexes[i], false )
		ParticleManager:ReleaseParticleIndex( self.aryFXIndexes[i] )
	end
end

function modifier_ice_boss_trapping_shards:ApplyShard()
	-- add damage
	local damage = 
	{
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		damage = self.damage_per_second,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}
	ApplyDamage( damage )

	--show particle
	local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/ice_dragon_trapping_shard.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil,  self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )

	self.aryFXIndexes[#self.aryFXIndexes + 1] = nFXIndex
end

function modifier_ice_boss_trapping_shards:OnIntervalThink( )

	print(" modifier_ice_boss_trapping_shards:OnIntervalThink " .. self.num_ticks .. " duration: " .. self.duration_ticks)
	
	self.num_ticks = self.num_ticks + 1
	if self.num_ticks == self.duration_ticks then
		print("exceeded tick count, removing modifier")
		self:GetParent():RemoveModifierByName("modifier_ice_boss_trapping_shards")
		self:RemoveAllShards()
		return
	end

	self:ApplyShard()
end

