"Resource/UI/HUD_Shop_Item_Details.res"
{
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
	}
	
	"CostImage"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"CostImage"
		"wide"			"16"
		"tall"			"16"
		"scaleImage"	"1"
		"image"			"materials/vgui/hud/gold.vmat"
		"minimum-width"	"16"
		"minimum-height""16"
		"group"			"NonRecipeControls"
	}
	
	"ItemCost"
	{
		"ControlName"	"Label"
		"fieldName"		"ItemCost"
		"zpos"			"1"
		"wide"			"200"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"		"%itemcost%"
		"textAlignment"	"west"
		"style"			"ItemCost"
		"group"			"NonRecipeControls"
	}
	
	"PageButton1"
	{
		"ControlName"		"Button"
		"fieldName"			"PageButton1"
		"zpos"				"1"
		"wide"				"13"
		"tall"				"13"
		"minimum-width"		"13"
		"minumum-height"	"13"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page1"
		"style"				"PageButton"
		"labeltext"			" "	
	}
	
	"PageButton2"
	{
		"ControlName"		"Button"
		"fieldName"			"PageButton2"
		"zpos"				"1"
		"wide"				"13"
		"tall"				"13"
		"minimum-width"		"13"
		"minumum-height"	"13"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page2"
		"style"				"PageButton"	
		"labeltext"			" "	
	}
	
	"PageButton3"
	{
		"ControlName"		"Button"
		"fieldName"			"PageButton3"
		"zpos"				"1"
		"wide"				"13"
		"tall"				"13"
		"minimum-width"		"13"
		"minumum-height"	"13"
		"visible"			"1"
		"enabled"			"1"
		"command"			"page3"
		"style"				"PageButton"
		"labeltext"			" "		
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
		"fieldName"		"variables"
		"font" 			"Arial12Thick"
		"xpos"			"-5"
		"ypos"			"5"
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
	
	"CompleteItem"
	{
		"ControlName"		"Button"
		"fieldName"			"CompleteItem"
		"zpos"				"3"
		"wide"				"110"
		"tall"				"13"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"completeitem"
		"labeltext"			"Complete Item"		
		"style"				"BuyButton"
		//"minimum-width"		"110"
		"minimum-height"	"13"
		"mouseinputenabled"	"1"
	}
		
	"SetQuickBuyButton"
	{
		"ControlName"		"Button"
		"fieldName"			"SetQuickBuyButton"
		"zpos"				"3"
		"wide"				"25"
		"tall"				"25"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"command"			"togglequickbuy"
		"labeltext"			""		
		"style"				"LockQuickBuy"
		"minimum-width"		"25"
		"minimum-height"	"25"
		"mouseinputenabled"	"1"
	}
	
	"RequirementsBackground"
	{
		"ControlName"	"Panel"
		"fieldName"		"RequirementsBackground"
		"font" 			"DIN10Fine"
		"zpos"			"2"
		"wide"			"192"
		"minimum-width"		"192"
		"tall"			"36"
		"visible"		"1"
		"group"				"RecipeControls"
		"style"			"RequirementsBackground"
	}
	
	"RequirementsLabel"
	{
		"ControlName"	"Label"
		"fieldName"		"RequirementsLabel"
		"font" 			"DIN10Fine"
		"zpos"			"3"
		"wide"			"235"
		"tall"			"15"
		"enabled"		"1"
		"visible"		"1"
		"labeltext"			"#DOTA_SHOP_REQUIREMENTS"
		"textAlignment"		"west"
		"fgColor_override" 	"119 119 119 255"
		"bgcolor_override"	"51 51 51 0"
		"scrollbar"		"false"
		"auto_wide_tocontents" 	"1"
		"group"				"RecipeControls"
		"minimum-width"		"230"
	}
		
	"PreReqButton1"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton1"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}
		
	"PreReqButton2"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton2"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}	
	
	"PreReqButton3"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton3"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}	
		
	"PreReqButton4"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton4"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}	
	
	"PreReqButton5"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton5"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}
	
	"PreReqButton6"
	{
		"ControlName"		"CShopItemPanel"
		"fieldName"			"PreReqButton6"
		"zpos"				"3"
		"wide"				"36"
		"tall"				"26"
		"visible"			"1"
		"enabled"			"1"
	}	
	
	"BackButton"
	{
		"ControlName"		"Button"
		"fieldName"			"BackButton"
		"font" 				"DIN12Thick"
		"xpos"				"0"
		"ypos"				"153"
		"zpos"				"3"
		"wide"				"100"
		"tall"				"15"
		"visible"			"0"
		"enabled"			"1"
		"textAlignment"		"west"
		"command"			"back"
		"labeltext"			"#dota_item_panel_back_short"
		"style"				"BackButton"	
	}
	
	colors
	{
		BuyButtonTextActive="0 0 0 255"
		BuyButtonTextDisabled="160 160 160 255"
		BuyButtonActive="252 176 64 255"
		BuyButtonDisabled="70 70 70 255"
		RequirementsBackground="65 65 65 255"
	}
	
	styles
	{		
		BuyButton
		{
			textcolor=black
			font=DIN12Thick
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 7, BuyButtonActive )"
			}
		}
		
		BuyButton:disabled
		{
			textcolor=BuyButtonTextDisabled
			font=DIN12Thick
			render_bg
			{
				0="roundedfill( x0, y0, x1, y1, 7, BuyButtonDisabled )"
			}
		}	
		
		BackButton
		{
			font=DIN12Thick
			textcolor=white
			bgcolor=none	
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
			font=DIN12Thick
			bgcolor=none
		}
		
		ItemCost
		{
			textcolor=GoldLabelColor
			font=DIN12Thick
		}
		
		PageButton
		{
			font=DefaultVeryTiny
			render
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
			}
		}
		
		PageButton:hover
		{			
			font=DefaultVeryTiny
			render
			{
				1="fill(x0,y0,x1,y1,GoldLabelColor)"
				0="fill(x0+1,y0+1,x1-1,y1-1,LighterGrey)"
			}
		}	
		
		PageButton:selected
		{			
			font=DefaultVeryTiny
			render
			{
				0="fill(x0,y0,x1,y1,LighterGrey)"
				1="fill(x0+1,y0+1,x1-1,y1-1,GoldLabelColor)"
			}
		}
		
		PageButton:hover:selected
		{			
			font=DefaultVeryTiny
			render
			{
				0="fill(x0,y0,x1,y1,GoldLabelColor)"
			}
		}
		
		LockQuickBuy
		{
			render
			{
				0="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/lockquickbuy.vmat )"
			}
		}
		
		LockQuickBuy:selected
		{
			render
			{
				0="fill( x0, y0, x1, y1, white )"
				1="image_scale( x0, y0, x1, y1, materials/vgui/hud/shop/lockquickbuy.vmat )"
			}
		}
			
		RequirementsBackground
		{
			render
			{
				0="fill( x0, y0, x1, y1, RequirementsBackground )"
			}
		}
	}
	
	layout
	{
		region { name=Everything x=0 y=0 height=max width=max }
		place { region=Everything margin=4 Control=SelectedItem }
		
		place { region=Everything start=SelectedItem dir=right margin-left=2 margin-top=2 Control=ItemName }
		place { region=Everything start=ItemName dir=down margin-left=2 margin-top=3 Control=CostImage }
		place { region=Everything start=CostImage dir=right margin-left=4 margin-top=2 Control=ItemCost }
		place { region=Everything start=CostImage dir=right margin-left=4 margin-top=2 Control=PageButton1 }
		
		place { region=Everything align=right margin-right=4 margin-top=4 spacing=2 Control=SetQuickBuyButton }
		place { region=Everything start=CostImage align=right margin-right=4 margin-top=2 spacing=2 Control=CompleteItem }
		
		place { region=Everything start=PageButton1 dir=right margin-left=2 spacing=2 Control=PageButton2,PageButton3 }
		
		region { name=Requirements x=0 y=127 height=50 width=max }
		place { region=Requirements Control=RequirementsBackground }
		place { region=Requirements margin-left=2 Control=RequirementsLabel }
		place { region=Requirements margin-left=2 margin-top=10 dir=right spacing=2 Control=PreReqButton1,PreReqButton2,PreReqButton3,PreReqButton4,PreReqButton5,PreReqButton6 }
				
		place { region=Everything start=SelectedItem dir=down margin-top=6 margin-left=2 spacing=4 Controls=description,variables,CooldownImage }
		
		place { start=CooldownImage dir=right Control=Cooldown,ManaImage,ManaCost }
	}
}
