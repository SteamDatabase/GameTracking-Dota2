/* Called from C++ Code */
function OnRelicProgressShown( panelId, primaryAttribute, bRare )
{
    var panel = $.GetContextPanel().FindChildInLayoutFile(panelId);
    panel.AddClass("GemNotReady");

    var relicFXPanel = panel.FindChildInLayoutFile('RelicFXPanel');
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', relicFXPanel, function ()
    {
        if (bRare)
        {
            relicFXPanel.FireEntityInput('hero_relic_gem_gold_fx', 'Start', '');
        }
        else if (primaryAttribute == 0)
        {
            relicFXPanel.FireEntityInput('hero_relic_gem_red_fx', 'Start', '');
        }
        else if (primaryAttribute == 1)
        {
            relicFXPanel.FireEntityInput('hero_relic_gem_green_fx', 'Start', '');
        }
        else if (primaryAttribute == 2)
        {
            relicFXPanel.FireEntityInput('hero_relic_gem_blue_fx', 'Start', '');
        }
        panel.RemoveClass("GemNotReady");
    });

    var relicFXFullPanel = panel.FindChildInLayoutFile('RelicFXFullPanel');
    $.RegisterEventHandler('DOTAScenePanelSceneLoaded', relicFXFullPanel, function () {
        if (bRare) {
            relicFXFullPanel.FireEntityInput('hero_relic_separator_gold_fx', 'Start', '');
            relicFXFullPanel.FireEntityInput('hero_relic_burst_rare_fx', 'Start', '');
        }
        else {
            relicFXFullPanel.FireEntityInput('hero_relic_separator_fx', 'Start', '');
            relicFXFullPanel.FireEntityInput('hero_relic_burst_fx', 'Start', '');
        }
    });
}
