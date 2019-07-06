
item_battle_points = class({})
item_battle_points_250 = item_battle_points
item_battle_points_500 = item_battle_points
item_battle_points_2000 = item_battle_points
item_battle_points_5000 = item_battle_points

--------------------------------------------------------------------------------

function item_battle_points:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_battle_points:CanUnitPickUp(hUnit)
	if hUnit:IsIllusion() or not hUnit:IsRealHero() then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function item_battle_points:OnSpellStart()
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsRealHero() then
			local nTeamBattlePoints = self:GetCurrentCharges()
			GameRules.JungleSpirits:OnBattlePointsEarned( self:GetCaster(), nTeamBattlePoints, "looting_battle_points_pinata" )

			local nLooterTeam = self:GetCaster():GetTeamNumber()

			local gameEvent = {}
			gameEvent[ "player_id" ] = self:GetCaster():GetPlayerID()
			gameEvent[ "teamnumber" ] = -1
			gameEvent[ "int_value" ] = nTeamBattlePoints

			if nLooterTeam == DOTA_TEAM_GOODGUYS then
				gameEvent[ "message" ] = "#GameEvent_PlayerOpenedBPPackage"
			else
				gameEvent[ "message" ] = "#GameEvent_PlayerOpenedBPPackage_Dire"
			end

			FireGameEvent( "dota_combat_event_message", gameEvent )

			EmitGlobalSound( "BattlePointsItem.Pickup" )

			local nFXIndex = ParticleManager:CreateParticle( "particles/jungle_spirit/jungle_spirit_essence_pickup.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
