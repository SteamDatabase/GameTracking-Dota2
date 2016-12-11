"Resource/UI/DOTAHeroesPlayedPanel.res"
{
	controls
	{
		"DOTAHeroesPlayedPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAHeroesPlayedPanel"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-288"
			//"ypos"			"56"
			"wide"	 		"576"
			"tall"	 		"416"
			"zpos"			"21"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "58 58 58 255"
		}
		
		"Background"
		{
			"ControlName"			"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"0"
			"wide"				"568"
			"tall"				"416"
			style=GreyNoiseBackground
			mouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"552"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			"mouseInputEnabled"	"0"
		}
		
		"CloseButton"
		{
			"ControlName"			"Button"
			"fieldName"			"CloseButton"
			"xpos"				"450"
			"ypos"				"380"
			"zpos"				"2"
			"wide"				"70"
			"tall"				"14"
			"textAlignment"		"north-west"
			"labelText"			"#dota_match_history_back"
			"command"			"ClosePage"
		}
		
		"HeroTitle"	{ ControlName=Label fieldName=HeroTitle xpos=20 ypos=15 wide=100 tall=15 textAlignment="west" labelText="HERO" style="SectionTitle" zpos=2 }		// TODO: Localize
		"WinsTitle"	{ ControlName=Label fieldName=WinsTitle xpos=180 ypos=15 wide=40 tall=15 textAlignment="east" labelText="WINS" style="SectionTitle" zpos=2 }
		"LossesTitle"	{ ControlName=Label fieldName=LossesTitle xpos=260 ypos=15 wide=40 tall=15 textAlignment="east" labelText="LOSSES" style="SectionTitle" zpos=2 }
		
		"HeroList" { ControlName=PanelListPanel fieldName=HeroList xpos=20 ypos=35 wide=330 tall=345 zpos=2 }
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
