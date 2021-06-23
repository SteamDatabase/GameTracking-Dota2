// -------------------------------------------------------

var DOTA_TEAM_GOODGUYS = 2;
var DOTA_TEAM_BADGUYS = 3;

var TOWER_OVERLAY_TOP_PADDING = -40;
var TOWER_OVERLAY_LEFT_PADDING = -50;
var TOWER_OVERLAY_WIDTH = 520;
var TOWER_OVERLAY_HEIGHT = 500;


var testData = {
	towers: [
		{ "team": 3, "time_destroyed": 325, "position_pct_x": 43.6, "position_pct_y": 36.0 },
		{ "team": 3, "time_destroyed": 533, "position_pct_x": 26.0, "position_pct_y": 16.4 },
		{ "team": 2, "time_destroyed": 541, "position_pct_x": 29.2, "position_pct_y": 69.2 },
		{ "team": 2, "time_destroyed": 866, "position_pct_x": 56.4, "position_pct_y": 64.0 },
		{ "team": 3, "time_destroyed": 941, "position_pct_x": 88.4, "position_pct_y": 50.0 },
		{ "team": 2, "time_destroyed": 1219, "position_pct_x": 11.6, "position_pct_y": 50.0 },
		{ "team": 3, "time_destroyed": 1652, "position_pct_x": 70.8, "position_pct_y": 30.8 },
		{ "team": 2, "time_destroyed": -1, "position_pct_x": 74.0, "position_pct_y": 83.6 }
	]
};

// -------------------------------------------------------

function PlaySoundIfVisibleAction( soundName )
{
	this.soundName = soundName;
}

PlaySoundIfVisibleAction.prototype = new BaseAction();

PlaySoundIfVisibleAction.prototype.update = function ()
{
	var findDetailsOverviewPanel = $.GetContextPanel();
	for ( var i = 0; i < 10; i++ )
	{
		if ( findDetailsOverviewPanel.id == "DetailsOverview" )
			break;
		findDetailsOverviewPanel = findDetailsOverviewPanel.GetParent();
	}
	if ( findDetailsOverviewPanel.BHasClass( "TabSelected" ) )
		PlayUISoundScript( this.soundName );
	return false;
}

// -------------------------------------------------------

function AnimateTowerSurvival( panelName )
{
	this.panelName = panelName;
}

AnimateTowerSurvival.prototype = new BaseAction();

AnimateTowerSurvival.prototype.init = function ( towerPanel )
{
	var fxPanel = towerPanel.FindChildInLayoutFile( "SurvivingTowerFX" );

	this.seq = new RunSequentialActions();

	this.seq.actions.push( new WaitForClassAction( fxPanel, "SceneLoaded" ) );
	this.seq.actions.push( new RunFunctionAction( function ()
	{
		fxPanel.SetControlPoint( 15, 0x30, 0x5F, 0x7F );
		fxPanel.StartParticles();
	} ) );

	this.seq.start();
}

AnimateTowerSurvival.prototype.start = function ()
{
	var towerSurvivalPanel = $.GetContextPanel().FindPanelInLayoutFile( this.panelName );

	this.init( towerSurvivalPanel );
}

AnimateTowerSurvival.prototype.update = function ()
{
	return this.seq.update();
}

AnimateTowerSurvival.prototype.finish = function ()
{
	this.seq.finish();
}


// -------------------------------------------------------

function AnimateTowerDestroyed( panelName )
{
	this.panelName = panelName;
}

AnimateTowerDestroyed.prototype = new BaseAction();

AnimateTowerDestroyed.prototype.init = function( towerPanel )
{
	var fxPanel = towerPanel.FindChildInLayoutFile( "DestroyTowerFX" );

	this.seq = new RunSequentialActions();

	var destroySound = "Building_Generic.PartialDestruction";

	if ( fxPanel )
		this.seq.actions.push( new WaitForClassAction( fxPanel, "SceneLoaded" ) );
	this.seq.actions.push( new PlaySoundIfVisibleAction( destroySound ) );
	this.seq.actions.push( new WaitAction( 0.05 ) );
	if ( fxPanel )
		this.seq.actions.push( new RunFunctionAction( function () { 
			fxPanel.SetControlPoint( 15, 0xFF, 0xFF, 0xA0 );
			fxPanel.StartParticles(); 
		} ) );
	this.seq.actions.push( new WaitAction( 0.1 ) );  // let the particle system play briefly before showing the number
	this.seq.actions.push( new AddClassAction( towerPanel, "FXCompleted" ) );

	this.seq.start();

}

AnimateTowerDestroyed.prototype.start = function ()
{
	var towerDestroyedPanel = $.GetContextPanel().FindPanelInLayoutFile( this.panelName );

	this.init( towerDestroyedPanel );
}

AnimateTowerDestroyed.prototype.update = function ()
{
	return this.seq.update();
}

AnimateTowerDestroyed.prototype.finish = function ()
{
	this.seq.finish();
}

// -------------------------------------------------------

// called from c++
function InitNemesticeTowerReplay( towersData )
{
	if ( typeof towersData === 'object' && towersData !== null && Array.isArray( towersData.towers ) )
	{
		var vTowersArray = towersData.towers;
		var minimapOverlay = $.GetContextPanel().FindPanelInLayoutFile( "NemesticeTowerReplayOverlay" );
		minimapOverlay.RemoveClass( "FadeOff" );
		minimapOverlay.RemoveAndDeleteChildren();
		var seq = new RunSequentialActions();
		seq.actions.push( new WaitAction( 0.5 ) ); // extra delay before first tower

		// create all the towers, some which will be destroyed
		vTowerPanels = []
		vTowersArray.forEach( function ( towerData, index )
		{
			var towerDestructionPanel = null;

			if ( towerData.team != DOTA_TEAM_GOODGUYS && towerData.team != DOTA_TEAM_BADGUYS )
				return;

			var towerPanelName = "Tower" + index;
			var towerPanel = $.CreatePanel( "Panel", minimapOverlay, towerPanelName );
			towerPanel.AddClass( "Tower" );
			if ( towerData.team == DOTA_TEAM_GOODGUYS )
				towerPanel.AddClass( "Radiant" );
			else
				towerPanel.AddClass( "Dire" );
			var xPos = TOWER_OVERLAY_LEFT_PADDING + TOWER_OVERLAY_WIDTH * towerData.position_pct_x / 100.0;
			var yPos = TOWER_OVERLAY_TOP_PADDING + TOWER_OVERLAY_HEIGHT * towerData.position_pct_y / 100.0;
			towerPanel.SetPositionInPixels( xPos, yPos, 0 );

			var towerAlivePanel = $.CreatePanel( "Panel", towerPanel, "TowerAlive" );
			towerAlivePanel.BLoadLayoutSnippet( "TowerAlive" );

			if ( towerData.time_destroyed >= 0 )
			{
				towerDestructionPanel = $.CreatePanel( "Panel", towerPanel, "TowerDestroyed" );
				towerDestructionPanel.BLoadLayoutSnippet( "TowerDestruction" );
				towerDestructionPanel.SetDialogVariableTime( "time_destroyed", towerData.time_destroyed );
				var heroContainer = towerDestructionPanel.FindChildInLayoutFile( "TowerHero" );
				if ( heroContainer != null )
				{
					var killIcon = heroContainer.FindChildInLayoutFile( "HeroKillIcon" );
					if ( killIcon != null )
					{
						var bHasHero = towerData.heroname.startsWith( "npc_dota_hero_" );
						if ( bHasHero )
						{
							var heroname = towerData.heroname.substring( 14 );
							killIcon.heroname = heroname;
						}
						else heroContainer.AddClass( "Hidden" );
					}
				}
				var bIsFinalDestruction = ( index + 1 < vTowersArray.length && vTowersArray[ index + 1 ].time_destroyed < 0 )

				seq.actions.push( new WaitAction( 0.35 ) ); // delay between towers
				seq.actions.push( new AnimateTowerDestroyed( towerPanelName ) );
				if ( bIsFinalDestruction )
				{
					seq.actions.push( new WaitAction( 1.0 ) ); // extra delay after final destruction before showing surviving

					// make sound for the actual winners
					var victorySound = "Nemestice.Victory";
					seq.actions.push( new PlaySoundIfVisibleAction( victorySound ) );
					seq.actions.push( new WaitAction( 0.05 ) );
				}
			}
			else
			{
				seq.actions.push( new AnimateTowerSurvival( towerPanelName ) );
			}
		} );

		seq.actions.push( new WaitAction( 5.28 ) );
		seq.actions.push( new AddClassAction( minimapOverlay, "FadeOff" ) );

		RunSingleAction( seq );
	}
}