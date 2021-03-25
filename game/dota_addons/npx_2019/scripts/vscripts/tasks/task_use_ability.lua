require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_UseAbility == nil then
	CDotaNPXTask_UseAbility = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UseAbility:StartTask()

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UseAbility:RegisterTaskEvent()
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName
	self.nTaskListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CDotaNPXTask_UseAbility, "OnAbilityUsed" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UseAbility:OnAbilityUsed( event )
	if event.PlayerID ~= nil and event.PlayerID == 0 and ( ( event.abilityname == self.szAbilityName ) or ( self.szAbilityName == nil ) ) then
		self:CompleteTask()
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_UseAbility