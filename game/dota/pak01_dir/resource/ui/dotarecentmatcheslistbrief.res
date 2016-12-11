"Resource/UI/DOTARecentMatchesListBrief.res"
{
	controls
	{
		"DOTARecentMatchesListBrief"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTARecentMatchesListBrief"
			"visible" 		"1"
			"enabled" 		"1"
			"wide"	 		"776"
			"tall"	 		"150"
			"zpos"			"2"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		Title { ControlName=Label fieldName=Title style=Header labelText="Recent Games" xpos=0 ypos=0 wide=150 tall=20 zpos=2 }	// TODO: Localize
		MoreButton { ControlName=Button fieldName=MoreButton command="More" labelText="more..." xpos=0 ypos=120 tall=20 wide=70 zpos=2 } // TODO: Localize
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
