"Resource/UI/hud_item_build_group.res"
{	
	this
	{
		"wide"				"100"
		"tall"				"52"
		"minimum-width"		"100"
		"minimum-height"	"52"
		"style"		"Background"
		"mouseinputenabled"	"1"
	}
	
	"GroupLabel"
	{
		"ControlName"		"Label"
		"zpos"				"1"
		"wide"				"100"
		"tall"				"15"
		"enabled"			"1"
		"visible"			"1"
		"labeltext"			"%groupname%"
		"textAlignment"		"west"
		"style"				"GroupLabel"
	}
	
	colors
	{	
		BackgroundTop="82 82 82 255"
		BackgroundBottom="117 117 117 255"
	}
	
	styles
	{	
		Background
		{
			render_bg
			{
				0="gradient( x0, y0, x1, y1, BackgroundTop, BackgroundBottom )"
			}
		}
		
		GroupLabel
		{
			font=DIN12Thick
			textcolor=white
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		place { region=Everything margin-top=1 margin-left=2 Control=GroupLabel }
		place { region=Everything margin-left=2 margin-top=13 Control=*BuildItem }
	}
}
