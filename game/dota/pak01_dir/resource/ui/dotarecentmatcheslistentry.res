"Resource/UI/DOTARecentMatchesListEntry.res"
{
	controls
	{
		"DOTARecentMatchesListEntry"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTARecentMatchesListEntry"
			"wide"	 		"700"
			"tall"	 		"35"
			"zpos"			"2"
			"bgcolor_override" "0 0 0 0"
		}
		"Background"
		{
			"ControlName"		"Panel"
			"fieldName"			"Background"
			"xpos"				"0"
			"ypos"				"0"
			"wide"				"756"
			"tall"				"33"
			"mouseinputenabled"	"0"
		}

		"DateLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"DateLabel"
			"xpos"				"5"
			"ypos"				"0"
			"wide"				"150"
			"tall"				"18"
			"textAlignment"			"west"
			"style"				"StatLabel"
			"labelText"			"%date%"
			"mouseinputenabled"	"0"
		}
		"MatchIDLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"MatchIDLabel"
			"xpos"				"5"
			"ypos"				"14"
			"wide"				"80"
			"tall"				"16"
			"textAlignment"			"west"
			"labelText"			"%matchID%"
			"style"				"MinorStatLabel"
			"mouseinputenabled"	"0"
		}
		
		"HeroImage0" { ControlName=ImagePanel fieldName=HeroImage0 wide=16 tall=16 scaleImage=1 ypos=0 xpos=200 }
		"HeroImage1" { ControlName=ImagePanel fieldName=HeroImage1 wide=16 tall=16 scaleImage=1 ypos=0 xpos=217 }
		"HeroImage2" { ControlName=ImagePanel fieldName=HeroImage2 wide=16 tall=16 scaleImage=1 ypos=0 xpos=234 }
		"HeroImage3" { ControlName=ImagePanel fieldName=HeroImage3 wide=16 tall=16 scaleImage=1 ypos=0 xpos=251 }
		"HeroImage4" { ControlName=ImagePanel fieldName=HeroImage4 wide=16 tall=16 scaleImage=1 ypos=0 xpos=268 }
		
		"VsLabel" { ControlName=Label fieldName=VsLabel wide=30 tall=20 ypos=0 xpos=386 style=StatLabel labelText="VS" mouseInputEnabled=0 visible=0 }		//TODO:Localize
		
		"HeroImage5" { ControlName=ImagePanel fieldName=HeroImage5 wide=16 tall=16 scaleImage=1 ypos=17 xpos=200 }
		"HeroImage6" { ControlName=ImagePanel fieldName=HeroImage6 wide=16 tall=16 scaleImage=1 ypos=17 xpos=217 }
		"HeroImage7" { ControlName=ImagePanel fieldName=HeroImage7 wide=16 tall=16 scaleImage=1 ypos=17 xpos=234 }
		"HeroImage8" { ControlName=ImagePanel fieldName=HeroImage8 wide=16 tall=16 scaleImage=1 ypos=17 xpos=251 }
		"HeroImage9" { ControlName=ImagePanel fieldName=HeroImage9 wide=16 tall=16 scaleImage=1 ypos=17 xpos=268 }
		
		"PlayerNames0" { ControlName=Label fieldName=PlayerNames0 wide=330 tall=16 ypos=0 xpos=350 style=MinorStatLabel mouseInputEnabled=0 labelText="%playernames0%" textAlignment=west }
		"PlayerNames1" { ControlName=Label fieldName=PlayerNames1 wide=330 tall=16 ypos=16 xpos=350 style=MinorStatLabel mouseInputEnabled=0 labelText="%playernames1%" textAlignment=west }
	}
	
	include="resource/UI/dashboard_style.res"
}