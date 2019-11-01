"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" )
}

function OnSell()
{
	Items.LocalPlayerSellItem( $.GetContextPanel().data().Item );
	DismissMenu();
}

function OnDisassemble()
{
	Items.LocalPlayerDisassembleItem( $.GetContextPanel().data().Item );
	DismissMenu();
}

function OnShowInShop()
{
	var itemName = Abilities.GetAbilityName( $.GetContextPanel().data().Item );
	
	var itemClickedEvent = {
		"link": ( "dota.item." + itemName ),
		"shop": 0,
		"recipe": 0
	};
	GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
	DismissMenu();
}

function OnDropFromStash()
{
	Items.LocalPlayerDropItemFromStash( $.GetContextPanel().data().Item );
	DismissMenu();
}

function OnMoveToStash()
{
	Items.LocalPlayerMoveItemToStash( $.GetContextPanel().data().Item );
	DismissMenu();
}

function OnAlert()
{
	Items.LocalPlayerItemAlertAllies( $.GetContextPanel().data().Item );
	DismissMenu();
}
