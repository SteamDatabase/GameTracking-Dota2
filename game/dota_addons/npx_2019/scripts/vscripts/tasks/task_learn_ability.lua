require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_LearnAbility == nil then
	CDotaNPXTask_LearnAbility = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_LearnAbility:RegisterTaskEvent()
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName
	self:HintLearnAbility( self.szAbilityName, true )

	if self.hTaskInfo.TaskParams.WhiteList == true then
		GameRules:GetGameModeEntity():AddAbilityUpgradeToWhitelist( self.szAbilityName )
		GameRules:GetGameModeEntity():EnableAbilityUpgradeWhitelist( true )
	end

	self.nTaskListener = ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( CDotaNPXTask_LearnAbility, "OnAbilityLearned" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_LearnAbility:OnAbilityLearned( event )
	if event.PlayerID ~= nil and event.PlayerID == 0 and ( ( event.abilityname == self.szAbilityName ) or ( self.szAbilityName == nil ) ) then
		self:CompleteTask( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_LearnAbility:HintLearnAbility( szAbilityName, bStart )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero == nil then
		return
	end

	local hAbility = hPlayerHero:FindAbilityByName( szAbilityName )
	if hAbility then
		hAbility:SetUpgradeRecommended( bStart )
	end
end
----------------------------------------------------------------------------

function CDotaNPXTask_LearnAbility:UnregisterTaskEvent()
	self:HintLearnAbility( self.szAbilityName, false )
	if self.hTaskInfo.TaskParams.WhiteList == true then
		GameRules:GetGameModeEntity():RemoveAbilityUpgradeFromWhitelist( self.szAbilityName )
		GameRules:GetGameModeEntity():EnableAbilityUpgradeWhitelist( false )
	end

	CDotaNPXTask.UnregisterTaskEvent( self )
end

----------------------------------------------------------------------------

return CDotaNPXTask_LearnAbility