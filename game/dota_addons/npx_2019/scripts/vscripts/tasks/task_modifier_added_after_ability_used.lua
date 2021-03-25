require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Modifier_Added_After_Ability_Used == nil then
	CDotaNPXTask_Modifier_Added_After_Ability_Used = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Added_After_Ability_Used:StartTask()

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Added_After_Ability_Used:RegisterTaskEvent()
	self.bAbilityUsed = false
	self.szModifierName = self.hTaskInfo.TaskParams.ModifierName
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName
	self.szFailureString = self.hTaskInfo.TaskParams.FailureString
	self.nTaskListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CDotaNPXTask_Modifier_Added_After_Ability_Used, "OnAbilityUsed" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Added_After_Ability_Used:OnAbilityUsed( event )
	if event.PlayerID ~= nil and event.PlayerID == 0 and event.abilityname == self.szAbilityName then
		print( 'CDotaNPXTask_Modifier_Added_After_Ability_Used:OnAbilityUsed - ability use detected ' .. self.szAbilityName )
		self.bAbilityUsed = true
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Added_After_Ability_Used:OnThink()
	CDotaNPXTask.OnThink( self )

	if self.bAbilityUsed and self.bAbilityUsed == true then

		local bFoundModifier = false

		local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		if #Heroes > 0 then
			for _,hHero in pairs( Heroes ) do
				if hHero:IsNull() == false and hHero:IsAlive() == true then
					local hBuff = hHero:FindModifierByName( self.szModifierName )
					if hBuff ~= nil then
						bFoundModifier = true
						break
					end
				end 
			end
		end

		if bFoundModifier == true then
			self:CompleteTask( true )
		else
			self:CompleteTask( false, false, self.szFailureString )
		end
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_Modifier_Added_After_Ability_Used