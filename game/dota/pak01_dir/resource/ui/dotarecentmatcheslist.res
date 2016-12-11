"Resource/UI/DOTARecentMatchesList.res"
{
	controls
	{
		"DOTARecentMatchesList"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTARecentMatchesList"
			"visible" 		"1"
			"enabled" 		"1"
			"xpos"			"c-388"
			//"ypos"			"56"
			"wide"	 		"776"
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
			"wide"				"768"
			"tall"				"416"
			style=GreyNoiseBackground
			MouseInputEnabled=0
		}
		
		"BackgroundInner"
		{
			"ControlName"		"Panel"
			"fieldName"			"BackgroundInner"
			"xpos"				"8"
			"ypos"				"8"
			"zpos"				"0"
			"wide"				"752"
			"tall"				"400"
			"style"				"DashboardInnerBackground"
			"visible"			"1"
			MouseInputEnabled=0
		}
		
		"SpinningCircle" { ControlName=CircularProgressBar fieldName=SpinningCircle wide=60 tall=60 xpos=340 ypos=150 zpos=6 alpha=255 fgcolor_override="255 255 255 128" bgcolor_override="64 64 64 64" }
		
		"PageLabel" { ControlName=Label fieldName=PageLabel wide=68 tall=20 ypos=377 xpos=20 style=MinorStatLabel labelText="%page%" mouseInputEnabled=0 visible=1 textAlignment=south-east }
		
		"PreviousPage" { ControlName=Button fieldName=PreviousPage zpos=10 xpos=250 ypos=375 wide=110 tall=25 labelText="PREVIOUS" command="PreviousPage" style=GreyButton14Style textAlignment=center } // TODO:Localize
		"NextPage" { ControlName=Button fieldName=NextPage zpos=10 xpos=380 ypos=375 wide=110 tall=25 labelText="NEXT" command="NextPage" style=GreyButton14Style textAlignment=center } // TODO:Localize
		
		"CloseButton" { ControlName=Button fieldName=CloseButton zpos=10 xpos=625 ypos=375 wide=110 tall=25 labelText="BACK" command="ClosePage" style=GreyButton14Style textAlignment=center } // TODO: Localize
	}
	include="resource/UI/dashboard_style.res"
	
	styles
	{
		include="resource/UI/dashboard_style.res"
	}	
}
