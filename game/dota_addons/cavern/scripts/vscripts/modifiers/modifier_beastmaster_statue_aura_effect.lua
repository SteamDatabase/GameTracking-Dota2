
modifier_beastmaster_statue_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_aura_effect:OnCreated( kv )
	if self:GetCaster() == nil then
		return
	end

	if IsServer() then
		-- get all the player heroes belonging the activator's team
		local hActivatingHero = self:GetParent()
		local hAllHeroes = HeroList:GetAllHeroes()
		for _, hHero in ipairs( hAllHeroes ) do
			if hHero ~= nil and hHero:GetTeamNumber() == hActivatingHero:GetTeamNumber() then
				if hHero:IsRealHero() and hHero:IsOwnedByAnyPlayer() and hHero:IsClone() == false and hHero:IsTempestDouble() == false then
					self:CreateAlliedUnitForPlayerHero( hHero )
				end
			end
		end

		-- Play these sounds after the loop because we only want each one to play once at most
		if self.bPlayBoarSound then
			EmitSoundOn( "Statue_Beastmaster.Call.Boar", self:GetCaster() )
		end

		if self.bPlayHawkSound then
			EmitSoundOn( "Statue_Beastmaster.Call.Hawk", self:GetCaster() )
		end

		-- Add modifier that shows the statue playing some anim/effect
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beastmaster_statue_casting", { duration = 2.5 } )

		local hActivatableBuff = self:GetCaster():FindModifierByName( "modifier_beastmaster_statue_activatable" )
		if hActivatableBuff ~= nil then
			hActivatableBuff:Destroy()
		end

		local fTimeBeforeCasterInactive = 3.0
		self:StartIntervalThink( fTimeBeforeCasterInactive )
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_aura_effect:CreateAlliedUnitForPlayerHero( hPlayerHero )
	if IsServer() then
		local CompanionAnimals =
		{
			"npc_dota_friendly_hawk",
			"npc_dota_friendly_boar",
		}

		local szRandomCompanion = CompanionAnimals[ RandomInt( 1, #CompanionAnimals ) ]
		local hUnit = CreateUnitByName( szRandomCompanion, hPlayerHero:GetAbsOrigin(), true, nil, nil, hPlayerHero:GetTeamNumber() )
		if hUnit == nil then
			print( string.format( "modifier_beastmaster_statue_aura_effect -- ERROR: Failed to spawn unit named \"%s\"", szRandomCompanion ) )
			return
		end

		hUnit:SetOwner( hPlayerHero )
		FindClearSpaceForUnit( hUnit, hPlayerHero:GetAbsOrigin(), true )
		hUnit:SetForwardVector( hPlayerHero:GetForwardVector() )

		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			TargetIndex = hPlayerHero:entindex(),
			Queue = true,
		})

		hUnit:SetControllableByPlayer( hPlayerHero:GetPlayerOwnerID(), false )

		if szRandomCompanion == "npc_dota_friendly_boar" then
			local hAbility = hUnit:FindAbilityByName( "beastmaster_statue_boar_poison" )
			if hAbility then
				-- Note: The boar is not a creature so it doesn't auto-level its abilities
				hAbility:SetLevel( 1 )
			end
			self.bPlayBoarSound = true
		elseif szRandomCompanion == "npc_dota_friendly_hawk" then
			self.bPlayHawkSound = true
		end
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_aura_effect:OnIntervalThink()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue_aura_effect:OnDestroy()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_statue_inactive", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------
