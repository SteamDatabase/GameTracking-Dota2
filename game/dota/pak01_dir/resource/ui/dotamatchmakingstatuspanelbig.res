"Resource/UI/DOTAMatchmakingStatusPanelBig.res"
{
	controls
	{
		"DOTAMatchmakingStatusPanelBig"
		{
			"ControlName"		"EditablePanel"
			style=StatusBarBGStyle
		}
		
		"Background" { ControlName=ImagePanel xpos=0 ypos=0 zpos=-2 wide=512 tall=416 mouseInputEnabled=0 scaleImage=1 image=dashboard/dash_panel_center }
		
		"SpinningCircle" { ControlName=CircularProgressBar wide=60 tall=60 xpos=226 ypos=150 zpos=6 alpha=255 fgcolor_override="255 255 255 128" bgcolor_override="64 64 64 64" }
		"StatusLabel" { ControlName=Label xpos=128 ypos=90 wide=256 tall=36 textAlignment="center" zpos=2 style=StatusBarTextStyle }
		"PlayersSearchingLabel" { ControlName=Label xpos=128 ypos=230 wide=256 tall=36 textAlignment="center" zpos=2 style=SearchingStyle }
		
		"CancelFindButton" { ControlName=Button xpos=186 ypos=290 wide=128 tall=36 textAlignment="center" zpos=2 style=GreyButton14Style labelText="#dota_cancel_match_find" command="CancelFindMatch" group=FindMatchControls }
		"ReconnectButton" { ControlName=Button xpos=122 ypos=270 wide=128 tall=36 textAlignment="center" zpos=2 style=GreyButton14Style labelText="#dota_reconnect_to_game" command="Reconnect" group=ReconnectControls }
		"AbandonButton" { ControlName=Button xpos=262 ypos=270 wide=128 tall=36 textAlignment="center" zpos=2 style=GreyButton14Style labelText="#dota_abandon_game" command="Abandon" group=ReconnectControls }
		"AbandonFindServerButton" { ControlName=Button xpos=186 ypos=290 wide=128 tall=36 textAlignment="center" zpos=2 style=GreyButton14Style labelText="#dota_abandon_game" command="Abandon" group=FindServerControls }
		"Disconnect" { ControlName=Button xpos=186 ypos=290 wide=128 tall=36 textAlignment="center" zpos=2 style=GreyButton14Style labelText="#dota_disconnect_game" command="Disconnect" group=GameInProgressControls }
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		StatusBarText="220 220 220 255"
		SearchingColor="160 160 160 255"
	}
	
	styles
	{
		"StatusBarTextStyle"
		{
			textcolor=StatusBarText
			font=Arial18Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"StatusBarBGStyle"
		{
			bgcolor=none
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		"SearchingStyle"
		{
			textcolor=SearchingColor
			font=Arial14Thick
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
