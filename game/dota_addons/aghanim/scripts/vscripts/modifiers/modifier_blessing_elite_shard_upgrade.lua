modifier_blessing_elite_shard_upgrade = class({})

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:OnCreated( kv )
	if IsServer() then
		self.applied_depths = {}
		self.applied_count = 0
	end
end

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:IsAppliedToDepth( nRoomDepth )
	if IsServer() then
		return self.applied_depths[nRoomDepth] == true
	end
	return false
end

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:ApplyToDepth( nRoomDepth )
	if IsServer() then
		self.applied_depths[nRoomDepth] = true
		self.applied_count = self.applied_count + 1
	end
end

--------------------------------------------------------------------------------

function modifier_blessing_elite_shard_upgrade:CanApplyToDepth( nRoomDepth )
	if IsServer() then
		if self:GetStackCount() <= self.applied_count then
			return false
		end

		local nRoomAct = GetActForDepth( nRoomDepth )
		for k,v in pairs( self.applied_depths ) do
			if v and nRoomAct == GetActForDepth( k ) then
				return false
			end
		end
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function GetActForDepth( nDepth )
	if nDepth <= MAP_ATLAS["a1_6_bonus"].nDepth then
		return 1
	elseif nDepth <= MAP_ATLAS["a2_6_bonus"].nDepth then
		return 2
	else
		return 3
	end
end