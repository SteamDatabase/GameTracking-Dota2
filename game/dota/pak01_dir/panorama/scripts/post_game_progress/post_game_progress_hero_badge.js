
// ----------------------------------------------------------------------------
//   Hero Badge Level Screen
// ----------------------------------------------------------------------------

function GetXPIncreaseAnimationDurationOld( xpAmount )
{
	return RemapValClamped( xpAmount, 0, 500, 0.5, 1.0 );
}

// Action to animate a hero badge xp increase
class AnimateHeroBadgeXPIncreaseActionOld extends RunSequentialActions
{
	constructor( panel, progress, xpAmount, xpValueStart, xpEarnedStart, xpLevelStart, resumeFromPreviousRow )
	{
		super();
		this.panel = panel;
		this.progress = progress;
		this.xpAmount = xpAmount;
		this.xpValueStart = xpValueStart;
		this.xpEarnedStart = xpEarnedStart;
		this.xpLevelStart = xpLevelStart;
		this.resumeFromPreviousRow = resumeFromPreviousRow;
	}

	start()
	{
		var rowsContainer = this.panel.FindChildInLayoutFile( "HeroBadgeProgressRows" );
		var totalsRow = this.panel.FindChildInLayoutFile( "TotalsRow" );
		var row = null;

		if ( this.resumeFromPreviousRow )
		{
			row = rowsContainer.GetChild( rowsContainer.GetChildCount() - 1 );
		}
		else
		{
			row = $.CreatePanel( 'Panel', rowsContainer, '' );

			if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_MATCH_FINISHED )
			{
				row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_MatchFinished' ) );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_MATCH_WON )
			{
				row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_Win' ) );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED )
			{
				row.BLoadLayoutSnippet( 'HeroBadgeProgressRow_Challenge' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_ChallengeCompleted' ) );
				row.SetDialogVariable( 'challenge_name', this.progress.challenge_description );
				row.SwitchClass( 'challenge_stars', "StarsEarned_" + this.progress.challenge_stars );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_RELIC_LEVELS )
			{
				row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_RelicLevels' ) );
			}
			else
			{
				$.Msg( "Unknown XP type: " + this.progress.xp_type );
				row.BLoadLayoutSnippet( 'HeroBadgeProgressRow' );
				row.SetDialogVariable( 'xp_type', this.progress.xp_type );
			}

			row.SetDialogVariableInt( 'xp_value', this.xpValueStart );

			this.actions.push( new AddClassAction( row, 'ShowRow' ) );
			this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
			this.actions.push( new AddClassAction( row, 'ShowValue' ) );
		}

		var duration = GetXPIncreaseAnimationDurationOld( this.xpAmount );
		var levelProgressBar = this.panel.FindChildInLayoutFile( 'HeroBadgeLevelProgress' );
		var minLevelXP = Math.min( this.xpLevelStart, levelProgressBar.max );
		var maxLevelXP = Math.min( this.xpLevelStart + this.xpAmount, levelProgressBar.max );
		var par = new RunParallelActions();
		par.actions.push( new AnimateDialogVariableIntAction( row, 'xp_value', this.xpValueStart, this.xpValueStart + this.xpAmount, duration ) );
		par.actions.push( new AnimateDialogVariableIntAction( totalsRow, 'xp_value', this.xpEarnedStart, this.xpEarnedStart + this.xpAmount, duration ) );
		par.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_level_xp', minLevelXP, maxLevelXP, duration ) );
		par.actions.push( new AnimateProgressBarAction( levelProgressBar, minLevelXP, maxLevelXP, duration ) );
		par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
		this.actions.push( par );

		super.start();
	}
}


// Action to display victory prediction shards
class AnimateShardRewardActionOld extends RunSequentialActions
{
	constructor( panel, label, shardAmount )
	{
		super();
		this.panel = panel;
		this.label = label;
		this.shardAmount = shardAmount;

	}

	super()
	{
		var rowsContainer = this.panel.FindChildInLayoutFile( "HeroBadgeProgressRows" );
		var row = null;

		this.seq = new RunSequentialActions();

		row = $.CreatePanel( 'Panel', this.panel.FindChildInLayoutFile( "HeroBadgeProgressCenter" ), '' );
		row.BLoadLayoutSnippet( 'HeroBadgeProgressRow_ShardReward' );
		row.SetDialogVariable( 'reward_type', $.Localize( this.label ) );
		row.SetDialogVariableInt( 'shard_value', 0 );
		this.actions.push( new AddClassAction( row, 'ShowRow' ) );
		this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
		this.actions.push( new AddClassAction( row, 'ShowValue' ) );
		var duration = GetXPIncreaseAnimationDurationOld( this.shardAmount ) * 2;
		var par = new RunParallelActions();
		par.actions.push( new AnimateDialogVariableIntAction( row, 'shard_value', 0, this.shardAmount, duration ) );
		par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
		this.actions.push( par );
		super.start();
	}
}


class AnimateHeroBadgeLevelRewardAction extends RunSequentialActions
{
	constructor( data, containerPanel )
	{
		super();
		this.data = data;
		this.containerPanel = containerPanel;
	}

	start()
	{
		if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_TIER )
		{
			var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
			reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardTier' );
			reward.AddClass( this.data.tier_class );
			reward.SetDialogVariable( "tier_name", $.Localize( this.data.tier_name ) );
			this.actions.push( new AddClassAction( reward, 'ShowReward' ) );
		}
		else if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL )
		{
			var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
			reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardChatWheel' );
			reward.SetDialogVariable( "all_chat_prefix", this.data.all_chat ? $.Localize( '#dota_all_chat_label_prefix' ) : "" );
			reward.SetDialogVariable( "chat_wheel_message", $.Localize( this.data.chat_wheel_message ) );
			var sound_event = this.data.sound_event;
			$.RegisterEventHandler( "Activated", reward, function()
			{
				PlayUISoundScript( sound_event );
			} );
			this.actions.push( new AddClassAction( reward, 'ShowReward' ) );
		}
		else if ( this.data.reward_type == HERO_BADGE_LEVEL_REWARD_CURRENCY )
		{
			var reward = $.CreatePanel( 'Panel', this.containerPanel, '' );
			reward.BLoadLayoutSnippet( 'HeroBadgeLevelUpRewardCurrency' );
			reward.SetDialogVariableInt( "currency_amount", this.data.currency_amount );
			this.actions.push( new AddClassAction( reward, 'ShowReward' ) );
		}
		else
		{
			$.Msg( "Unknown reward_type '" + this.data.reward_type + "', skipping" );
		}

		this.actions.push( new WaitAction( 1.0 ) );

		super.start();
	}
}


class AnimateSingleRelicProgressAction extends RunSequentialActions
{
	constructor( data, containerPanel )
	{
		super();
		this.data = data;
		this.containerPanel = containerPanel;
	}

	start()
	{
		this.panel = $.CreatePanel( 'Panel', this.containerPanel, '' );
		this.panel.BLoadLayoutSnippet( 'SingleRelicProgress' );
		this.panel.SetDialogVariableInt( 'relic_type', this.data.relic_type );
		this.panel.SetDialogVariableInt( 'current_progress', this.data.starting_value );
		this.panel.SetDialogVariableInt( 'increment', this.data.ending_value - this.data.starting_value );

		var relicImage = this.panel.FindChildInLayoutFile( "SingleRelicImage" );
		relicImage.SetRelic( this.data.relic_type, this.data.relic_rarity, this.data.primary_attribute, false );

		this.actions.push( new AddClassAction( this.panel, 'ShowProgress' ) );
		this.actions.push( new WaitAction( 0.2 ) );
		this.actions.push( new AddClassAction( this.panel, 'ShowIncrement' ) );
		this.actions.push( new WaitAction( 0.4 ) );


		return super.start();
	}
}


class AnimateHeroBadgeLevelScreenAction extends RunSequentialActions
{
	constructor( data )
	{
		super();
		this.data = data;
	}

	start()
	{
		var xpHeroStart = this.data.hero_badge_xp_start;
		var heroLevelStart = $.GetContextPanel().GetHeroBadgeLevelForHeroXP( xpHeroStart );
		var heroID = this.data.hero_id;

		var xpTotalLevelStart = $.GetContextPanel().GetTotalHeroXPRequiredForHeroBadgeLevel( heroLevelStart );

		var xpLevelStart = 0;
		var xpLevelNext = 0;
		if ( heroLevelStart < k_unMaxHeroRewardLevel )
		{
			xpLevelStart = xpHeroStart - xpTotalLevelStart;
			xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( heroLevelStart );
		}
		else
		{
			xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( k_unMaxHeroRewardLevel - 1 );
			xpLevelStart = xpLevelNext;
		}

		// Create the screen and do a bunch of initial setup
		var panel = StartNewScreen( 'HeroBadgeProgressScreen' );
		panel.BLoadLayoutSnippet( "HeroBadgeProgress" );
		panel.FindChildInLayoutFile( "HeroBadgeProgressHeroBadge" ).herolevel = heroLevelStart;

		panel.FindChildInLayoutFile( "TotalsRow" ).SetDialogVariableInt( 'xp_value', 0 );
		panel.SetDialogVariableInt( 'current_level_xp', xpLevelStart );
		panel.SetDialogVariableInt( 'xp_to_next_level', xpLevelNext );
		panel.SetDialogVariableInt( 'current_level', heroLevelStart );

		panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).max = xpLevelNext;
		panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).value = xpLevelStart;

		var heroModel = panel.FindChildInLayoutFile( 'HeroBadgeHeroModel' );
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

		if ( this.data.hero_badge_progress_old )
		{
			this.actions.push( new AddScreenLinkAction( panel, 'HeroBadgeProgress', '#DOTA_PlusPostGame_HeroProgress', function()
			{
				panel.SwitchClass( 'current_screen', 'ShowHeroProgress' );
			} ) );

			this.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowHeroProgress' ) );

			var xpEarned = 0;
			var xpLevel = xpLevelStart;
			var heroLevel = heroLevelStart;
			for ( var i = 0; i < this.data.hero_badge_progress_old.length; ++i )
			{
				var xpRemaining = this.data.hero_badge_progress_old[i].xp_amount;
				var xpEarnedOnRow = 0;

				while ( xpRemaining > 0 )
				{
					var xpToAnimate = 0;
					var xpToNextLevel = 0;
					if ( heroLevel >= k_unMaxHeroRewardLevel )
					{
						xpToAnimate = xpRemaining;
					}
					else
					{
						xpToNextLevel = xpLevelNext - xpLevel;
						xpToAnimate = Math.min( xpRemaining, xpToNextLevel );
					}

					if ( xpToAnimate > 0 )
					{
						this.actions.push( new SkippableAction( new AnimateHeroBadgeXPIncreaseActionOld( panel, this.data.hero_badge_progress_old[i], xpToAnimate, xpEarnedOnRow, xpEarned, xpLevel, xpEarnedOnRow != 0 ) ) );

						xpEarned += xpToAnimate;
						xpLevel += xpToAnimate;
						xpEarnedOnRow += xpToAnimate;
						xpRemaining -= xpToAnimate;
					}

					xpToNextLevel = xpLevelNext - xpLevel;
					if ( xpToNextLevel == 0 && heroLevel < k_unMaxHeroRewardLevel )
					{
						heroLevel = heroLevel + 1;

						this.actions.push( new StopSkippingAheadAction() );

						( function( me, heroLevel )
						{
							me.actions.push( new RunFunctionAction( function()
							{
								panel.AddClass( "LeveledUp" );
								panel.SetDialogVariableInt( 'current_level', heroLevel );
							} ) );

							var levelUpData = me.data.hero_badge_level_up_old[heroLevel];
							if ( levelUpData )
							{
								var levelUpScene = panel.FindChildInLayoutFile( 'LevelUpRankScene' );

								me.actions.push( new ActionWithTimeout( new WaitForClassAction( levelUpScene, 'SceneLoaded' ), 3.0 ) );

								var rewardsPanel = panel.FindChildInLayoutFile( "HeroBadgeProgressRewardsList" );

								me.actions.push( new RunFunctionAction( function()
								{
									rewardsPanel.RemoveAndDeleteChildren();
									panel.RemoveClass( 'RewardsFinished' );

									PlayUISoundScript( "HeroBadge.Levelup" );
									$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'light_rank_' + levelUpData.tier_number, 'TurnOn', '1' );
									$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'particle_rank_' + levelUpData.tier_number, 'start', '1' );
								} ) );

								me.actions.push( new SkippableAction( new WaitAction( 4.0 ) ) );

								for ( var j = 0; j < levelUpData.rewards.length; ++j )
								{
									me.actions.push( new SkippableAction( new AnimateHeroBadgeLevelRewardAction( levelUpData.rewards[j], rewardsPanel ) ) );
								}

								me.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
								me.actions.push( new AddClassAction( panel, 'RewardsFinished' ) );
								me.actions.push( new WaitForEventAction( panel.FindChildInLayoutFile( "RewardsFinishedButton" ), 'Activated' ) );
								me.actions.push( new StopSkippingAheadAction() );

								me.actions.push( new RunFunctionAction( function()
								{
									$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'light_rank_' + levelUpData.tier_number, 'TurnOff', '1' );
									$.DispatchEvent( 'DOTASceneFireEntityInput', levelUpScene, 'particle_rank_' + levelUpData.tier_number, 'DestroyImmediately', '1' );
								} ) );
							}

							me.actions.push( new RunFunctionAction( function()
							{
								panel.RemoveClass( 'LeveledUp' );
								panel.FindChildInLayoutFile( "HeroBadgeProgressHeroBadge" ).herolevel = heroLevel;
							} ) );

						} )( this, heroLevel );

						this.actions.push( new WaitAction( 1.0 ) );

						if ( heroLevel >= k_unMaxHeroRewardLevel )
						{
							xpLevel = xpLevelNext;
						}
						else
						{
							xpLevel = 0;
							xpLevelNext = $.GetContextPanel().GetHeroXPForNextHeroBadgeLevel( heroLevel );
						}

						( function( me, xpLevelInternal, xpLevelNextInternal )
						{
							me.actions.push( new RunFunctionAction( function()
							{
								panel.SetDialogVariableInt( 'current_level_xp', xpLevelInternal );
								panel.SetDialogVariableInt( 'xp_to_next_level', xpLevelNextInternal );
								panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).max = xpLevelNextInternal;
								panel.FindChildInLayoutFile( "HeroBadgeLevelProgress" ).value = xpLevelInternal;
							} ) );
						} )( this, xpLevel, xpLevelNext );

					}
				}

				this.actions.push( new WaitAction( 0.2 ) );
			}

			if ( this.data.dota_plus_progress_old !== undefined )
			{
				if ( this.data.dota_plus_progress_old.tips !== undefined && this.data.dota_plus_progress_old.tips.length != 0 )
				{
					var nShardTips = 0;
					for ( var i = 0; i < this.data.dota_plus_progress_old.tips.length; ++i )
					{
						nShardTips += this.data.dota_plus_progress_old.tips[i].amount;
					}
					this.actions.push( new AnimateShardRewardActionOld( panel, '#DOTA_PlusPostGame_PlayerTips', nShardTips ) );
				}

				if ( this.data.dota_plus_progress_old.victory_prediction_shard_reward > 0 )
				{
					this.actions.push( new AnimateShardRewardActionOld( panel, '#DOTA_PlusPostGame_VictoryPrediction', this.data.dota_plus_progress_old.victory_prediction_shard_reward ) );
				}

				if ( this.data.dota_plus_progress_old.cavern_crawl !== undefined )
				{
					this.actions.push( new AnimateShardRewardActionOld( panel, '#DOTA_PlusPostGame_CavernCrawlProgress', this.data.dota_plus_progress_old.cavern_crawl.shard_amount ) );
				}

				if ( this.data.dota_plus_progress_old.role_call_shard_reward > 0 )
				{
					this.actions.push( new AnimateShardRewardActionOld( panel, '#DOTA_PlusPostGame_RoleCallProgress', this.data.dota_plus_progress_old.role_call_shard_reward ) );
				}
			}

			this.actions.push( new StopSkippingAheadAction() );
			this.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
			this.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
			this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
		}

		// Now animate the relics
		if ( this.data.hero_relics_progress_old )
		{
			if ( this.data.hero_relics_progress_old.length > 0 )
			{
				this.actions.push( new StopSkippingAheadAction() );
				this.actions.push( new AddScreenLinkAction( panel, 'HeroRelicsProgress', '#DOTA_PlusPostGame_RelicsProgress', function()
				{
					panel.SwitchClass( 'current_screen', 'ShowRelicsProgress' );
				} ) );

				this.actions.push( new SwitchClassAction( panel, 'current_screen', 'ShowRelicsProgress' ) );
				this.actions.push( new WaitAction( 0.5 ) );
				var stagger = new RunStaggeredActions( 0.15 );
				this.actions.push( new SkippableAction( stagger ) );
				var relicsList = panel.FindChildInLayoutFile( "HeroRelicsProgressList" );
				for ( var i = 0; i < this.data.hero_relics_progress_old.length; ++i )
				{
					stagger.actions.push( new AnimateSingleRelicProgressAction( this.data.hero_relics_progress_old[i], relicsList ) );
				}

				this.actions.push( new StopSkippingAheadAction() );
				this.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
				this.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
				this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
			}
		}

		super.start();
	}
}




function TestAnimateHeroBadgeLevel()
{
	var data =
	{
		hero_id: 11,
		hero_badge_xp_start: 22850,

		hero_badge_progress_old:
			[
				{
					xp_type: HERO_BADGE_XP_TYPE_MATCH_FINISHED,
					xp_amount: 50
				},
				{
					xp_type: HERO_BADGE_XP_TYPE_MATCH_WON,
					xp_amount: 50
				},
				{
					xp_type: HERO_BADGE_XP_TYPE_RELIC_LEVELS,
					xp_amount: 20
				},
				{
					xp_type: HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED,
					xp_amount: 375,

					challenge_stars: 2,
					challenge_description: "Kill an enemy hero in 15 seconds after teleporting in 1/2/3 times."
				},
			],

		hero_badge_level_up_old:
		{
			18:
			{
				tier_number: 4,
				rewards:
					[
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_TIER,
							tier_name: "#DOTA_HeroLevelBadgeTier_Platinum",
							tier_class: "PlatinumTier"
						},
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL,
							chat_wheel_message: "#dota_chatwheel_message_nevermore_4",
							all_chat: 1,
							sound_event: "soundboard.ay_ay_ay"
						}
					],
			},
			19:
			{
				tier_number: 4,
				rewards:
					[
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_CURRENCY,
							currency_amount: 3000
						}
					]
			}
		},
		hero_relics_progress_old:
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
			],

		dota_plus_progress_old:
		{
			tips:
				[
					{
						account_id: 172258,
						count: 2,
						amount: 50,
					},
				],

			cavern_crawl:
			{
				event_id: 29,
				hero_id: 87,
				hero_name: 'disruptor',
				shard_amount: 150,
			},

			victory_prediction_shard_reward: 20,

			role_call_shard_reward: 25
		}

	};

	TestProgressAnimation( data );
}
