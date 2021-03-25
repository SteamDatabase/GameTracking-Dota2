
----------------------------------------------------------------------------

function CDotaNPXScenario:CheckForReactiveHint( event )
	for i,Hint in pairs( self.ReactiveHints ) do
		if Hint["game_event_listener"] == event.game_event_listener then
			if Hint["hint_func"]( event ) then
				CustomGameEventManager:Send_ServerToAllClients( "display_hint", { hint_text = Hint["hint_text"] } )
				StopListeningToGameEvent( Hint["game_event_listener"] )
				table.remove( self.ReactiveHints, i )
				break
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:AddReactiveHint( szGameEvent, hFunc, szLocalizeString )
	local Hint = {}
	Hint["hint_text"] = szLocalizeString
	Hint["hint_func"] = hFunc
	Hint["game_event_listener"] = ListenToGameEvent( szGameEvent, Dynamic_Wrap( CDotaNPXScenario, "CheckForReactiveHint" ), self )

	table.insert( self.ReactiveHints, Hint )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:HintLocation( vLocation, bStart, hEntity )
	local nType = DOTA_MINIMAP_EVENT_TUTORIAL_TASK_ACTIVE
	local nDuration = 30.0
	if bStart == false then
		nType = DOTA_MINIMAP_EVENT_TUTORIAL_TASK_FINISHED
		nDuration = 1.0
	end
	local hEventEntity = hEntity
	if hEventEntity == nil then
		hEventEntity = PlayerResource:GetSelectedHeroEntity( 0 )
	end
	MinimapEvent( PlayerResource:GetTeam( 0 ), hEventEntity, vLocation.x, vLocation.y, nType, nDuration )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:HintLearnAbility( szAbilityName, bStart )
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

function CDotaNPXScenario:HintNPC( hNPC )
	if hNPC == nil then
		print( "Error, hNPC is nil" )
	end
	
	local HintNPC = {}
	HintNPC["ent_index"] = hNPC:entindex()
	HintNPC["fx_index"] = ParticleManager:CreateParticle( "particles/dev/library/base_follow_absorigin_continuous.vpcf", PATTACH_ABSORIGIN_FOLLOW, hNPC )
	ParticleManager:SetParticleControlEnt( HintNPC["fx_index"], 0, hNPC, PATTACH_ABSORIGIN_FOLLOW, nil, hNPC:GetAbsOrigin(), false )

	local nFXIndex = ParticleManager:CreateParticle( "particles/msg_fx/msg_aggro.vpcf", PATTACH_CUSTOMORIGIN, hNPC )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hNPC, PATTACH_ABSORIGIN_FOLLOW, nil, hNPC:GetAbsOrigin(), false )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, hNPC, PATTACH_ABSORIGIN_FOLLOW, nil, hNPC:GetAbsOrigin(), false )
	ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 255, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	table.insert( self.HintNPCs, HintNPC )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndHintNPC( nEntIndex )
	for k,HintNPC in pairs ( self.HintNPCs ) do
		if HintNPC["ent_index"] == nEntIndex then
			ParticleManager:DestroyParticle( HintNPC["fx_index"], true )
			table.remove( self.HintNPCs, k )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:HintWorldText( vLocation, szHint, nCommand, nEntIndex )
	local WorldTextHint = {}
	WorldTextHint["hint_text"] = szHint
	WorldTextHint["command"] = nCommand
	WorldTextHint["ent_index"] = nEntIndex
	WorldTextHint["location_x"] = vLocation.x
	WorldTextHint["location_y"] = vLocation.y
	WorldTextHint["location_z"] = vLocation.z

	CustomGameEventManager:Send_ServerToAllClients( "start_world_text_hint", WorldTextHint )

	table.insert( self.WorldTextHints, WorldTextHint )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndHintWorldText( vLocation )
	local WorldTextHint = {}
	local nIndex = nil
	for k,Hint in pairs ( self.WorldTextHints ) do
		local vHintLocation = Vector( Hint["location_x"], Hint["location_y"], Hint["location_z"] )
		if vHintLocation == vLocation then
			WorldTextHint = Hint
			nIndex = k
		end
	end

	if nIndex ~= nil then
		CustomGameEventManager:Send_ServerToAllClients( "stop_world_text_hint", WorldTextHint )
		table.remove( self.WorldTextHints, nIndex )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndAllHintWorldText()
	local WorldTextHint = {}
	local nIndex = nil
	for k,Hint in pairs ( self.WorldTextHints ) do
		CustomGameEventManager:Send_ServerToAllClients( "stop_world_text_hint", Hint )
		self.WorldTextHints[k] = nil
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:StartDialog( szDialog, bBubble, nEntIndex, flTimeout )
	local Dialog = {}
	Dialog["dialog_text"] = szDialog
	Dialog["dialog_bubble"] = bBubble
	Dialog["dialog_ent_index"] = nEntIndex
	Dialog["dialog_time_out"] = flTimeout

	if flTimeout ~= -1 then
		Dialog.flTimeout = flTimeout + GameRules:GetGameTime()
		table.insert( self.Dialogs, Dialog )
	end

	CustomGameEventManager:Send_ServerToAllClients( "start_dialog", Dialog )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:EndDialog( szDialog )
	for k,Dialog in pairs ( self.Dialogs ) do
		if Dialog["dialog_text"] == szDialog then
			CustomGameEventManager:Send_ServerToAllClients( "server_ended_dialog", Dialog )
			table.remove( self.Dialogs, k )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario:CheckDialogs()
	for _,Dialog in pairs ( self.Dialogs ) do
		if GameRules:GetGameTime() > Dialog.flTimeout then
			self:EndDialog( Dialog["dialog_text"] )
		end
	end
end


----------------------------------------------------------------------------

function CDotaNPXScenario:ShowWizardTip( szTipName, flDuration, tAbilityNames, tUnitNames, tPanoramaClasses )
	local netTable = {}
	netTable[ "tip_name" ] = szTipName
	netTable[ "tip_duration" ] = flDuration
	netTable[ "tip_ability_names" ] = tAbilityNames
	if tAbilityNames then
		for _,szAbilityName in pairs( tAbilityNames ) do
			print( szAbilityName )
		end
	end
	netTable[ "tip_unit_names" ] = tUnitNames
	netTable[ "tip_panorama_classes" ] = tPanoramaClasses

	CustomGameEventManager:Send_ServerToAllClients( "show_wizard_tip", netTable )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:ShowUIHint( szPanelName, szLocalizeString, flNudgeTime, szDismissEvent )
	self.nUIHintID = self.nUIHintID + 1

	local netTable = {}
	netTable[ "panel_name" ] = szPanelName
	netTable[ "ui_tip_text" ] = szLocalizeString
	netTable[ "nudge_time" ] = flNudgeTime
	netTable[ "dismiss_event" ] = szDismissEvent
	netTable[ "ui_hint_id" ] = self.nUIHintID
	CustomGameEventManager:Send_ServerToAllClients( "show_ui_hint", netTable )
	self.nCurrentUIHintID = self.nUIHintID

	return self.nUIHintID
end

----------------------------------------------------------------------------

function CDotaNPXScenario:HideUIHint()
	local netTable = {}
	CustomGameEventManager:Send_ServerToAllClients( "hide_ui_hint", netTable )
end

----------------------------------------------------------------------------

function CDotaNPXScenario:OnUIHintAdvanced( nUIHintID )
	if self.nCurrentUIHintID ~= nUIHintID then
		return
	end

	self.nCurrentUIHintID = nil
	print( "OnUIHintAdvanced: " .. nUIHintID )
	for _,Task in pairs ( self.Tasks ) do	
		Task:OnUIHintAdvanced( nUIHintID )
	end

	
end