require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_UnlockItem == nil then
	CDotaNPXTask_UnlockItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnlockItem:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnlockItem:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName
	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnlockItem:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnlockItem:OnThink()
	local hItem =  self:GetScenario():GetPlayerHero():FindItemInInventory( self.szItemName )
	if hItem ~= nil then
		if hItem:IsCombineLocked() == false then
			self:CompleteTask()
		else
			--print( self.szItemName .. " still locked" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnlockItem:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_UnlockItem