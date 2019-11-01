"use strict";

var m_BuffPanels = []; // created up to a high-water mark, but reused

function UpdateBuff( buffPanel, queryUnit, buffSerial )
{
	var noBuff = ( buffSerial == -1 );
	buffPanel.SetHasClass( "no_buff", noBuff );
	buffPanel.data().m_QueryUnit = queryUnit;
	buffPanel.data().m_BuffSerial = buffSerial;
	if ( noBuff )
	{
		return;
	}
	
	var nNumStacks = Buffs.GetStackCount( queryUnit, buffSerial );
	buffPanel.SetHasClass( "is_debuff", Buffs.IsDebuff( queryUnit, buffSerial ) );
	buffPanel.SetHasClass( "has_stacks", ( nNumStacks > 0 ) );

	var stackCount = buffPanel.FindChildInLayoutFile( "StackCount" );
	var itemImage = buffPanel.FindChildInLayoutFile( "ItemImage" );
	var abilityImage = buffPanel.FindChildInLayoutFile( "AbilityImage" );
	if ( stackCount )
	{
		stackCount.text = nNumStacks;
	}
	
	var buffTexture = Buffs.GetTexture( queryUnit, buffSerial );

	var itemIdx = buffTexture.indexOf( "item_" );
	if ( itemIdx === -1 )
	{
		if ( itemImage ) itemImage.itemname = "";
		if ( abilityImage ) abilityImage.abilityname = buffTexture;
		buffPanel.SetHasClass( "item_buff", false );
		buffPanel.SetHasClass( "ability_buff", true );
	}
	else
	{
		if ( itemImage ) itemImage.itemname = buffTexture;
		if ( abilityImage ) abilityImage.abilityname = "";
		buffPanel.SetHasClass( "item_buff", true );
		buffPanel.SetHasClass( "ability_buff", false );
	}
}

function UpdateBuffs()
{
	var buffsListPanel = $( "#buffs_list" );
	if ( !buffsListPanel )
		return;

	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	
	var nBuffs = Entities.GetNumBuffs( queryUnit );
	
	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < nBuffs; ++i )
	{
		var buffSerial = Entities.GetBuff( queryUnit, i );
		if ( buffSerial == -1 )
			continue;

		if ( Buffs.IsHidden( queryUnit, buffSerial ) )
			continue;
		
		if ( nUsedPanels >= m_BuffPanels.length )
		{
			// create a new panel
			var buffPanel = $.CreatePanel( "Panel", buffsListPanel, "" );
			buffPanel.BLoadLayout( "file://{resources}/layout/custom_game/buff_list_buff.xml", false, false );
			m_BuffPanels.push( buffPanel );
		}

		// update the panel for the current unit / buff
		var buffPanel = m_BuffPanels[ nUsedPanels ];
		UpdateBuff( buffPanel, queryUnit, buffSerial );
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_BuffPanels.length; ++i )
	{
		var buffPanel = m_BuffPanels[ i ];
		UpdateBuff( buffPanel, -1, -1 );
	}
}

function AutoUpdateBuffs()
{
	UpdateBuffs();
	$.Schedule( 0.1, AutoUpdateBuffs );
}

(function()
{
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateBuffs );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateBuffs );
	
	AutoUpdateBuffs(); // initial update of dynamic state
})();

