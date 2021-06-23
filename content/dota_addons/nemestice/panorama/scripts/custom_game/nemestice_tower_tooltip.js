$.Msg( "spring_tower_tooltip.js loaded" );

var UPGRADES = {
	tower_upgrade_spawn_kobolds: "Kobold",
	tower_upgrade_spawn_hellbears: "Hellbear",
	tower_upgrade_spawn_troll_priests: "Priest",
	tower_upgrade_tower_shrine: "Shrine",
	tower_upgrade_launch_mortar: "Mortar"
};

var contextPanel = $.GetContextPanel();
var idPanel = contextPanel.GetParent().GetParent();

contextPanel.SetDialogVariableLocString( "tower_name", idPanel.id );

var player = Players.GetLocalPlayer();
var playerTeam = Players.GetTeam( player ) === DOTATeam_t.DOTA_TEAM_BADGUYS ? DOTATeam_t.DOTA_TEAM_BADGUYS : DOTATeam_t.DOTA_TEAM_GOODGUYS;

function OnMapStateChanged() // notification of change to mapStateTowers from nemestice_shared.js
{
    var tower = mapStateTowers[idPanel.id];
    var towerTeam = Entities.GetTeamNumber( tower.entindex );

    contextPanel.SetHasClass( "OutpostDestroyed", towerTeam == DOTATeam_t.DOTA_TEAM_CUSTOM_1 );
    contextPanel.SetHasClass( "Ally", towerTeam !== DOTATeam_t.DOTA_TEAM_CUSTOM_1 && towerTeam === playerTeam );
    contextPanel.SetHasClass( "Enemy", towerTeam !== DOTATeam_t.DOTA_TEAM_CUSTOM_1 && towerTeam !== playerTeam );
    
    Object.keys( UPGRADES ).forEach( ( upgradeName ) => {
        var upgradeId = UPGRADES[ upgradeName ];
        var upgradePanel = contextPanel.FindChildTraverse( upgradeId );
        var upgradeLevel = tower.upgrades[upgradeName] || 0;
        upgradePanel.SetDialogVariableInt( "level", upgradeLevel );
        upgradePanel.SetHasClass( "Zero", upgradeLevel === 0 );
    });
}
OnMapStateChanged();

var healthPanel = contextPanel.FindChildTraverse( "TowerHealthPercent" );
function UpdateHealth()
{
    var tower = mapStateTowers[idPanel.id];
    var towerHP = Entities.GetTeamNumber( tower.entindex ) == DOTATeam_t.DOTA_TEAM_CUSTOM_1 ? 0 : ( Entities.GetHealthPercent( tower.entindex ) || 0 );
    healthPanel.style.width = `${ towerHP }%`;
    $.Schedule( 0.2, UpdateHealth );
}
UpdateHealth();
