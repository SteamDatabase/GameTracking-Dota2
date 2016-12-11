"Resource/UI/HUD_TooltipRune.res"
{
	"dota_tooltip"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"dota_tooltip"
		"HudX"					"8"
		"HudY"					"548"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"160"
		"tall"					"600"
		"visible"				"0"
		"enabled"				"1"
		"style"					"TooltipBackground"
	}
	
	PlayerName { ControlName=Label fieldName=PlayerName zpos=1 wide=155 tall=15 labelText="%PlayerName%" textAlignment=west minimum-width=155 minimum-height=15 bgcolor_override="0 151 0 255" font=Arial14Thick style=HeroTooltipPlayerNameStyle }
	divider { ControlName=Panel fieldName=divider zpos=1 wide=155 tall=1 minimum-height=1 style=TooltipDivider }	
	HeroName { ControlName=Label fieldName=HeroName zpos=1 wide=155 tall=15 labelText="%HeroName%" textAlignment=west minimum-width=155 minimum-height=15 style=HeroTooltipHeroNameStyle }
	LevelLabel { ControlName=Label fieldName=LevelLabel zpos=1 wide=155 tall=15 labelText="%Level%" textAlignment=west minimum-width=155 minimum-height=15 style=HeroTooltipLevelStyle }

	styles
	{
		HeroTooltipPlayerNameStyle
		{
			bgcolor=none
			font=Arial14Thick
		}
		HeroTooltipHeroNameStyle
		{
			textcolor=white
			bgcolor=none
			font=Arial12Fine
		}
		HeroTooltipLevelStyle
		{
			textcolor=white
			bgcolor=none
			font=Arial12Fine
		}
	}

	layout
	{
		region { name=tooltip x=0 y=0 width=160 height=600 margin=7 }
		place { region=tooltip dir=down Controls=PlayerName,divider,HeroName,LevelLabel,HeroName2 spacing=0 }
	}
}
