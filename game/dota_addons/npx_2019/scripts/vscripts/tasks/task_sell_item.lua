require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_SellItem == nil then
	CDotaNPXTask_SellItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SellItem:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_SellItem:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName
	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_SellItem:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_SellItem:OnThink()
	if self:GetScenario():GetPlayerHero():FindItemInInventory( self.szItemName ) == nil then
		self:CompleteTask()
	else
		--print( self.szItemName .. " still in inventory" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_SellItem:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_SellItem