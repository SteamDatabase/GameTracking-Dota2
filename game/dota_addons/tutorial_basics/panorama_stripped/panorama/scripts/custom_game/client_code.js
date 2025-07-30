"use strict";

function OnAbilityStartUse(nAbilityID) {
    var data = { ability_id: nAbilityID };
    GameEvents.SendCustomGameEventToServer("AbilityStartUse", data);
}

function OnAbilityLearnModeToggled(bEnabled) {
    var data = { enabled: bEnabled };
    GameEvents.SendCustomGameEventToServer("AbilityLearnModeToggled", data);
}

(function ()
{
    $.RegisterForUnhandledEvent("DOTAAbility_StartUse", OnAbilityStartUse);
    $.RegisterForUnhandledEvent("DOTAHUDAbilityLearnModeToggled", OnAbilityLearnModeToggled);
})();

( function Init()
{
    var hudPanel = $.GetContextPanel().FindAncestor( "Hud" );
    if ( hudPanel )
    {
        hudPanel.SetHasClass( "TutorialBasicsScenario", true )
    }
} )();