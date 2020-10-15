


function AnimateHeroRelicProgressAction( data, containerPanel )
{
	this.data = data;
	this.containerPanel = containerPanel;
}
AnimateHeroRelicProgressAction.prototype = new BaseAction();
AnimateHeroRelicProgressAction.prototype.start = function ()
{
	this.panel = $.CreatePanel( 'Panel', this.containerPanel, '' );
	this.panel.BLoadLayoutSnippet( 'SingleRelicProgress' );
	this.panel.SetDialogVariableInt( 'relic_type', this.data.relic_type );
	this.panel.SetDialogVariableInt( 'current_progress', this.data.starting_value );
	this.panel.SetDialogVariableInt( 'increment', this.data.ending_value - this.data.starting_value );

	var relicImage = this.panel.FindChildInLayoutFile( "SingleRelicImage" );
	relicImage.SetRelic( this.data.relic_type, this.data.relic_rarity, this.data.primary_attribute, false );

	this.seq = new RunSequentialActions();

	this.seq.actions.push( new AddClassAction( this.panel, 'ShowProgress' ) );
	this.seq.actions.push( new WaitAction( 0.1 ) );
	this.seq.actions.push( new AddClassAction( this.panel, 'ShowIncrement' ) );
	this.seq.actions.push( new WaitAction( 0.3 ) );


	return this.seq.start();
}
AnimateHeroRelicProgressAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroRelicProgressAction.prototype.finish = function ()
{
	this.seq.finish();
}


function AnimateHeroRelicsScreenAction( data )
{
	this.data = data;
}

AnimateHeroRelicsScreenAction.prototype = new BaseAction();
AnimateHeroRelicsScreenAction.prototype.start = function ()
{
	// Create the screen and do a bunch of initial setup
	var panel = StartNewScreen( 'HeroRelicsProgressScreen' );
	panel.BLoadLayoutSnippet( "HeroRelicsProgress" );

	var heroModel = panel.FindChildInLayoutFile( 'HeroRelicsHeroModel' );
	if ( typeof this.data.player_slot !== 'undefined' )
	{
		// Use this normally when viewing the details
		heroModel.SetScenePanelToPlayerHero( this.data.match_id, this.data.player_slot );
	}
	else
	{
		// Use this for testing when we don't actually have match data
		heroModel.SetScenePanelToLocalHero( this.data.hero_id );
	}

	// Setup the sequence of actions to animate the screen
	this.seq = new RunSequentialActions();
	this.seq.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
	this.seq.actions.push( new ActionWithTimeout( new WaitForClassAction( heroModel, 'SceneLoaded' ), 3.0 ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new AddScreenLinkAction( panel, 'HeroRelicsProgress', '#DOTA_PlusPostGame_RelicsProgress' ) );

	this.seq.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowRelicsProgress' ) );
	this.seq.actions.push( new WaitAction( 0.5 ) );
	var stagger = new RunStaggeredActions( 0.10 );
	this.seq.actions.push( new SkippableAction( stagger ) );
	var relicsList = panel.FindChildInLayoutFile( "HeroRelicsProgressList" );

	var relicsProgress = this.data.hero_relics_progress;
	for ( var i = 0; i < relicsProgress.length; ++i )
	{
		stagger.actions.push( new AnimateHeroRelicProgressAction( relicsProgress[i], relicsList ) )
	}

	this.seq.actions.push( new StopSkippingAheadAction() );
	this.seq.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

	this.seq.start();
}
AnimateHeroRelicsScreenAction.prototype.update = function ()
{
	return this.seq.update();
}
AnimateHeroRelicsScreenAction.prototype.finish = function ()
{
	this.seq.finish();
}


function TestAnimateHeroRelics()
{
    var data =
	{
	    hero_id: 11,

	    hero_relics_progress:
		[
			{
			    relic_type: 0,
			    relic_rarity: 1,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 1,
			    relic_rarity: 1,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 2,
			    relic_rarity: 1,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 3,
			    relic_rarity: 1,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 4,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 5,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 6,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 7,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 8,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 9,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 10,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 11,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 12,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			},
			{
			    relic_type: 13,
			    relic_rarity: 0,
			    primary_attribute: 1,
			    starting_value: 25,
			    ending_value: 29,
			}
		]

	};

	TestProgressAnimation( data );
}
