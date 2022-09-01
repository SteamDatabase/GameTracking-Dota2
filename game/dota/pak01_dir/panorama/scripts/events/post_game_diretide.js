function UpdateStackClasses( heroPanel, nStackSize )
{
	var stackPanel = heroPanel.FindChildInLayoutFile( 'CandyStack' );

	heroPanel.SetHasClass( 'MaxPointsHit', nStackSize >= 100 );

	if ( nStackSize > 90 )
	{
		stackPanel.SwitchClass( 'CandyStack', 'CandyStack05' );
	}
	else if ( nStackSize > 50 )
	{
		stackPanel.SwitchClass( 'CandyStack', 'CandyStack04' );
	}
	else if ( nStackSize > 25 )
	{
		stackPanel.SwitchClass( 'CandyStack', 'CandyStack03' );
	}
	else if ( nStackSize > 0 )
	{
		stackPanel.SwitchClass( 'CandyStack', 'CandyStack02' );
	}
	else
	{
		stackPanel.SwitchClass( 'CandyStack', 'CandyStack01' );
	}
}

function UpdateBucketClasses( heroPanel, nAmount )
{
	var bucketPanel = heroPanel.FindChildInLayoutFile( 'HeroBucket' );
	if ( nAmount > 5000 )
	{
		bucketPanel.AddClass( 'HeroBucket05' );
	}
	else if ( nAmount > 2000 )
	{
		bucketPanel.AddClass( 'HeroBucket04' );
	}
	else if ( nAmount > 1000 )
	{
		bucketPanel.AddClass( 'HeroBucket03' );
	}
	else if ( nAmount > 500 )
	{
		bucketPanel.AddClass( 'HeroBucket02' );
	}
	else
	{
		bucketPanel.AddClass( 'HeroBucket01' );
	}
}

function CreatePopuplateHeroScenesAction( data )
{
	var rootPanel = $.GetContextPanel();
	rootPanel.heroPanels = [];

	var vParallelContainer = new RunParallelActions();
	data.diretide_rewards_progress.match_players.forEach(
		function( playerData, idx )
		{

			var heroGroup = rootPanel.FindChildInLayoutFile( 'DiretideHeroGroup' );
			var teamName = idx < 5 ? 'Radiant' : 'Dire';
			var heroPanel = $.CreatePanel( 'Panel', heroGroup, 'DiretideHero_slot' + idx );
			heroPanel.BLoadLayoutSnippet( 'DiretideHeroEntry' );
			heroPanel.AddClass( teamName );
			rootPanel.heroPanels.push( heroPanel );
			heroPanel.playerSlot = playerData.player_slot;
			heroPanel.SetDialogVariable( 'player_name', playerData.player_name );
			heroPanel.SetDialogVariableInt( 'account_id', playerData.account_id );

			heroPanel.nEventPoints = ( playerData.event_points % 100 ) | 0;
			heroPanel.nTotalEventPoints = playerData.event_points;
			heroPanel.SetDialogVariableInt( 'event_points', heroPanel.nEventPoints );

			if ( data.player_slot === playerData.player_slot )
			{
				heroPanel.AddClass( 'LocalPlayer' );
			}


			var nStackSize = ( playerData.event_points % 100 ) | 0;
			UpdateStackClasses( heroPanel, nStackSize );
			UpdateBucketClasses( heroPanel, heroPanel.nTotalEventPoints );

			var scenePanel = heroPanel.FindChildInLayoutFile( "HeroScene" );
			heroPanel.scenePanel = scenePanel;

			var vSequence = new RunSequentialActions();
			vParallelContainer.actions.push( vSequence );
			vSequence.actions.push( new WaitForConditionAction( function()
			{
				if ( scenePanel.BAscendantHasClass( 'HasMetaData' ) && scenePanel.BAscendantHasClass( 'MatchDataLoaded' ) )
				{
					return true;
				}
				return false;
			} ) );
			vSequence.actions.push( new WaitForClassAction( scenePanel, 'SceneLoaded' ) );

			var playerSlot = playerData.player_slot;
			var matchID = data.diretide_rewards_progress.match_id;
			vSequence.actions.push( new RunFunctionAction( function()
			{
				scenePanel.SpawnHeroInScenePanelByPlayerSlotWithFullBodyView( matchID, playerSlot );
			} ) );
		}
	);
	return vParallelContainer;
}

// Action to animate an integer dialog variable over some duration of seconds
class AnimateCandyCountAction extends BaseAction
{
	constructor( panel, dialogVariable, start, end, seconds )
	{
		super();
		this.panel = panel;
		this.dialogVariable = dialogVariable;
		this.startValue = start;
		this.endValue = end;
		this.seconds = seconds;
	}

	start()
	{
		this.startTimestamp = Game.Time();
		this.endTimestamp = this.startTimestamp + this.seconds;
	}

	update()
	{
		var now = Game.Time();
		if ( now >= this.endTimestamp )
			return false;

		var ratio = ( now - this.startTimestamp ) / ( this.endTimestamp - this.startTimestamp );
		var amount = Math.floor( this.startValue + ( this.endValue - this.startValue ) * ratio );

		this.panel.SetDialogVariableInt( this.dialogVariable, amount );
		UpdateStackClasses( this.panel, amount );
		UpdateBucketClasses( this.panel, this.panel.nTotalEventPoints + amount );

		return true;
	};

	finish()
	{
		this.panel.SetDialogVariableInt( this.dialogVariable, this.endValue );
		this.panel.SetHasClass( 'MaxPointsHit', this.endValue >= 100 );
		this.panel.nTotalEventPoints = this.panel.nTotalEventPoints + ( this.endValue - this.startValue );
	};
}


function CreateAwardAction( awardData, rootPanel )
{
	var vSequence = new RunSequentialActions();

	var vKickerPanels = [];
	rootPanel.heroPanels.forEach( function( heroPanel )
	{
		var nIndex = awardData.award_player_slots.indexOf( heroPanel.playerSlot );
		if ( nIndex === -1 )
			return;

		vSequence.actions.push( new AddClassAction( heroPanel, 'HasKicker' ) );

		var fxPanel = heroPanel.FindChildInLayoutFile( 'BurstFX' );
		vSequence.actions.push( new AddClassAction( fxPanel, 'ShowExplosion' ) );
		vSequence.actions.push( new RunFunctionAction( function()
		{
			fxPanel.FireEntityInput( 'burst_fx', 'stop', 0 );
			fxPanel.FireEntityInput( 'burst_fx', 'start', 0 );
			fxPanel.FireEntityInput( 'base_fx', 'stop', 0 );
			fxPanel.FireEntityInput( 'base_fx', 'start', 0 );
		} ) );

		var newPanel = $.CreatePanel( 'Panel', heroPanel, '' );
		newPanel.BLoadLayoutSnippet( 'DiretideAwardKicker' );
		newPanel.SetDialogVariableLocString( 'award_name', awardData.award_name );
		newPanel.SetDialogVariableInt( 'award_amount', awardData.award_amounts[nIndex] );
		newPanel.SwitchClass( 'step', 'Start' );
		newPanel.nStartPointsValue = heroPanel.nEventPoints;
		newPanel.nEndPointsValue = heroPanel.nEventPoints + awardData.award_amounts[nIndex];
		heroPanel.nEventPoints = newPanel.nEndPointsValue;
		vKickerPanels.push( newPanel );
	} );

	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'Step1' ) );
	} );

	vSequence.actions.push( new PlaySoundAction( "Diretide.Postgame.Award" ) );

	var vParallelAction = new RunParallelActions();
	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'Step2' ) );
		vParallelAction.actions.push( new AnimateCandyCountAction( kicker.GetParent(), 'event_points', kicker.nStartPointsValue, kicker.nEndPointsValue, 0.4 ) );
	} );

	vParallelAction.actions.push( new WaitAction( 0.45 ) );
	vSequence.actions.push( vParallelAction );

	rootPanel.heroPanels.forEach( function( heroPanel )
	{
		var nIndex = awardData.award_player_slots.indexOf( heroPanel.playerSlot );
		if ( nIndex === -1 )
			return;
	} );

	vSequence.actions.push( new WaitAction( 0.75 ) );

	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new RemoveClassAction( kicker.GetParent(), 'HasKicker' ) );
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'End' ) );
	} );

	vSequence.actions.push( new WaitAction( 1.0 ) );

	return vSequence;
}

function GetItemCategory( itemData )
{
	switch ( itemData.item_id )
	{
		case 13562: //crate
		case 17626: //calabaxa
		case 17664: //diretide courier
		case 18371: //pumpkin head
		case 18380: //shader
		case 18372: //spooky courier
			return "Tier3Reward";
		case 18381: // Mega Kills
		case 18376: // Kill Streak
		case 18375: // Death Effect
		case 18367: // Costume pack 1
		case 18389: // Costume pack 2
		case 17661:	//Ward	
		case 13812:	//Treasure	
			return "Tier2Reward";
		default:
			return "Tier1Reward";
	}

	return "";
}


function GetItemTierNumber( itemData )
{
	switch ( itemData.item_id )
	{
		case 13562: //crate
		case 17626: //calabaxa
		case 17664: //diretide courier
		case 18371: //pumpkin head
		case 18380: //shader
		case 18372: //spooky courier
			return "3";
		case 18381: // Mega Kills
		case 18376: // Kill Streak
		case 18375: // Death Effect
		case 18367: // Costume pack 1
		case 18389: // Costume pack 2
		case 17661:	//Ward	
		case 13812:	//Treasure	
			return "2";
		default:
			return "1";
	}

	return "";
}

function CreateItemRewardAction( itemData, rootPanel )
{
	var vSequence = new RunSequentialActions();
	var fxPanel = [];
	var vKickerPanels = [];

	var strItemCategory = GetItemCategory( itemData );
	var strItemTierNumber = GetItemTierNumber( itemData );
	rootPanel.heroPanels.forEach( function( heroPanel )
	{
		if ( itemData.item_player_slot !== heroPanel.playerSlot )
			return;

		vSequence.actions.push( new AddClassAction( heroPanel, 'HasItemKicker' ) );

		var fxPanel = heroPanel.FindChildInLayoutFile( 'BurstFX' );
		vSequence.actions.push( new AddClassAction( fxPanel, 'ShowExplosion' ) );
		vSequence.actions.push( new RunFunctionAction( function()
		{

			fxPanel.FireEntityInput( 'item_base_tier' + strItemTierNumber, 'stop', 0 );
			fxPanel.FireEntityInput( 'item_base_tier' + strItemTierNumber, 'start', 0 );
			/*$.DispatchEvent('PlaySoundEffect', 'ui_explosion');*/
		} ) );


		var newPanel = $.CreatePanel( 'Panel', heroPanel, '' );
		newPanel.BLoadLayoutSnippet( 'DiretideItemKicker' );

		if ( itemData.item_image !== undefined && itemData.item_image !== null && itemData.item_image !== "" )
		{
			newPanel.FindChildInLayoutFile( 'ItemImage' ).SetImage( itemData.item_image );
		}
		else
		{
			newPanel.FindChildInLayoutFile( 'ItemIcon' ).SetItemByDefinition( itemData.item_id );
		}
		newPanel.SwitchClass( 'step', 'Start' );
		heroPanel.SwitchClass( 'ItemCategory', strItemCategory );
		vKickerPanels.push( newPanel );
	} );
	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'Step1' ) );
	} );

	//vSequence.actions.push( new PlaySoundAction( "Diretide.Postgame.Award" ) );
	vSequence.actions.push( new PlaySoundAction( "Diretide.Postgame.Award." + strItemCategory ) );

	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'Step2' ) );
		var heroPanel = kicker.GetParent();
		heroPanel.nEventPoints = Math.max( heroPanel.nEventPoints - 100, 0 );
		var newPoints = heroPanel.nEventPoints; // Save off for closure in the RunFunctionAction...
		vSequence.actions.push( new RunFunctionAction( UpdateStackClasses, heroPanel, newPoints ) );
		vSequence.actions.push( new SetDialogVariableIntAction( heroPanel, 'event_points', heroPanel.nEventPoints ) );
	} );
	vSequence.actions.push( new WaitAction( 0.45 ) );
	rootPanel.heroPanels.forEach( function( heroPanel )
	{
		if ( itemData.item_player_slot !== heroPanel.playerSlot )
			return;
		var fxPanel = heroPanel.FindChildInLayoutFile( 'BurstFX' );
		vSequence.actions.push( new RunFunctionAction( function()
		{
			fxPanel.FireEntityInput( 'item_fx' + strItemTierNumber, 'stop', 0 );
			fxPanel.FireEntityInput( 'item_fx' + strItemTierNumber, 'start', 0 );
		} ) );

	} );

	vSequence.actions.push( new WaitAction( 1.0 ) );

	vKickerPanels.forEach( function( kicker )
	{
		vSequence.actions.push( new RemoveClassAction( kicker.GetParent(), 'HasItemKicker' ) );
		vSequence.actions.push( new SwitchClassAction( kicker, 'step', 'End' ) );
	} );

	vSequence.actions.push( new WaitAction( 1.0 ) );

	return vSequence;
}

$.GetContextPanel().CreatePostgameAction = function( data )
{
	var rootPanel = $.GetContextPanel();
	var rootAction = new RunSequentialActions();

	rootAction.actions.push( new PlaySoundAction( "Diretide.Postgame.Underscore" ) );
	rootAction.actions.push( CreatePopuplateHeroScenesAction( data ) );
	rootAction.actions.push( new AddClassAction( rootPanel, 'FadeIn' ) );
	rootAction.actions.push( new WaitAction( 2.5 ) );
	rootAction.actions.push( new AddClassAction( rootPanel, 'PointGrantInProgress' ) );

	// Build the rewards in a specific order

	// Participation
	data.diretide_rewards_progress.awards.forEach(
		function( awardData )
		{
			if ( awardData.award_name == "#DOTA_Diretide_Candy_Reason1" )
			{
				rootAction.actions.push( CreateAwardAction( awardData, rootPanel ) );
				awardData.bDone = true;
			}
		}
	);

	// Winners
	data.diretide_rewards_progress.awards.forEach(
		function( awardData )
		{
			if ( awardData.award_name == "#DOTA_Diretide_Candy_Reason2" )
			{
				rootAction.actions.push( CreateAwardAction( awardData, rootPanel ) );
				awardData.bDone = true;
			}
		}
	);

	// First win of the day
	data.diretide_rewards_progress.awards.forEach(
		function( awardData )
		{
			if ( awardData.award_name == "#DOTA_Diretide_Candy_Reason9" )
			{
				rootAction.actions.push( CreateAwardAction( awardData, rootPanel ) );
				awardData.bDone = true;
			}
		}
	);

	// All the rest
	data.diretide_rewards_progress.awards.forEach(
		function( awardData )
		{
			if ( awardData.bDone === undefined )
			{
				rootAction.actions.push( CreateAwardAction( awardData, rootPanel ) );
				awardData.bDone = true;
			}
		}
	);

	rootAction.actions.push( new RemoveClassAction( rootPanel, 'PointGrantInProgress' ) );

	rootAction.actions.push( new AddClassAction( rootPanel, 'ItemGrantInProgress' ) );
	data.diretide_rewards_progress.items.forEach(
		function( itemData )
		{
			var newAction = CreateItemRewardAction( itemData, rootPanel );
			if ( newAction !== undefined && newAction !== null )
			{
				rootAction.actions.push( newAction );
			}
		}
	);
	rootAction.actions.push( new RemoveClassAction( rootPanel, 'ItemGrantInProgress' ) );
	rootAction.actions.push( new AddClassAction( rootPanel, 'ItemGrantComplete' ) );

	rootAction.actions.push( new WaitAction( 1.0 ) );

	return rootAction;
};

