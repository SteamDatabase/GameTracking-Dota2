//------------------------------------
// Matchmaker Item
//------------------------------------
"DOTAPracticeLobbyListEntry.res"
{	
	controls
	{
		"DOTAPracticeLobbyListEntry"
		{
		  "ControlName"	"CDOTAPracticeLobbyListEntry"
		  "wide"						"420"
		  "tall"						"64"
		  "PaintBackground" "0"
		}

		"Background" { ControlName=Panel fieldName="Background" mouseInputEnabled=0 style=ProfileGradientBackground wide=594 tall=64 zpos=-1}
		    
		"GameName"
		{
		  "ControlName"	"label"
		  "labeltext"		"PRACTICE LOBBY"
		  "xpos"			"10"
		  "ypos"			"2"
		  "wide"			"256"
		  "tall"			"20"
		  "font"			"AchievementItemTitle"
		  "textAlignment"		"west"
		  style=SectionTitle
		  mouseinputenabled=0
		}

		"GameDesc"
		{
		  "ControlName"	"label"
		  "labeltext"		"%Players%"
		  "xpos"			"15"
		  "ypos"			"22"
		  "wide"			"280"
		  "tall"			"40"
		  "font"			"AchievementItemDescription"
		  "wrap"			"1"
		  "textAlignment"		"north-west"
		  style=StatLabel
		  mouseinputenabled=0
		}
		
		JoinLobbyButton { ControlName=Button command="Join" xpos=305 ypos=17 wide=100 tall=30 style=GreyButtonStyle labelText="Join" zpos=3 textAlignment=center }		// TODO: Localize
	}
	include="resource/UI/dashboard_style.res"
}
