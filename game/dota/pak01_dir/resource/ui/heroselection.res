"Resource/UI/HeroSelection.res"
{

	"HeroSelection"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"HeroSelection"
		"xpos"				"0"
		"ypos"				"64"
		"wide"				"f0"
		"tall"				"f0"		
		"visible"			"1"
		zpos=100
	}
	
	"Background" { ControlName=Panel fieldName=Background xpos=0 ypos=0 wide=f0 tall=f0 zpos=-1 zpos=-1 bgcolor_override="41 41 41 255" mouseInputEnabled=0 }	
	"BackgroundTop" { ControlName=Panel fieldName=BackgroundTop xpos=c-500 ypos=7 wide=1000 tall=78 zpos=0 bgcolor_override="28 28 28 255" mouseInputEnabled=0 visible=1 }
	
	InstructionLabel { ControlName=Label fieldName=InstructionLabel xpos=c-471 ypos=134 zpos=4 wide=440 tall=20 textAlignment="west" style=InstructionStyle mouseInputEnabled=0 }

	"TeamState"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"TeamState"
		"xpos"				"c-499"
		"ypos"				"11"
		"zpos"				"1"
		"wide"				"998"
		"tall"				"68"
		"enabled"			"1"
		"visible"			"1"
		"bgcolor_override"	"0 0 0 0"
		
		"ModelImage1"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage1"
			"xpos"				"9"
			"ypos"				"2"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
		}
		
		"Button1"
		{
			"ControlName"		"Button"
			"fieldName"			"Button1"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=GoodGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage1"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
				
		"PlayerNameLabel_1"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_1"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player1"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage1"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage2"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage2"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage1"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button2"
		{
			"ControlName"		"Button"
			"fieldName"			"Button2"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=GoodGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage2"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
				
		"PlayerNameLabel_2"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_2"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player2"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage2"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage3"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage3"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage2"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button3"
		{
			"ControlName"		"Button"
			"fieldName"			"Button3"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=GoodGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage3"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
				
		"PlayerNameLabel_3"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_3"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player3"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage3"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage4"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage4"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage3"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button4"
		{
			"ControlName"		"Button"
			"fieldName"			"Button4"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=GoodGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage4"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_4"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_4"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player4"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage4"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage5"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage5"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage4"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button5"
		{
			"ControlName"		"Button"
			"fieldName"			"Button5"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=GoodGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage5"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_5"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_5"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player5"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage5"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"TimerLabel"
		{
			"ControlName"			"Label"
			"fieldName"			"TimerLabel"
			"xpos"				"418"
			"ypos"				"-12"
			"zpos"				"3"
			"wide"				"161"
			"tall"				"71"
			"enabled"			"1"
			"textAlignment"		"center"
			"labelText"			"12"
			style=TimerStyle
		}
		
		"ModelImage6"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage6"
			"xpos"				"534"
			"ypos"				"2"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
		}
		
		"Button6"
		{
			"ControlName"		"Button"
			"fieldName"			"Button6"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=BadGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage6"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_6"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_6"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player6"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage6"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage7"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage7"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage6"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button7"
		{
			"ControlName"		"Button"
			"fieldName"			"Button7"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=BadGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage7"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_7"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_7"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player7"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage7"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage8"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage8"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage7"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button8"
		{
			"ControlName"		"Button"
			"fieldName"			"Button8"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=BadGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage8"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_8"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_8"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player8"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage8"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage9"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage9"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage8"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button9"
		{
			"ControlName"		"Button"
			"fieldName"			"Button9"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=BadGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage9"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_9"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_9"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player9"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage9"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}
		
		"ModelImage10"
		{
			"ControlName"		"ImagePanel"
			"fieldName"			"ModelImage10"
			"xpos"				"7"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"scaleImage"		"1"
			"fillcolor"			"0 0 0 255"
			mouseInputEnabled=0
			
			"pin_to_sibling"		"ModelImage9"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"1"
		}
		
		"Button10"
		{
			"ControlName"		"Button"
			"fieldName"			"Button10"
			"xpos"				"0"
			"ypos"				"0"
			"zpos"				"2"
			"wide"				"86"
			"tall"				"48"
			"enabled"			"1"
			"visible"			"1"
			"scaleImage"		"1"
			"defaultBgColor_override"	"0 0 0 0"
			"armedBgColor_override"		"0 0 0 0"
			style=BadGuyButtonGradient
		
			"pin_to_sibling"		"ModelImage10"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"0"
		}
		
		"PlayerNameLabel_10"
		{
			"ControlName"			"Label"
			"fieldName"				"PlayerNameLabel_10"
			"xpos"					"0"
			"ypos"					"0"
			"zpos"					"3"
			"wide"					"86"
			"tall"					"19"
			"enabled"				"1"
			"textAlignment"			"center"
			"labelText"				"Player10"
			"style"					"PlayerNameStyle"
			
			"pin_to_sibling"		"ModelImage10"
			"pin_corner_to_sibling"	"0"
			"pin_to_sibling_corner"	"2"
		}		
	}
		
	"FilterBar"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"FilterBar"
		"xpos"				"c-512"
		"ypos"				"96"
		"zpos"				"1"
		"wide"				"512"
		"tall"				"28"
		"enabled"			"1"
		"visible"			"1"
		"bgcolor_override"	"0 0 0 0"
		"paintbackgroundenabled" "0"
		
		"filterbutton_selected"	"120 120 120 255"
		"filterbutton_unselected"	"72 72 72 255"
		
		"FilterCombo"
		{
			"ControlName"		"ComboBox"
			"fieldName"			"FilterCombo"
			"xpos"				"15"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"232"
			"tall"				"25"
			"autoResize"		"0"
			"pinCorner"			"0"
			"visible"			"1"
			"enabled"			"1"
			"tabPosition"		"0"
			"textHidden"		"0"
			"editable"			"0"
			"maxchars"			"63"
			
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"0 0 0 255"
		}	
		
		"SearchTextEntry"
		{
			"ControlName"		"TextEntry"
			"fieldName"			"SearchTextEntry"
			"xpos"				"256"
			"ypos"				"0"
			"zpos"				"3"
			"wide"				"232"
			"tall"				"25"
			"autoResize"		"0"
			"pinCorner"			"0"
			"visible"			"1"
			"enabled"			"1"
			"tabPosition"		"0"
			"textHidden"		"0"
			"editable"			"1"
			"maxchars"			"63"
			
			"fgcolor_override"	"255 255 255 255"
			"bgcolor_override"	"0 0 0 255"
		}
		
		SearchOverlayLabel { ControlName=Label fieldName=SearchOverlayLabel xpos=264 ypos=0 zpos=4 wide=232 tall=25 style=PlayerNameStyle mouseInputEnabled=0 labelText="SEARCH HEROES" }		// TODO: Localize
	}
	
	"PickerGrid"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"PickerGrid"
		"xpos"				"c-512"
		"ypos"				"151"
		"zpos"				"1"
		"wide"				"541"
		"tall"				"495"
		"enabled"			"1"
		"visible"			"1"
		"bgcolor_override"	"0 0 0 0"
		
		"button_size_x"		"58"
		"button_size_y"		"32"
		"button_gap"		"2"
		"button_rowsize"	"4"		// icons per row
		
		"button_inactive_color"	"0 0 0 255"
		
		"button_pos_good_str_x"		"15"
		"button_pos_good_str_y"		"23"
		
		"button_pos_good_agi_x"		"15"
		"button_pos_good_agi_y"		"182"
		
		"button_pos_good_int_x"		"15"
		"button_pos_good_int_y"		"341"
		
		"button_pos_bad_str_x"		"256"
		"button_pos_bad_str_y"		"23"
		
		"button_pos_bad_agi_x"		"256"
		"button_pos_bad_agi_y"		"182"
		
		"button_pos_bad_int_x"		"256"
		"button_pos_bad_int_y"		"341"
		
	}
	
	"SelectionDetails"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"SelectionDetails"
		"xpos"				"c30"
		"ypos"				"98"
		"zpos"				"2"
		"wide"				"460"
		"tall"				"406"
		"enabled"			"1"
		"visible"			"1"
		"bgcolor_override"	"0 0 0 0"
	}
	"HeroDetailsBg" { ControlName=Panel fieldName=HeroDetailsBg xpos=c29 ypos=98 wide=471 tall=370 zpos=0 style=HeroDetailsGradient mouseInputEnabled=0 visible=1 }
	
	"LobbyChatHistory"
	{
		"ControlName"			"RichText"
		"fieldName"				"LobbyChatHistory"
		"xpos"		"c30"
		"ypos"		"560"
		"wide"		"473"
		"tall"		"110"
		"wrap"					"1"
		"zpos"		"20"
		"autoResize"			"1"
		"pinCorner"				"1"
		"visible"				"1"
		"enabled"				"1"
		"labelText"				""
		"textAlignment"			"south-west"
//		"font"					"ChatFont"
//		"maxchars"				"-1"
		"bgcolor_override"     	"30 29 29 255"
	}

	"ChatInputLine"
	{
		"ControlName"		"EditablePanel"
		"fieldName" 		"ChatInputLine"
		"visible" 		"1"
		"enabled" 		"1"
		"xpos"		    	"c30"
		"ypos"			"675"
		"zpos"			"51"
		"wide"	 		"473"
		"tall"	 		"20"
		"bgcolor_override"     	"255 29 29 0"
		"zpos" "49"
	}
	"ChatInputBg"
	{
		"ControlName"		"Panel"
		"fieldName" 		"ChatInputBg"
		"visible" 		"1"
		"enabled" 		"1"                             
		"xpos"		    "c28"
		"ypos"			"673"
		"zpos"			"48"
		"wide"	 		"477"
		"tall"	 		"24"
		"bgcolor_override"     	"30 29 29 255"
		"mouseinputenabled" "0"
	}
	
	"RandomButton"
	{
		"ControlName"		"Button"
		"fieldName"			"RandomButton"
		"xpos"				"c-380"
		"ypos"				"635"
		"wide"				"219"
		"tall"				"28"
		"zpos"				"5"
		"visible"			"1"
		"enabled"			"1"
		"labelText"			"#DOTA_Hero_Selection_Random"
		"textAlignment"		"center"
		"style"				"GreyButton14Style"
		"PaintBackgroundType"	"0"
		"command"			"random"
	}
	
	"ConfirmButton"
	{
		"ControlName"		"Button"
		"fieldName"			"ConfirmButton"
		"xpos"				"c145"
		"ypos"				"511"
		"wide"				"219"
		"tall"				"28"
		"zpos"				"5"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"style"				"GreyButton14Style"
		"PaintBackgroundType"	"0"
		"allCaps"			"1"
		"command"			"select"
	}
	
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		SelectedPlayerNameColor="255 255 255 255"
		PlayerNameColor="114 114 114 255"
		GoodGuyButtonGradientTop="37 62 72 255"
		GoodGuyButtonGradientBottom="71 126 147 255"
		BadGuyButtonGradientTop="75 48 17 255"
		BadGuyButtonGradientBottom="153 98 33 255"
		DisabledButtonGradientTop="17 17 17 255"
		DisabledButtonGradientBottom="98 98 98 255"
		SearchOverlayColor="114 114 114 255"
		InstructionColor="255 255 255 255"
		TimerColor="156 154 154 255"
		HeroDetailsGradientTop="53 53 53 255"
		HeroDetailsGradientBottom="41 41 41 255"
	}
	styles
	{
		PlayerNameStyle
		{
			font=DefaultVeryTiny
			textcolor=PlayerNameColor
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}		
		SelectedPlayerNameStyle
		{
			font=Default
			textcolor=SelectedPlayerNameColor
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		GoodGuyButtonGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, GoodGuyButtonGradientTop, GoodGuyButtonGradientBottom )"
			}
		}
		BadGuyButtonGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, BadGuyButtonGradientTop, BadGuyButtonGradientBottom )"
			}
		}
		HeroDetailsGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, HeroDetailsGradientTop, HeroDetailsGradientBottom )"
			}
		}		
		DisabledGradient
		{
			render_bg
			{
				// background fill
				0="gradient( x0, y0, x1, y1, DisabledButtonGradientTop, DisabledButtonGradientBottom )"
			}
		}
		SearchOverlayStyle
		{
			font=DefaultTiny
			textcolor=SearchOverlayColor
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		InstructionStyle
		{
			font=DefaultLarge
			textcolor=InstructionColor
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		TimerStyle
		{
			font=DefaultLargeTimer
			textcolor=TimerColor
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
	}
}
