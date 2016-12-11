"Resource/UI/HUD_Fullscreen_Shop_Item_Details.res"
{
	this
	{
		style=Background
	}
	

	
	"TopCellBackground"
	{
		"ControlName"	"Panel"
		"wide"			"248"
		"tall"			"34"
		"minimum-width"	"248"
		"minimum-height"	"34"
		"zpos"			"0"
		"visible"		"1"
		"style"			"TopCellBackground"	
	}
	
	"SelectedItem"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"SelectedItem"
		"zpos"				"1"
		"wide"				"40"
		"tall"				"30"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"fillcolor"			"150 150 150 255"
		"minimum-width"		"40"
		"minimum-height"	"30"
	}
		
	"ItemName"
	{
		"ControlName"	"Label"
		"fieldName"		"ItemName"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%itemname%"
		"textAlignment"	"west"
		"style"			"ItemName"
		"minimum-width"	"200"
		"minimum-height"	"15"
	}
	
	"CostImage"
	{
		"ControlName"	"ImagePanel"
		"wide"			"16"
		"tall"			"16"
		"scaleImage"	"1"
		"image"			"materials/vgui/hud/gold.vmat"
		"minimum-width"	"16"
		"minimum-height""16"
	}
	
	"ItemCost"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"minimum-height"	"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%itemcost%"
		"textAlignment"	"west"
		"style"			"ItemCost"
	}
	
	"CompleteItemCost"
	{
		"ControlName"	"Label"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"minimum-height""15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		""
		"textAlignment"	"west"
		"style"			"ItemCost"
	}
	
	"PageButton1"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"PageButton1"
		"zpos"				"2"
		"wide"				"18"
		"tall"				"18"
		"minimum-width"		"18"
		"minumum-height"	"18"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page1"
		"style"				"PageButton"
		"labeltext"			" "	
		"tabPosition"		"0"
		"subtabposition"	"0"
	}
	
	"PageButton2"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"PageButton2"
		"zpos"				"2"
		"wide"				"18"
		"tall"				"18"
		"minimum-width"		"18"
		"minumum-height"	"18"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page2"
		"style"				"PageButton"	
		"labeltext"			" "		
		"tabPosition"		"0"
		"subtabposition"	"1"
	}
	
	"PageButton3"
	{
		"ControlName"		"RadioButton"
		"fieldName"			"PageButton3"
		"zpos"				"2"
		"wide"				"18"
		"tall"				"18"
		"minimum-width"		"18"
		"minumum-height"	"38"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page3"
		"style"				"PageButton"
		"labeltext"			" "		
		"tabPosition"		"0"
		"subtabposition"	"2"	
	}
		
	"description"
	{
		"ControlName"	"Label"
		"fieldName"		"description"
		"zpos"			"3"
		"wide"			"240"
		"tall"			"45"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%abilitydesc%"
		"textAlignment"	"north-west"
		"wrap"			"1"
		"style"			"Description"
		"minimum-width"	"240"
		"mouseinputenabled"	"0"
		"auto_tall_tocontents"	"1"
	}	
	
	"variables"
	{
		"ControlName"	"RichText"
		"font" 			"Arial12Thick"
		"zpos"			"3"
		"wide"			"180"
		"tall"			"50"
		"enabled"		"1"
		"visible"		"1"
		"textAlignment"		"west"
		"bgcolor_override"	"151 0 0 0"
		"fgcolor_override"	"175 175 175 255"
		"scrollbar"		"false"
		"text"			"GRABALALA!"
		"wrap"	"0"
		"minimum-width"	"180"
		"mouseinputenabled"	"0"
	}
	
	"ManaImage"
	{
		"ControlName"		"ImagePanel"
		"fieldName"			"ManaImage"
		"xpos"				"-100"
		"ypos"				"6"
		"zpos"				"3"
		"wide"				"10"
		"tall"				"10"
		"enabled"			"1"
		"visible"			"1"
		"scaleImage"		"1"
		"fillcolor"			"255 255 255 0"
		"image"				"materials/vgui/hud/tool_tip-icon_2.vmat"
		"minimum-height""10"
		"minimum-width"	"10"
		"mouseinputenabled"	"0"
	}
	
	"ManaCost"
	{
		"ControlName"		"RichText"
		"fieldName"		"ManaCost"
		"font" 			"Arial12Med"
		"xpos"			"0"
		"ypos"			"3"
		"zpos"			"3"
		"wide"			"120"
		"tall"			"14"
		"enabled"		"1"
		"visible"		"1"
		"text"			"0"
		"scrollbar"		"false"
		"textAlignment"		"west"
		"bgcolor_override"	"151 151 151 0"
		"fgcolor_override"	"151 151 151 255"
		"style"			"IconProperty"
		"minimum-width"		"100"
		"mouseinputenabled"	"0"
	}

	"CooldownImage"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"CooldownImage"
		"xpos"			"-8"
		"ypos"			"6"
		"zpos"			"3"
		"wide"			"10"
		"tall"			"10"
		"enabled"		"1"
		"visible"		"1"
		"scaleImage"	"1"
		"fillcolor"		"255 255 255 0"
		"image"			"materials/vgui/hud/tool_tip-icon_1.vmat"
		"minimum-height""10"
		"minimum-width"	"10"
		"mouseinputenabled"	"0"
	}
	
	"Cooldown"
	{
		"ControlName"	"RichText"
		"fieldName"		"Cooldown"
		"font" 			"Arial12Med"
		"xpos"			"0"
		"ypos"			"3"
		"zpos"			"3"
		"wide"			"120"
		"tall"			"14"
		"enabled"		"1"
		"visible"		"1"
		"text"			"0"
		"scrollbar"		"false"
		"textAlignment"		"west"
		"bgcolor_override"	"151 151 151 0"
		"fgcolor_override"	"151 151 151 255"
		"style"			"IconProperty"
		"minimum-width"		"100"
		"mouseinputenabled"	"0"
	}
		
	"QuickBuyButton"
	{
		"ControlName"		"Button"
		"zpos"				"2"
		"wide"				"120"
		"tall"				"32"
		"minimum-width"		"120"
		"minimum-height"	"32"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"setquickbuy"
		"labeltext"			"#DOTA_SHOP_DETAILS_ADD_TO_QUICK"
		"mouseinputenabled"	"1"
		"style"				"QuickBuyButton"
	}
	
	"UpgradeButton"
	{
		"ControlName"		"Button"
		"zpos"				"3"
		"wide"				"120"
		"tall"				"32"
		"minimum-width"		"120"
		"minimum-height"	"32"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"upgrade"
		"labeltext"			"#DOTA_SHOP_DETAILS_UPGRADE"	
		"mouseinputenabled"	"1"	
		"style"				"PurchaseButton"
	}
	
	"PurchaseButton"
	{
		"ControlName"		"Button"
		"zpos"				"2"
		"wide"				"120"
		"tall"				"32"
		"minimum-width"		"120"
		"minimum-height"	"32"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"purchase"
		"labeltext"			"#DOTA_SHOP_DETAILS_PURCHASE"	
		"mouseinputenabled"	"1"	
		"style"				"PurchaseButton"
	}
	
	"CompleteItemButton"
	{
		"ControlName"		"Button"
		"zpos"				"3"
		"wide"				"120"
		"tall"				"32"
		"minimum-width"		"120"
		"minimum-height"	"32"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"purchase"
		"labeltext"			"#DOTA_SHOP_DETAILS_COMPLETE"	
		"mouseinputenabled"	"1"	
		"style"				"PurchaseButton"
	}
	
	"CombinePanel"
	{
		"ControlName"		"CShopItemCombinePanel"
		"zpos"				"2"
		"wide"				"250"
		"tall"				"142"
		"visible"			"1"
		"enabled"			"1"
		"mouseinputenabled"	"1"		
	}
	
	colors
	{
		Background="70 70 70 255"
		BuyButtonTextActive="0 0 0 255"
		BuyButtonTextDisabled="160 160 160 255"
		BuyButtonActive="252 176 64 255"
		BuyButtonDisabled="70 70 70 255"
		RequirementsBackground="65 65 65 255"
		
		TopCellHighlight="131 131 131 255"
		TopCellTop="112 112 112 255"
		TopCellBottom="80 80 80 255"
				
		PurchaseButtonTop="199 153 13 255"
		PurchaseButtonBottom="140 107 9 255"
		PurchaseButtonDisabled="120 120 120 255"
		
		QuickBuyButtonTop="105 130 138 255"
		QuickBuyButtonBottom="171 195 199 255"
	}
	
	styles
	{		
		Background
		{
			bgcolor=Background
		}
		
		TopCellBackground
		{
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, TopCellTop, TopCellBottom )"
				1="fill( x0, y0, x1, y0+1, TopCellHighlight )"
			}
		}
		
		QuickBuyButton
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, QuickBuyButtonBottom, QuickBuyButtonTop )"
				1="fill(x0,y0,x0+1,y1,black)"
				2="fill(x1-1,y0,x1,y1,black)"
				3="fill(x0,y1-1,x1,y1,black)"
				4="fill(x0,y0,x1,y0+1,black)"
			}		
		}
		
		QuickBuyButton:active
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, QuickBuyButtonTop, QuickBuyButtonBottom )"
				1="fill(x0,y0,x0+1,y1,black)"
				2="fill(x1-1,y0,x1,y1,black)"
				3="fill(x0,y1-1,x1,y1,black)"
				4="fill(x0,y0,x1,y0+1,black)"
			}		
		}
		
		PurchaseButton
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, PurchaseButtonTop, PurchaseButtonBottom )"
				1="fill(x0,y0,x0+1,y1,black)"
				2="fill(x1-1,y0,x1,y1,black)"
				3="fill(x0,y1-1,x1,y1,black)"
				4="fill(x0,y0,x1,y0+1,black)"
			}
		}
		
		PurchaseButton:active
		{
			font=DIN14Thick
			textcolor=white
			render_bg 
			{
				0="gradient( x0, y0, x1, y1, PurchaseButtonDisabled, PurchaseButtonBottom )"
			}
		}
		
		PurchaseButton:disabled
		{
			font=DIN14Thick
			textcolor=white
			render_bg
			{
				0="fill( x0, y0, x1, y1, PurchaseButtonDisabled )"
				1="fill(x0,y0,x0+1,y1,black)"
				2="fill(x1-1,y0,x1,y1,black)"
				3="fill(x0,y1-1,x1,y1,black)"
				4="fill(x0,y0,x1,y0+1,black)"
			}
		}
		
		Description
		{
			font=Arial10Thick
		}
		
		IconProperty
		{
			// inset so it lines up with the text
			inset-left=2
			inset-top=-3
			textcolor=tooltipgrey			
			render_bg
			{
				0="fill(x0,y0,x1,y1,none)"
			}
		}
		
		ItemName
		{
			font=DIN14Thick
			bgcolor=none
		}
		
		ItemCost
		{
			textcolor=GoldLabelColor
			font=DIN14Thick
		}
		
		PageButton
		{
			font=DIN14Thick
			render
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
			}
		}
		
		PageButton:hover
		{			
			font=DIN14Thick
			render
			{
				1="fill(x0,y0,x1,y1,GoldLabelColor)"
				0="fill(x0+1,y0+1,x1-1,y1-1,LighterGrey)"
			}
		}	
		
		PageButton:selected
		{			
			font=DIN14Thick
			render
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
				1="fill(x0+1,y0+1,x1-1,y1-1,GoldLabelColor)"
			}
		}
		
		PageButton:hover:selected
		{			
			font=DIN14Thick
			render
			{
				0="fill(x0,y0,x1,y1,GoldLabelColor)"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		
		place { region=Everything margin=4 Control=TopCellBackground }
		
		place { region=Everything margin=6 Control=SelectedItem }
		
		place { region=Everything start=SelectedItem dir=right margin-left=2 Control=ItemName }
		place { region=Everything start=SelectedItem dir=right margin-left=2 margin-top=13 spacing=4 Control=CostImage,ItemCost,CompleteItemCost }
		
		//place { region=Everything start=CostImage dir=right margin-left=4 margin-top=2 Control=ItemCost }
		
		// Page Buttons
		place { region=Everything start=SelectedItem align=right spacing=3 dir=right margin-right=10 margin-top=2 Control=PageButton1,PageButton2,PageButton3 }
		
		place { region=Everything align=right margin-right=4 margin-top=4 spacing=2 Control=QuickBuyButton }		
			
		place { region=Everything start=SelectedItem dir=down margin-top=6 margin-left=2 spacing=4 Controls=description,variables,CooldownImage }
		place { start=CooldownImage dir=right Control=Cooldown,ManaImage,ManaCost }
		
		region { name=Buttons x=0 y=170 height=32 width=max }
		place { region=Buttons align=bottom margin-left=4 margin-bottom=4 spacing=10 Controls=QuickBuyButton,PurchaseButton }
		place { region=Buttons start=QuickBuyButton margin-left=10 Controls=UpgradeButton }
		place { region=Buttons start=QuickBuyButton margin-left=10 Controls=CompleteItemButton }
		
		region { name=CombinePanel x=0 y=202 height=190 width=max }
		place { region=CombinePanel margin=4 margin-left=4 Control=CombinePanel }
		
	}
}
