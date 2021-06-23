
if modifier_tower_upgrade_tower_shrine_tracker == nil then
	modifier_tower_upgrade_tower_shrine_tracker = class( {} )
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_shrine_tracker:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_shrine_tracker:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_tower_upgrade_tower_shrine_tracker:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.tHealedHeroes = {}
	self.nRadius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	self:StartIntervalThink( 0.1 )
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tower_shrine_tracker:OnIntervalThink()
	if IsServer() == false then
		return
	end

	local hUnits = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,v in pairs( hUnits ) do
		--if v:IsRealHero() and v:GetHealth() < v:GetMaxHealth() then
			self.tHealedHeroes[ v:GetPlayerOwnerID() ] = 1
		--end
	end

	-- Done here rather than at kill because kill might come before heals.
	if #self.tHealedHeroes >= _G.BATTLE_POINT_SHRINE_HEAL_NUM_HEROES_THRESHOLD and self:GetParent().bHasRewardedKill == true then
		local nPlayerID = self:GetParent().nLastCastingPlayerID
		if nPlayerID ~= nil and nPlayerID >= 0 then
			GameRules.Nemestice:GrantTeamBattlePoints( self:GetParent():GetTeamNumber(), _G.BATTLE_POINT_DROP_SHRINE_TEAMFIGHT, "shrine_teamfight", nPlayerID )
		end
		self:StartIntervalThink( -1 )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_tower_upgrade_tower_shrine_tracker:OnDestroy()
	if IsServer() then
		self:GetParent().bHasRewardedKill = false
	end
end
