
modifier_bounty_hunter_statue_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue_aura_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue_aura_effect:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue_aura_effect:OnCreated( kv )
	if IsServer() then
		if self:GetCaster() == nil then
			return
		end

		local hEnemyPlayerHeroes = {}
		for _, hHero in pairs( HeroList:GetAllHeroes() ) do
			if hHero and hHero:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and hHero:IsOwnedByAnyPlayer() then
				table.insert( hEnemyPlayerHeroes, hHero )
			end
		end

		self.hVisionDummies = {}

		-- Put a revealer dummy on all the enemy player heroes
		for _, hEnemyPlayerHero in pairs( hEnemyPlayerHeroes ) do
			local hDummy = CreateUnitByName( "npc_dota_vision_dummy", hEnemyPlayerHero:GetAbsOrigin(), false, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )
			if hDummy then
				--printf( "modifier_bounty_hunter_statue_aura_effect -- Created vision dummy on unit \"%s\"", hEnemyPlayerHero:GetUnitName() )
				hDummy.hRevealedHero = hEnemyPlayerHero
				table.insert( self.hVisionDummies, hDummy )
			else
				printf(" ERROR: modifier_bounty_hunter_statue_aura_effect -- Failed to create vision dummy on %s", hEnemyPlayerHero:GetUnitName() )
			end
		end

		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bounty_hunter_statue_casting", { duration = 2.5 } )
	end
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue_aura_effect:OnDestroy()
	if IsServer() then
		for index, hVisionDummy in pairs( self.hVisionDummies ) do
			UTIL_Remove( hVisionDummy )
			self.hVisionDummies[ index ] = nil
		end

		printf( "modifier_bounty_hunter_statue_aura_effect:OnDestroy() -- Cleaned up vision dummies; #self.hVisionDummies == %d", #self.hVisionDummies )
	end
end

--------------------------------------------------------------------------------
