"Resource/UI/hud_item_build_panel.res"
{
	this
	{
		"style"	"nobackground"
		"scroll_section_width"	"180"
		"scroll_step"		"35"
	}
	
	"LowerBackground"
	{
		"ControlName"	"Panel"
		"xpos"			"0"
		"ypos"			"15"
		"zpos"			"1"
		"wide"			"900"
		"tall"			"90"
		"visible"		"1"
		"style"			"Background"		
	}
		
	"AuthorName"
	{
		"ControlName"	"Label"
		"zpos"			"2"
		"wide"			"100"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%author%"
		"textAlignment"	"west"
		"style"			"Author"
		"minimum-height"	"15"
		//"minimum-width"	"100"
	}
	
	"TitleLabel"
	{
		"ControlName"	"Label"
		"zpos"			"2"
		"wide"			"200"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%title%"
		"textAlignment"	"west"
		"style"			"Title"
		"minimum-height"	"15"
		//"minimum-width"	"200"
	}
	
	"LoadButton"
	{
		"ControlName"		"Button"
		"zpos"				"200"
		"wide"				"120"
		"tall"				"15"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"west"
		"command"			"load"
		"labeltext"			"load"	
		"mouseinputenabled"	"1"	
		"style"				"LoadButton"
	}
	
	"ClearButton"
	{
		"ControlName"		"Button"
		"zpos"				"200"
		"wide"				"120"
		"tall"				"20"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"clear"
		"labeltext"			"clear"	
		"mouseinputenabled"	"1"	
		"style"				"Button"
	}
	
	"Shadow"
	{
		"ControlName"		"Panel"
		"wide"			"900"
		"ypos"			"7"
		"tall"			"10"		
		"visible"		"1"
		"style"			"shadow"
	}
	
	colors
	{
		TitleBackground="104 104 104 255"
		
		BackgroundTop="98 98 98 255"
		BackgroundBottom="69 69 69 255"
		
		// debug		
		ButtonTop="113 113 113 255"
		ButtonBottom="80 80 80 255"
	}
	
	styles
	{		
		nobackground	
		{
			render_bg 
			{
				0="fill( x0, y0, x1, y1, none )"
			}
		}
		
		Background
		{
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, BackgroundTop, BackgroundBottom )"
			}
		}
		
		Author
		{
			font=DIN12Thick
			textcolor=white
			inset-left=5
			inset-right=5
			
			render_bg
			{
				0="roundedfill( x0, y0, x1+10, y1+10, 8, TitleBackground )"
				1="fill( x1-1, y0, x1, y1, black )"
				2="fill( x0, y1-1, x1, y1, black )"
			}
		}
		
		Title
		{
			font=DIN12Thick
			textcolor=white
			inset-left=5
			inset-right=5
			
			render_bg
			{
				0="roundedfill( x0-10, y0, x1, y1+10, 8, TitleBackground )"
				1="fill( x0, y1-1, x1, y1, black )"
			}
		}
		
		LoadButton
		{
			font=DIN12Thick
			textcolor=white
			inset-left=5
			inset-right=5
			
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1+10, 8, TitleBackground )"
				1="fill( x0, y1-1, x1, y1, black )"
			}
		}
		
		GroupLabel
		{
			font=DIN10Thick
			textcolor=white
		}
		
		Button
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, ButtonTop, ButtonBottom )"
			}
		}
		
		shadow
		{
			bgcolor=none
			render_bg
			{
				0="gradient( x0, y0, x1, y1, none, black )"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		region { name=Header x=155 y=0 height=max width=500 }
		place { region=Header align=top-center Control=AuthorName,TitleLabel }
		place { region=Header margin=4 margin-top=3 margin-right=0 spacing=2 align=right Control=LoadButton,ClearButton }
		
		region { name=Groups x=5 y=0 height=81 width=890 overflow=scroll-horizontal }
		place { region=Groups spacing=4 margin-top=23 Controls=*BuildGroup }
	}
}
