"Resource/UI/DOTALiveGamesPanel.res"
{
	controls
	{
		"DOTALiveGamesListItem"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTALiveGamesListItem"
			wide=700 tall=44
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "64 64 64 255"
		}		
	
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"700"
			"tall"				"44"
			"bgColor_override"	"0 0 0 128"
		}
		
		"GoodTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"GoodTeamLabel"
			"xpos"			"5"
			"ypos"			"5"
			"wide"			"68"
			"tall"			"15"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			scaleImage=1
			image="dashboard/good_team_header"
		}
		
		"BadTeamImage"
		{
			"ControlName"		"ImagePanel"
			"fieldName"		"BadTeamImage"
			"xpos"			"5"
			"ypos"			"25"
			"wide"			"68"
			"tall"			"15"
			"zpos"		"5"
			"visible"		"1"
			"enabled"		"1"
			scaleImage=1
			image="dashboard/bad_team_header"
		}
		
		GoodGuysLabel { ControlName=Label fieldName=GoodGuysLabel style=SmallLabel xpos=78 ypos=5 wide=420 tall=15 labelText="%goodguys%" zpos=2 textAlignment=west }
		BadGuysLabel { ControlName=Label fieldName=BadGuysLabel style=SmallLabel xpos=78 ypos=25 ypos=20 wide=420 tall=15 labelText="%badguys%" zpos=2 textAlignment=west }
		OtherPlayersLabel { ControlName=Label fieldName=OtherPlayersLabel style=SmallLabel xpos=78 wide=420 ypos=5 tall=30 labelText="%others%" wrapText=1 zpos=2 textAlignment=north-west }
		
		SpectateGameButton { ControlName=Button fieldName=SpectateGameButton command="SpectateGameButton" xpos=590 ypos=12 wide=100 tall=20 style=GreyButton14Style labelText="Spectate" zpos=3 textAlignment=center }		// TODO: Localize
	}
	
	include="resource/UI/dashboard_style.res"
}
