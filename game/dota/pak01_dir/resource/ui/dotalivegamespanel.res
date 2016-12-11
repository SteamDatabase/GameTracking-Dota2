"Resource/UI/DOTALiveGamesPanel.res"
{
	controls
	{
		"DOTALiveGamesPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTALiveGamesPanel"
			xpos=30 ypos=20 wide=700 tall=160
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "0 0 0 255"
		}		
	
		Title { ControlName=Label fieldName=Title style=Header labelText="Current Games" xpos=0 ypos=0 wide=150 tall=20 zpos=2 }	// TODO: Localize
		NoGamesLabel { ControlName=Label fieldName=NoGamesLabel style=MinorStatLabel labelText="No games in progress" xpos=0 ypos=20 wide=150 tall=20 zpos=2 }	// TODO: Localize
	}
	
	include="resource/UI/dashboard_style.res"
}
