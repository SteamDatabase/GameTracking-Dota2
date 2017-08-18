modifier_invoker_campfire_hide = class({})

--------------------------------------------------------------------------------

function modifier_invoker_campfire_hide:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

-------------------------------------------------------

function modifier_invoker_campfire_hide:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

-------------------------------------------------------

function modifier_invoker_campfire_hide:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddEffects( EF_NODRAW )
		self:StartIntervalThink( 0.5 )
	end
end

-------------------------------------------------------

function modifier_invoker_campfire_hide:OnIntervalThink()
	if IsServer() then
		local hBuff = self:GetParent():FindModifierByName( "modifier_pocket_campfire_effect" ) 
		if hBuff == nil then
			return
		end
		local hShoptrigger = Entities:FindByName( nil, "invoker_shop" )
		if hShoptrigger ~= nil then
			print( "Enable invoker" )
			hShoptrigger:Enable()
			self:GetParent():RemoveEffects( EF_NODRAW )
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_invulnerable", { duration = -1 } )
			local Heroes = HeroList:GetAllHeroes()
			for _,Hero in pairs ( Heroes ) do
				if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				 	GameRules.Dungeon:OnPlayerFoundInvoker( Hero:GetPlayerID(), 0 )
				end
			end
			self:StartIntervalThink( -1 )
		end
	end
end