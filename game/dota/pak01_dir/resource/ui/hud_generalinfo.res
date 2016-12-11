"Resource/UI/Hud_GeneralInfo.res"
{
	//=========================================================================
	//
	// General Panel Data.
	//
	
	"HudDOTAGeneralInfo"
	{
		"ControlName"			"EditablePanel"
		"fieldName"				"HudDOTAGeneralInfo"
		"xpos"					"300"
		"ypos"					"50"
		"wide"					"350"
		"tall"					"500"
		"zpos"					"1"
		"settitlebarvisible"	"0"
		"visible"				"0"
		"enabled"				"0"
		"bgcolor"				"0 0 0 255"
		"bgcolor_override"		"0 0 0 255"
		"fgcolor_override"		"255 255 193 255"
	}

	"Background"
	{
		"ControlName"		"Panel"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"1"
		"wide"				"350"
		"tall"				"500"
		"enabled"			"1"
		"visible"			"1"
		"style"				"Background"
	}

	//=========================================================================
	//
	// HTML.
	//

	"BackButton"
	{
		"ControlName"		"Button"
		"zpos"				"3"
		"wide"				"154"
		"tall"				"32"
		"minimum-height"	"24"
		"command"			"back" 
		"labelText"			"<"
		"visible"			"0"
		"enabled"			"1"	
		"style"				"BrowserButton"
	}
	
	"ForwardButton"
	{
		"ControlName"		"Button"
		"zpos"				"3"
		"wide"				"154"
		"tall"				"32"
		"minimum-height"	"24"
		"command"			"forward" 
		"labelText"			">"
		"visible"			"0"
		"enabled"			"1"	
		"style"				"BrowserButton"
	}

	"RefreshButton"
	{
		"ControlName"		"Button"
		"zpos"				"3"
		"wide"				"154"
		"tall"				"32"
		"minimum-height"	"24"
		"command"			"refresh" 
		"labelText"			"Refresh"
		"visible"			"1"
		"enabled"			"1"	
		"style"				"BrowserButton"
	}
	
	"HudDOTAGeneralInfo_HTML"
	{
		"ControlName"		"HTML"
		"xpos"				"0"
		"ypos"				"24"
		"zpos"				"2"
		"wide"				"350"
		"tall"				"476"
 		"autoResize"		"3"
 		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"0"
	}	

	colors
	{
		// shop button
		Black="0 0 0 255"
		Red="255 0 0 255"
		
		ShopCategoryLabel="220 220 220 255"
		
		// shop button
		ShopButtonInactive="88 88 88 255"
		ShopButtonHover="255 255 255 255"
		ShopButtonActive="255 255 255 255"
		ShopButtonBGInactive="24 24 24 255"		
		ShopButtonBGActive="45 45 45 255"
		
		
		SubShopBGActive="124 124 124 255"
		
		ItemBackgroundEnd="54 54 54 255"
	}
	
	styles
	{
		Background
		{
			bgcolor=Black
		}
			
		BrowserButton
		{
			font=Arial10Thick
			textcolor=ShopButtonInactive
			padding-left=10
			padding-right=10
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGInactive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		BrowserButton:active
		{
			font=Arial10Thick
			textcolor=ShopButtonActive
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		BrowserButton:selected
		{
			font=Arial10Thick
			textcolor=ShopButtonActive
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
		
		BrowserButton:hover:active
		{
			font=Arial10Thick
			textcolor=ShopButtonHover
			render_bg 
			{
				0="fill( x0, y0, x1, y1, ShopButtonBGActive )"
				1="fill( x1-1, y0, x1, y1, LightGrey )"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		place { region=Everything dir=right margin-top=0 Control=RefreshButton,BackButton,ForwardButton }
	}
}