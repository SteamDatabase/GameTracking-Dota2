require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_TeleportToUnit == nil then
	CDotaNPXTask_TeleportToUnit = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_TeleportToUnit:StartTask()
	if self.hTeleportTarget == nil then
		print( "ERROR - Cannot start task teleport_to_unit without setting the unit!" )
		return
	end

	self.bNoFailure = self.hTaskInfo.TaskParams.NoFailure == true
	self.bNoCameraTakeover = self.hTaskInfo.TaskParams.NoCameraTakeover == true

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_TeleportToUnit:SetTeleportUnit( hUnit )
	self.hTeleportTarget = hUnit
end

----------------------------------------------------------------------------

function CDotaNPXTask_TeleportToUnit:RegisterTaskEvent()
	self:AddListener( ListenToGameEvent( "dota_ability_channel_finished", Dynamic_Wrap( CDotaNPXTask_TeleportToUnit, "OnAbilityChannelFinished" ), self ) )
	self:AddListener( ListenToGameEvent( "dota_hero_teleport_to_unit", Dynamic_Wrap( CDotaNPXTask_TeleportToUnit, "OnTeleportToUnit" ), self ) )
	
	if self:UseHints() then
		self:GetScenario():HintLocation( self.hTeleportTarget:GetAbsOrigin(), true, self.hTeleportTarget )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_TeleportToUnit:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )

	if self:UseHints() and self.hTeleportTarget then
 		self:GetScenario():HintLocation( self.hTeleportTarget:GetAbsOrigin(), false, self.hTeleportTarget )
 	end
end

----------------------------------------------------------------------------


function CDotaNPXTask_TeleportToUnit:OnAbilityChannelFinished( event )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hAbilityChannelHero = EntIndexToHScript( event.caster_entindex ) 
	local bInterrupted = event.interrupted
	local szAbilityName = event.abilityname
	if szAbilityName == "item_tpscroll" and hPlayerHero == hAbilityChannelHero and bInterrupted == 1 then
		if self.bNoFailure == true then

			local hTP = hPlayerHero:FindItemInInventory( "item_tpscroll" )
			if hTP then
				hTP:SetCurrentCharges( hTP:GetCurrentCharges() + 1 )
				hTP:EndCooldown()
			else
				hTP = hPlayerHero:AddItemByName( "item_tpscroll" )
				if hTP then
					hTP:SetCurrentCharges( 1 )
					hTP:EndCooldown()
				end
			end

			if not self.bNoCameraTakeover then
				SendToConsole( "+dota_camera_center_on_hero" )
				SendToConsole( "-dota_camera_center_on_hero" )
			end

			self:GetScenario():ShowWizardTip( "wizard_tip_failed_tp_interrupted", 15.0 )
			EmitGlobalSound( "General.InvalidTarget_Invulnerable" )
			
			if not self.bNoCameraTakeover then
				self:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 5.0, function()
					SendToConsole( "dota_camera_lerp_position " .. self.hTeleportTarget:GetAbsOrigin().x .. " " .. self.hTeleportTarget:GetAbsOrigin().y .. " " .. 1 )
				end )
			end
					
		else
			self:CompleteTask( false )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_TeleportToUnit:OnTeleportToUnit( event )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hTeleportHero = EntIndexToHScript( event.hero_entindex )
	local hTeleportTarget = EntIndexToHScript( event.unit_entindex )
	if hPlayerHero ~= nil and hTeleportHero == hPlayerHero and self.hTeleportTarget ~= nil then
		if self.hTeleportTarget == hTeleportTarget then
			self:CompleteTask()
		else
			if self.bNoFailure == true then

				local hTP = hPlayerHero:FindItemInInventory( "item_tpscroll" )
				if hTP then
					hTP:SetCurrentCharges( hTP:GetCurrentCharges() + 1 )
					hTP:EndCooldown()
				else
					hTP = hPlayerHero:AddItemByName( "item_tpscroll" )
					if hTP then
						hTP:SetCurrentCharges( 1 )
						hTP:EndCooldown()
					end
				end

				SendToConsole( "+dota_camera_center_on_hero" )
				SendToConsole( "-dota_camera_center_on_hero" )

				self:GetScenario():ShowWizardTip( "wizard_tip_failed_tp_wrong_location", 15.0 )
				EmitGlobalSound( "General.InvalidTarget_Invulnerable" )
				
				self:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 5.0, function()
					SendToConsole( "dota_camera_lerp_position " .. self.hTeleportTarget:GetAbsOrigin().x .. " " .. self.hTeleportTarget:GetAbsOrigin().y .. " " .. 1 )
						
				end )
						
			else
				self:CompleteTask( false )
			end
		end
	end
end

return CDotaNPXTask_TeleportToUnit
