require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_InterruptAbility == nil then
	CDotaNPXTask_InterruptAbility = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_InterruptAbility:StartTask()
	if self.hCasterEntIndex == nil then
		print( "ERROR - Cannot start task interrupt_ability without setting the target caster!" )
		return
	end
	
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName

	if  self.szAbilityName == nil then
		print("ERROR: Need to define AbilityName for this task to work.")
		return
	end

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_InterruptAbility:SetTargetCaster( hUnit )
	self.hCasterEntIndex = hUnit:entindex()
end

----------------------------------------------------------------------------

function CDotaNPXTask_InterruptAbility:RegisterTaskEvent()
	self:AddListener( ListenToGameEvent( "dota_ability_channel_finished", Dynamic_Wrap( CDotaNPXTask_InterruptAbility, "OnAbilityChannelFinished" ), self ) )
end

----------------------------------------------------------------------------

function CDotaNPXTask_InterruptAbility:OnAbilityChannelFinished( event )
	if event.abilityname == self.szAbilityName and event.caster_entindex == self.hCasterEntIndex then
		if event.interrupted == 1 then
			self:CompleteTask( true )
			return
		end

		self:CompleteTask( false, false, self.hTaskInfo.TaskParams.FailureReason )
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_InterruptAbility