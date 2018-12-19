
modifier_faceless_void_reactive_spawn = class({})

--------------------------------------------------------------------------------

function modifier_faceless_void_reactive_spawn:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_faceless_void_reactive_spawn:OnCreated( kv )
	self.max_concurrent_spawns = self:GetAbility():GetSpecialValueFor( "max_concurrent_spawns" )
	self.spawns_per_dmg_instance = self:GetAbility():GetSpecialValueFor( "spawns_per_dmg_instance" )

	if IsServer() then
		self.hSandKings = { }

		self:StartIntervalThink( 0.2 )
	end
end

--------------------------------------------------------------------------------

function modifier_faceless_void_reactive_spawn:OnIntervalThink()
	if IsServer() then
		for i, hSandKing in pairs( self.hSandKings ) do
			if hSandKing == nil or hSandKing:IsNull() or hSandKing:IsAlive() == false then
				table.remove( self.hSandKings, i )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_faceless_void_reactive_spawn:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_faceless_void_reactive_spawn:OnTakeDamage( params )
	if IsServer() then
		local hVictim = params.unit
		local hAttacker = params.attacker

		if hAttacker == nil then
			return 0
		end

		if hVictim == self:GetParent() then		
			-- Generate a small sand king creature nearby for each instance of damage I take.  Ensure I don't go over some limit.
			for i = 1, self.spawns_per_dmg_instance do
				if #self.hSandKings < self.max_concurrent_spawns then
					local hSandKing = CreateUnitByName( "npc_dota_creature_small_sand_king", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
					if hSandKing ~= nil then
						table.insert( self.hSandKings, hSandKing )

						hSandKing:SetInitialGoalEntity( self:GetParent():GetInitialGoalEntity() )

						local vRandomOffset = Vector( RandomInt( -200, 200 ), RandomInt( -200, 200 ), 0 )
						local vSpawnPoint = self:GetParent():GetAbsOrigin() + vRandomOffset
						FindClearSpaceForUnit( hSandKing, vSpawnPoint, true )
					end
				end
			end
		end
	end

	return 0
end

--------------------------------------------------------------------------------
