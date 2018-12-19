
modifier_storegga_spawn_children_thinker = class({})

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:OnCreated( kv )
	if IsServer() then
		if self:GetParent() == nil or self:GetParent():IsNull() or self:GetCaster() == nil or self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		self.nAmountToSpawn = self:GetAbility():GetSpecialValueFor( "amount_to_spawn" )

		self.hChildren = { }

		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetParent() == nil or self:GetParent():IsNull() or self:GetCaster() == nil or self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		if #self.hChildren < self.nAmountToSpawn then
			self:CreateBaby()
		else
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:CreateBaby()
	local hChild = CreateUnitByName( "npc_dota_creature_small_storegga", self:GetParent():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	if hChild == nil or hChild:IsNull() then
		print( "ERROR - modifier_storegga_spawn_children_thinker: Failed to spawn child" )
		return
	end

	table.insert( self.hChildren, hChild )

	hChild:SetOwner( self:GetCaster() )
	hChild:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
	hChild:SetDeathXP( 0 )
	hChild:SetMinimumGoldBounty( 0 )
	hChild:SetMaximumGoldBounty( 0 )

	local nMaxVectorLength = 100 + ( #self.hChildren * 15 )
	local vLoc = self:GetParent():GetAbsOrigin() + RandomVector( nMaxVectorLength )
	FindClearSpaceForUnit( hChild, vLoc, true )

	EmitSoundOn( "Creature_Broodmother.CreateBabySpider", hChild )
end

--------------------------------------------------------------------------------

function modifier_storegga_spawn_children_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
