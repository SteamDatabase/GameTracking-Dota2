
-- Note: this modifier's ability gets added by hand to the dummy unit that Broodmother creates.

modifier_huge_broodmother_generate_children_thinker = class({})

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:OnCreated( kv )
	if IsServer() then
		self.hBabies = { }

		self.spawn_interval = self:GetAbility():GetSpecialValueFor( "spawn_interval" )

		-- Note: nAmountToSpawn gets attached to the parent (a dummy) by broodmother, prior to modifier being added
		self.nAmountToSpawn = self:GetParent().nAmountToSpawn
		self.bWantsToBeRemoved = false
		self.nMaxSpawnRadius = 75 + ( self.nAmountToSpawn * 15 )


		self.szBabyUnit = "npc_dota_creature_broodmother_baby_d"

		self.nFXIndex = ParticleManager:CreateParticle( "particles/baby_brood_venom_pool.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.nMaxSpawnRadius, 1, 1 ) )

		self:StartIntervalThink( self.spawn_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:OnIntervalThink()
	if IsServer() then
		if #self.hBabies < self.nAmountToSpawn then
			self:CreateBaby()
		end

		if self.bWantsToBeRemoved == false and #self.hBabies >= self.nAmountToSpawn then
			self.bWantsToBeRemoved = true
		end

		if self.bWantsToBeRemoved then
			self:TryToRemoveMyself()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:CreateBaby()
	local hBaby = CreateUnitByName( self.szBabyUnit, self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )

	local nMaxDistance = 75 + ( #self.hBabies * 15 )
	local vLoc = self:GetParent():GetAbsOrigin() + RandomVector( nMaxDistance )

	if hBaby then
		table.insert( self.hBabies, hBaby )

		hBaby:SetInitialGoalEntity( self:GetParent().hInitialGoalEntity )
		hBaby:SetDeathXP( 0 )
		hBaby:SetMinimumGoldBounty( 0 )
		hBaby:SetMaximumGoldBounty( 0 )

		local kv =
		{
			vLocX = vLoc.x,
			vLocY = vLoc.y,
			vLocZ = vLoc.z,
		}
		hBaby:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_frostivus2018_broodbaby_launch", kv )

		EmitSoundOn( "Creature_Broodmother.CreateBabySpider", hBaby )
	end
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:TryToRemoveMyself()
	if IsServer() then
		-- Are all my babies done with their movement modifier?
		self.bSafeToRemove = true
		for _, hBaby in pairs( self.hBabies ) do
			if hBaby ~= nil and hBaby:IsNull() == false and hBaby:IsAlive() and hBaby:HasModifier( "modifier_frostivus2018_broodbaby_launch" ) then
				self.bSafeToRemove = false
			end
		end

		if self.bSafeToRemove then
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_huge_broodmother_generate_children_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
