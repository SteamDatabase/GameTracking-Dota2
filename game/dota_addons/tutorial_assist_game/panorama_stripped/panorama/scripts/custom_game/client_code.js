"use strict";

function OnAbilityStartUse(nAbilityID) {
    var data = { ability_id: nAbilityID };
    GameEvents.SendCustomGameEventToServer("AbilityStartUse", data);
}

function OnAbilityLearnModeToggled(bEnabled) {
    var data = { enabled: bEnabled };
    GameEvents.SendCustomGameEventToServer("AbilityLearnModeToggled", data);
}

function OnPurchaseFailedNeedSecretShop(nPlayerID) {
    var data = { player_id: nPlayerID };
    GameEvents.SendCustomGameEventToServer("PurchaseFailedNeedSecretShop", data);
}

function OnPlayerShopChanged(nPlayerID, nShopMask) {
    var data = { player_id: nPlayerID, shop_mask: nShopMask };
    GameEvents.SendCustomGameEventToServer("PlayerShopChanged", data);
}

(function ()
{
    $.RegisterForUnhandledEvent("DOTAAbility_StartUse", OnAbilityStartUse);
    $.RegisterForUnhandledEvent("DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);
    $.RegisterForUnhandledEvent("DOTAHUDError_NeedSecretShop", OnPurchaseFailedNeedSecretShop);
    $.RegisterForUnhandledEvent("DOTAHUD_PlayerShopChanged", OnPlayerShopChanged);
})();
