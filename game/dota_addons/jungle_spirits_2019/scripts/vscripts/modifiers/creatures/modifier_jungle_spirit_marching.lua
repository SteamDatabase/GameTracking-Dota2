
modifier_jungle_spirit_marching = class({})

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:GetUnitLifetimeFraction()
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

--------------------------------------------------------------------------------

function modifier_jungle_spirit_marching:OnDestroy()
	if IsServer() then
		local hSpirit = GameRules.JungleSpirits._hRadiantSpirit
		local vCastPos = RADIANT_SPIRIT_SPAWN_POS

		if self:GetParent():GetTeamNumber() == DOTA_TEAM_BADGUYS then
			vCastPos = DIRE_SPIRIT_SPAWN_POS
			hSpirit = GameRules.JungleSpirits._hDireSpirit
		end

		self:GetParent():SetInitialGoalEntity( nil )
		self:GetParent():Interrupt()

		local hTravelBoots = self:GetParent():FindItemInInventory( "item_travel_boots_morokai" )
		CastPositionalAbility( self:GetParent(), vCastPos, hTravelBoots )

		local fQueueDelay = hTravelBoots:GetChannelTime() + 0.1

		local fImmuneDuration = fQueueDelay
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_jungle_spirit_immunity", { duration = fImmuneDuration } )

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( fQueueDelay,
			function()
				GameRules.JungleSpirits:SetSpiritInactive( hSpirit )
			end
		)
	end
end

--------------------------------------------------------------------------------
