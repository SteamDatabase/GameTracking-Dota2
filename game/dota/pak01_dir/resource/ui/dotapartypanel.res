"Resource/UI/DOTAPartyPanel.res"
{
	controls
	{
		"DOTAPartyPanel"
		{
			"ControlName"		"EditablePanel"
			"fieldName" 		"DOTAPartyPanel"

			"ypos"			"242"
			"wide"	 		"512"
			"tall"	 		"80"
			"zpos"			"1"
			"PaintBackground"	"1"
			"PaintBackgroundType"	"0"
			"bgcolor_override" "255 58 58 64"
		}
		
		// members
		"PartyMember0" { Controlname=Panel fieldName=PartyMember0 wide=72 tall=72 zpos=3 bgcolor_override="0 0 0 0" }
		"PartyMember1" { Controlname=Panel fieldName=PartyMember1 wide=72 tall=72 zpos=3 bgcolor_override="0 0 0 0" }
		"PartyMember2" { Controlname=Panel fieldName=PartyMember2 wide=72 tall=72 zpos=3 bgcolor_override="0 0 0 0" }
		"PartyMember3" { Controlname=Panel fieldName=PartyMember3 wide=72 tall=72 zpos=3 bgcolor_override="0 0 0 0" }
		"PartyMember4" { Controlname=Panel fieldName=PartyMember4 wide=72 tall=72 zpos=3 bgcolor_override="0 0 0 0" }
		
		// backgrounds	
		"PartySlotBackground0" { Controlname=Panel fieldName=PartySlotBackground0 zpos=2 wide=64 tall=64 style=PartySlotStyle mouseInputEnabled=0 }
		"PartySlotBackground1" { Controlname=Panel fieldName=PartySlotBackground1 zpos=2 wide=64 tall=64 style=PartySlotStyle mouseInputEnabled=0 }
		"PartySlotBackground2" { Controlname=Panel fieldName=PartySlotBackground2 zpos=2 wide=64 tall=64 style=PartySlotStyle mouseInputEnabled=0 }
		"PartySlotBackground3" { Controlname=Panel fieldName=PartySlotBackground3 zpos=2 wide=64 tall=64 style=PartySlotStyle mouseInputEnabled=0 }
		"PartySlotBackground4" { Controlname=Panel fieldName=PartySlotBackground4 zpos=2 wide=64 tall=64 style=PartySlotStyle mouseInputEnabled=0 }
		
	}
	include="resource/UI/dashboard_style.res"
	
	colors
	{
		dullwhite="205 205 205 255"
		white="255 255 255 255"
	}
	
	styles
	{
		include="resource/UI/dashboard_style.res"		
	}	
	
	layout
	{
		
		region { name=PartySlotRegion x=72 y=1 width=400 }
		place { region=PartySlotRegion x=8 y=8 controls=PartySlotBackground0,PartySlotBackground1,PartySlotBackground2,PartySlotBackground3,PartySlotBackground4 dir=right spacing=8 }
		place { region=PartySlotRegion controls=PartyMember0,PartyMember1,PartyMember2,PartyMember3,PartyMember4 dir=right spacing=0 }
	}
}
