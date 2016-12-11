"Resource/UI/HUD_TooltipRune.res"
{
	"HeroOverheadTooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HeroOverheadTooltip"
		
		"zpos"					"5"
		"wide"					"86"
		"tall"					"36"
		"style"					"TooltipBackgroundTransparent"
	}
	
	PlayerName { ControlName=Label fieldName=PlayerName zpos=1 wide=80 tall=10 labelText="%PlayerName%" textAlignment=center minimum-width=80 minimum-height=10 style=HeroTooltipPlayerNameStyle }
	HeroName { ControlName=Label fieldName=HeroName zpos=1 wide=80 tall=10 labelText="%HeroName%" textAlignment=center minimum-width=80 minimum-height=10 style=HeroTooltipHeroNameStyle }
	LevelLabel { ControlName=Label fieldName=LevelLabel zpos=1 wide=80 tall=10 labelText="%Level%" textAlignment=center minimum-width=80 minimum-height=10 style=HeroTooltipLevelStyle }

	styles
	{
		HeroTooltipPlayerNameStyle
		{
			bgcolor=none
			font=Arial11Thick
		}
		HeroTooltipHeroNameStyle
		{
			textcolor=white
			bgcolor=none
			font=Arial10Fine
		}
		HeroTooltipLevelStyle
		{
			textcolor=white
			bgcolor=none
			font=Arial10Fine
		}
	}

	layout
	{
		region { name=tooltip x=0 y=0 width=80 height=36 margin=3 }
		place { region=tooltip dir=down Controls=PlayerName,HeroName,LevelLabel,HeroName2 spacing=0 }
	}
}
