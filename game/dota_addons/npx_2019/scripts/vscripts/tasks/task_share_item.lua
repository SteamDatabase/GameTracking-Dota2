require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_ShareItem == nil then
	CDotaNPXTask_ShareItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_ShareItem:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_ShareItem:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName
	self.szReceivingHero = self.hTaskInfo.TaskParams.ReceivingHero
	local hPlayerHero = self:GetScenario():GetPlayerHero()
	local Heroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, hPlayerHero:GetOrigin(), hPlayerHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	for _,hHero in pairs( Heroes ) do
		if hHero:GetUnitName() == self.szReceivingHero then
			self.hReceivingHero = hHero
		end
	end
	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_ShareItem:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_ShareItem:OnThink()
	if self.hReceivingHero:FindItemInInventory( self.szItemName ) ~= nil then
		self:CompleteTask()
	else
		--print( self.szItemName .. " still in inventory" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_ShareItem:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_ShareItem