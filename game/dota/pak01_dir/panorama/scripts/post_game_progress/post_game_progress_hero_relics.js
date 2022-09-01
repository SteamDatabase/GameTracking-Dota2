
const DOTA_ATTRIBUTE_STRENGTH = 0;
const DOTA_ATTRIBUTE_AGILITY = 1;
const DOTA_ATTRIBUTE_INTELLECT = 2;

const HERO_RELIC_RARITY_COMMON = 0;
const HERO_RELIC_RARITY_RARE = 1;


class AnimateHeroRelicProgressAction extends RunSequentialActions
{
	constructor( data, containerPanel )
	{
		super();
		this.data = data;
		this.containerPanel = containerPanel;
	}

	start()
	{
		var nValuePerLevel = this.data.value_per_level ? this.data.value_per_level : 1;
		var nCurrentLevel = Math.floor( this.data.starting_value / nValuePerLevel );

		this.panel = $.CreatePanel( 'Panel', this.containerPanel, '' );
		this.panel.BLoadLayoutSnippet( 'SingleRelicProgress' );
		this.panel.SetDialogVariableInt( 'relic_type', this.data.relic_type );
		this.panel.SetDialogVariableInt( 'current_progress', this.data.starting_value );
		this.panel.SetDialogVariableInt( 'increment', this.data.ending_value - this.data.starting_value );
		this.panel.SetDialogVariable( 'relic_level', nCurrentLevel > 0 ? nCurrentLevel.toString() : "-" );

		switch ( this.data.primary_attribute )
		{
			case DOTA_ATTRIBUTE_STRENGTH: this.panel.AddClass( "PrimaryAttributeStrength" ); break;
			case DOTA_ATTRIBUTE_AGILITY: this.panel.AddClass( "PrimaryAttributeAgility" ); break;
			case DOTA_ATTRIBUTE_INTELLECT: this.panel.AddClass( "PrimaryAttributeIntellect" ); break;
		}

		this.panel.SetHasClass( "RareRelic", this.data.relic_rarity == HERO_RELIC_RARITY_RARE );

		var relicImage = this.panel.FindChildInLayoutFile( "SingleRelicImage" );
		relicImage.SetRelic( this.data.relic_type, this.data.relic_rarity, this.data.primary_attribute, false );

		this.actions.push( new AddClassAction( this.panel, 'ShowProgress' ) );
		this.actions.push( new WaitAction( 0.1 ) );
		this.actions.push( new AddClassAction( this.panel, 'ShowIncrement' ) );

		var progressBar = this.panel.FindChildInLayoutFile( 'SingleRelicProgressBar' );
		progressBar.max = nValuePerLevel;

		var nCurrentValue = this.data.starting_value;
		var nCurrentLevelValue = this.data.starting_value % nValuePerLevel;
		progressBar.value = nCurrentLevelValue;

		var levelUpLabel = this.panel.FindChildInLayoutFile( 'SingleRelicLevelUpLabel' );

		while ( nCurrentValue < this.data.ending_value )
		{
			var nRemainingProgress = this.data.ending_value - nCurrentValue;

			nCurrentLevel = Math.floor( nCurrentValue / nValuePerLevel );
			var nNextLevelValue = ( nCurrentLevel + 1 ) * nValuePerLevel;
			var nValueToNextLevel = nNextLevelValue - nCurrentValue;

			if ( nValueToNextLevel <= nRemainingProgress )
			{
				this.actions.push( new AnimateProgressBarAction( progressBar, nCurrentLevelValue, nValuePerLevel, 0.3 ) );
				this.actions.push( new TriggerClassAction( levelUpLabel, 'ShowLevelUp' ) );
				this.actions.push( new SetDialogVariableStringAction( this.panel, 'relic_level', ( nCurrentLevel + 1 ).toString() ) );
				this.actions.push( new WaitAction( 0.5 ) );
				this.actions.push( new RunFunctionAction( function()
				{
					progressBar.value = 0;
				} ) );

				nCurrentValue += nValueToNextLevel;
				nCurrentLevelValue = 0;
			}
			else
			{
				this.actions.push( new AnimateProgressBarAction( progressBar, nCurrentLevelValue, this.data.ending_value % nValuePerLevel, 0.3 ) );

				nCurrentValue = this.data.ending_value;
				nCurrentLevelValue = nCurrentValue % nValuePerLevel;
			}
		}

		super.start();
	}
}


class AnimateHeroRelicsScreenAction extends RunSequentialActions
{
	constructor( data )
	{
		super();
		this.data = data;
	}

	start()
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
		this.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
		this.actions.push( new ActionWithTimeout( new WaitForClassAction( heroModel, 'SceneLoaded' ), 3.0 ) );
		this.actions.push( new WaitAction( 0.5 ) );

		this.actions.push( new StopSkippingAheadAction() );
		this.actions.push( new AddScreenLinkAction( panel, 'HeroRelicsProgress', '#DOTA_PlusPostGame_RelicsProgress' ) );

		this.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowRelicsProgress' ) );
		this.actions.push( new WaitAction( 0.5 ) );
		var stagger = new RunStaggeredActions( 0.10 );
		this.actions.push( new SkippableAction( stagger ) );
		var relicsList = panel.FindChildInLayoutFile( "HeroRelicsProgressList" );

		var relicsProgress = this.data.hero_relics_progress;
		for ( var i = 0; i < relicsProgress.length; ++i )
		{
			stagger.actions.push( new AnimateHeroRelicProgressAction( relicsProgress[i], relicsList ) );
		}

		this.actions.push( new StopSkippingAheadAction() );
		this.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );

		super.start();
	}
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
					relic_rarity: HERO_RELIC_RARITY_RARE,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 1,
					relic_rarity: HERO_RELIC_RARITY_RARE,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 30,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 2,
					relic_rarity: HERO_RELIC_RARITY_RARE,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 3,
					relic_rarity: HERO_RELIC_RARITY_RARE,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 4,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 5,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 6,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 7,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 8,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 56,
					value_per_level: 10,
					xp_per_level: 5,
				},
				{
					relic_type: 9,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 30,
					xp_per_level: 15,
				},
				{
					relic_type: 10,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 10,
					xp_per_level: 5,
				},
				{
					relic_type: 11,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 10,
					xp_per_level: 5,
				},
				{
					relic_type: 12,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 125,
					ending_value: 129,
					value_per_level: 10,
					xp_per_level: 5,
				},
				{
					relic_type: 13,
					relic_rarity: HERO_RELIC_RARITY_COMMON,
					primary_attribute: DOTA_ATTRIBUTE_AGILITY,
					starting_value: 25,
					ending_value: 29,
					value_per_level: 10,
					xp_per_level: 5,
				}
			]

	};

	TestProgressAnimation( data );
}
