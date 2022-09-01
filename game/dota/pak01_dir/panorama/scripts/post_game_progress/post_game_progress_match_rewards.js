
// Action to animate a hero badge xp increase
class AnimateHeroBadgeXPIncreaseAction extends RunSequentialActions
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
		var rowsContainer = this.panel.FindChildInLayoutFile( "MatchRewardsHeroXPTable" );
		var totalsRow = this.panel.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" );
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
				row.BLoadLayoutSnippet( 'MatchRewardsHeroXPRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_MatchFinished' ) );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_MATCH_WON )
			{
				row.BLoadLayoutSnippet( 'MatchRewardsHeroXPRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_Win' ) );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_CHALLENGE_COMPLETED )
			{
				row.BLoadLayoutSnippet( 'MatchRewardsHeroXPRow_Challenge' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_ChallengeCompleted' ) );
				row.SetDialogVariable( 'challenge_name', this.progress.challenge_description );
				row.SwitchClass( 'challenge_stars', "StarsEarned_" + this.progress.challenge_stars );
			}
			else if ( this.progress.xp_type == HERO_BADGE_XP_TYPE_RELIC_LEVELS )
			{
				row.BLoadLayoutSnippet( 'MatchRewardsHeroXPRow' );
				row.SetDialogVariable( 'xp_type', $.Localize( '#DOTA_PlusPostGame_RelicLevels' ) );
			}
			else
			{
				$.Msg( "Unknown XP type: " + this.progress.xp_type );
				row.BLoadLayoutSnippet( 'MatchRewardsHeroXPRow' );
				row.SetDialogVariable( 'xp_type', this.progress.xp_type );
			}

			row.SetDialogVariableInt( 'xp_value', this.xpValueStart );

			this.actions.push( new AddClassAction( row, 'ShowRow' ) );
			this.actions.push( new SkippableAction( new WaitAction( 0.2 ) ) );
			this.actions.push( new AddClassAction( row, 'ShowValue' ) );
		}

		var duration = GetXPIncreaseAnimationDuration( this.xpAmount );
		var levelProgressBar = this.panel.FindChildInLayoutFile( 'MatchRewardsHeroLevelProgressBar' );
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


// Action to display earning shards
class AnimateShardRewardAction extends SkippableAction
{
	constructor( panel, label, shardAmount, totalStart, currentShards )
	{
		super( null );

		this.panel = panel;
		this.label = label;
		this.shardAmount = shardAmount;
		this.totalStart = totalStart;
		this.currentShardsStart = currentShards;
	}

	start()
	{
		var shardsSection = this.panel.FindChildInLayoutFile( "ShardsMatchRewardsSection" );
		var rowsContainer = shardsSection.FindChildInLayoutFile( "MatchRewardsShardsTable" );
		var totalsRow = shardsSection.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" );

		var row = $.CreatePanel( 'Panel', rowsContainer, '' );
		row.BLoadLayoutSnippet( 'MatchRewardsShardRow' );
		row.SetDialogVariable( 'reward_type', $.Localize( this.label ) );
		row.SetDialogVariableInt( 'shard_value', 0 );

		var seq = new RunSequentialActions();
		seq.actions.push( new AddClassAction( row, 'ShowRow' ) );
		seq.actions.push( new SkippableAction( new WaitAction( 0.2 ) ) );
		seq.actions.push( new AddClassAction( row, 'ShowValue' ) );

		var duration = GetXPIncreaseAnimationDuration( this.shardAmount );
		var par = new RunParallelActions();
		par.actions.push( new AnimateDialogVariableIntAction( row, 'shard_value', 0, this.shardAmount, duration ) );
		par.actions.push( new AnimateDialogVariableIntAction( totalsRow, 'shard_value', this.totalStart, this.totalStart + this.shardAmount, duration ) );
		par.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_shards', this.currentShardsStart, this.currentShardsStart + this.shardAmount, duration ) );
		par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
		seq.actions.push( par );

		this.innerAction = seq;
		super.start();
	}
}


// Action to display progress into shards
class AnimateShardProgressAction extends SkippableAction
{
	constructor( panel, label, progressValue, progressGoal, shardAmount, totalStart, currentShards )
	{
		super( null );

		this.panel = panel;
		this.label = label;
		this.progressValue = progressValue;
		this.progressGoal = progressGoal;
		this.shardAmount = shardAmount;
		this.totalStart = totalStart;
		this.currentShardsStart = currentShards;
	}

	start()
	{
		var shardsSection = this.panel.FindChildInLayoutFile( "ShardsMatchRewardsSection" );
		var rowsContainer = shardsSection.FindChildInLayoutFile( "MatchRewardsShardsTable" );
		var totalsRow = shardsSection.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" );

		var row = $.CreatePanel( 'Panel', rowsContainer, '' );
		row.BLoadLayoutSnippet( 'MatchRewardsShardProgress' );
		row.SetDialogVariable( 'reward_type', $.Localize( this.label ) );

		var seq = new RunSequentialActions();
		seq.actions.push( new AddClassAction( row, 'ShowRow' ) );
		seq.actions.push( new AddClassAction( row, 'CollapseValue' ) );

		var progressContainer = row.FindChildInLayoutFile( 'MatchRewardsTableRowProgress' );
		for ( var i = 0; i < this.progressGoal; i++ )
		{
			var dot = $.CreatePanel( 'Panel', progressContainer, '' );
			dot.AddClass( 'MatchRewardsShardProgressDot' );
			if ( i < this.progressValue )
			{
				seq.actions.push( new SkippableAction( new WaitAction( 0.2 ) ) );
				seq.actions.push( new AddClassAction( dot, 'FilledDot' ) );
				seq.actions.push( new PlaySoundAction( 'WeeklyQuest.StarGranted' ) );
			}
		}

		if ( this.shardAmount > 0 )
		{
			seq.actions.push( new SkippableAction( new WaitAction( 0.2 ) ) );
			seq.actions.push( new RemoveClassAction( row, 'CollapseValue' ) );
			seq.actions.push( new AddClassAction( row, 'ShowValue' ) );

			var duration = GetXPIncreaseAnimationDuration( this.shardAmount );
			var par = new RunParallelActions();
			par.actions.push( new AnimateDialogVariableIntAction( row, 'shard_value', 0, this.shardAmount, duration ) );
			par.actions.push( new AnimateDialogVariableIntAction( totalsRow, 'shard_value', this.totalStart, this.totalStart + this.shardAmount, duration ) );
			par.actions.push( new AnimateDialogVariableIntAction( this.panel, 'current_shards', this.currentShardsStart, this.currentShardsStart + this.shardAmount, duration ) );
			par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
			seq.actions.push( par );
		}

		this.innerAction = seq;
		super.start();
	}
}


// Action to display earning guild points
class AnimateGuildPointsRewardAction extends SkippableAction
{
	constructor( panel, label, totalStartPoints, increaseAmount )
	{
		super( null );

		this.panel = panel;
		this.label = label;
		this.totalStartPoints = totalStartPoints;
		this.increaseAmount = increaseAmount;
	}

	start()
	{
		var rowsContainer = this.panel.FindChildInLayoutFile( "MatchRewardsGuildPointsTable" );
		var totalsRow = this.panel.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" );

		var row = $.CreatePanel( 'Panel', rowsContainer, '' );
		row.BLoadLayoutSnippet( 'MatchRewardsGuildPointsRow' );
		row.SetDialogVariable( 'reward_type', $.Localize( this.label ) );
		row.SetDialogVariableInt( 'guild_points', 0 );

		var seq = new RunSequentialActions();
		seq.actions.push( new AddClassAction( row, 'ShowRow' ) );
		seq.actions.push( new SkippableAction( new WaitAction( 0.2 ) ) );
		seq.actions.push( new AddClassAction( row, 'ShowValue' ) );

		var duration = GetXPIncreaseAnimationDuration( this.increaseAmount );
		var par = new RunParallelActions();
		par.actions.push( new AnimateDialogVariableIntAction( row, 'guild_points', 0, this.increaseAmount, duration ) );
		par.actions.push( new AnimateDialogVariableIntAction( totalsRow, 'guild_points', this.totalStartPoints, this.totalStartPoints + this.increaseAmount, duration ) );
		par.actions.push( new PlaySoundForDurationAction( "XP.Count", duration ) );
		seq.actions.push( par );

		this.innerAction = seq;
		super.start();
	}
}




class AnimateMatchRewardsScreenAction extends RunSequentialActions
{
	constructor( data )
	{
		super();
		this.data = data;
	}

	start()
	{
		// Create the screen
		var panel = StartNewScreen( 'MatchRewardsScreen' );
		panel.BLoadLayoutSnippet( "MatchRewardsProgress" );

		// Setup the sequence of actions to animate the screen
		this.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetDashboardBackgroundVisible', false ); } ) );
		this.actions.push( new AddClassAction( panel, 'ShowScreen' ) );
		this.actions.push( new AddScreenLinkAction( panel, 'MatchRewardsProgress', '#DOTA_MatchRewards' ) );
		this.actions.push( new WaitAction( 0.5 ) );

		var heroBadgeProgress = this.data.hero_badge_progress;
		if ( heroBadgeProgress )
		{
			var heroLevelSection = panel.FindChildInLayoutFile( 'HeroLevelMatchRewardsSection' );
			heroLevelSection.AddClass( "HasMatchRewardsSection" );
			this.actions.push( new AddClassAction( heroLevelSection, 'ShowMatchRewardsSection' ) );

			var xpHeroStart = this.data.hero_badge_xp_start;
			var xpCap = this.data.hero_badge_xp_cap;
			if ( xpCap != 0 && xpHeroStart > xpCap )
			{
				xpHeroStart = xpCap;
			}
			var xpHeroCurrent = xpHeroStart;

			var heroLevelStart = $.GetContextPanel().GetHeroBadgeLevelForHeroXP( xpHeroStart );
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

			heroLevelSection.FindChildInLayoutFile( "MatchRewardsHeroBadge" ).herolevel = heroLevelStart;
			heroLevelSection.SwitchClass( "tier", $.GetContextPanel().GetHeroBadgeTierClassForHeroLevel( heroLevelStart ) );

			heroLevelSection.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" ).SetDialogVariableInt( 'xp_value', 0 );
			heroLevelSection.SetDialogVariableInt( 'current_level_xp', xpLevelStart );
			heroLevelSection.SetDialogVariableInt( 'xp_to_next_level', xpLevelNext );
			heroLevelSection.SetDialogVariableInt( 'current_level', heroLevelStart );

			heroLevelSection.FindChildInLayoutFile( "MatchRewardsHeroLevelProgressBar" ).max = xpLevelNext;
			heroLevelSection.FindChildInLayoutFile( "MatchRewardsHeroLevelProgressBar" ).value = xpLevelStart;

			var heroModel = heroLevelSection.FindChildInLayoutFile( 'MatchRewardsHeroLevelModel' );
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

			heroLevelSection.SetDialogVariableInt( 'hero_id', this.data.hero_id );

			var xpEarned = 0;
			var xpLevel = xpLevelStart;
			var heroLevel = heroLevelStart;
			for ( var i = 0; i < heroBadgeProgress.length; ++i )
			{
				var xpRemaining = heroBadgeProgress[i].xp_amount;
				var xpEarnedOnRow = 0;

				if ( xpCap != 0 && xpHeroCurrent >= xpCap )
				{
					this.actions.push( new AddClassAction( heroLevelSection, 'HeroLevelPlusRestricted' ) );
					break;
				}

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

						var xpAfterAnimate = xpHeroCurrent + xpToAnimate;
						if ( xpCap != 0 && xpAfterAnimate >= xpCap )
						{
							xpToAnimate = xpCap - xpHeroCurrent;
						}
					}

					if ( xpToAnimate > 0 )
					{
						this.actions.push( new SkippableAction( new AnimateHeroBadgeXPIncreaseAction( heroLevelSection, heroBadgeProgress[i], xpToAnimate, xpEarnedOnRow, xpEarned, xpLevel, xpEarnedOnRow != 0 ) ) );

						xpEarned += xpToAnimate;
						xpLevel += xpToAnimate;
						xpEarnedOnRow += xpToAnimate;
						xpHeroCurrent += xpToAnimate;
						xpRemaining -= xpToAnimate;
					}

					if ( xpCap != 0 && xpHeroCurrent >= xpCap )
					{
						this.actions.push( new AddClassAction( heroLevelSection, 'HeroLevelPlusRestricted' ) );
						break;
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
								heroLevelSection.SetDialogVariableInt( 'current_level', heroLevel );
							} ) );

							var levelUpData = me.data.hero_badge_level_up[heroLevel];
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
								panel.FindChildInLayoutFile( "MatchRewardsHeroBadge" ).herolevel = heroLevel;
								panel.SwitchClass( "tier", $.GetContextPanel().GetHeroBadgeTierClassForHeroLevel( heroLevel ) );
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
								panel.FindChildInLayoutFile( "MatchRewardsHeroLevelProgressBar" ).max = xpLevelNextInternal;
								panel.FindChildInLayoutFile( "MatchRewardsHeroLevelProgressBar" ).value = xpLevelInternal;
							} ) );
						} )( this, xpLevel, xpLevelNext );

					}
				}

				this.actions.push( new WaitAction( 0.2 ) );
			}

			this.actions.push( new StopSkippingAheadAction() );
		}

		var dotaPlusProgress = this.data.dota_plus_progress;
		if ( dotaPlusProgress !== undefined )
		{
			var shardsSection = panel.FindChildInLayoutFile( "ShardsMatchRewardsSection" );
			shardsSection.AddClass( "HasMatchRewardsSection" );
			this.actions.push( new AddClassAction( shardsSection, 'ShowMatchRewardsSection' ) );

			var rowsContainer = shardsSection.FindChildInLayoutFile( "MatchRewardsShardsTable" );
			var totalsRow = shardsSection.FindChildInLayoutFile( "MatchRewardsTableTotalsRow" );
			totalsRow.SetDialogVariableInt( 'shard_value', 0 );

			panel.SetDialogVariableInt( 'current_shards', dotaPlusProgress.initial_shards );

			var nTotalEarned = 0;
			var nCurrentShards = dotaPlusProgress.initial_shards;

			if ( dotaPlusProgress.guild_contracts_shard_reward > 0 )
			{
				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_GuildContracts', dotaPlusProgress.guild_contracts_shard_reward, nTotalEarned, nCurrentShards ) );
				nTotalEarned += dotaPlusProgress.guild_contracts_shard_reward;
				nCurrentShards += dotaPlusProgress.guild_contracts_shard_reward;
			}

			if ( dotaPlusProgress.tips !== undefined && dotaPlusProgress.tips.length != 0 )
			{
				var nShardTips = 0;
				for ( var i = 0; i < dotaPlusProgress.tips.length; ++i )
				{
					nShardTips += dotaPlusProgress.tips[i].amount;
				}

				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_PlayerTips', nShardTips, nTotalEarned, nCurrentShards ) );
				nTotalEarned += nShardTips;
				nCurrentShards += nShardTips;
			}

			if ( dotaPlusProgress.victory_prediction_shard_reward > 0 )
			{
				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_VictoryPrediction', dotaPlusProgress.victory_prediction_shard_reward, nTotalEarned, nCurrentShards ) );
				nTotalEarned += dotaPlusProgress.victory_prediction_shard_reward;
				nCurrentShards += dotaPlusProgress.victory_prediction_shard_reward;
			}

			if ( dotaPlusProgress.cavern_crawl !== undefined )
			{
				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_CavernCrawlProgress', dotaPlusProgress.cavern_crawl.shard_amount, nTotalEarned, nCurrentShards ) );
				nTotalEarned += dotaPlusProgress.cavern_crawl.shard_amount;
				nCurrentShards += dotaPlusProgress.cavern_crawl.shard_amount;
			}

			if ( dotaPlusProgress.role_call_shard_reward > 0 )
			{
				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_RoleCallProgress', dotaPlusProgress.role_call_shard_reward, nTotalEarned, nCurrentShards ) );
				nTotalEarned += dotaPlusProgress.role_call_shard_reward;
				nCurrentShards += dotaPlusProgress.role_call_shard_reward;
			}

			if ( dotaPlusProgress.max_level_hero_challenge_shard_reward > 0 )
			{
				this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_MaxLevelHeroChallenge', dotaPlusProgress.max_level_hero_challenge_shard_reward, nTotalEarned, nCurrentShards ) );
				nTotalEarned += dotaPlusProgress.max_level_hero_challenge_shard_reward;
				nCurrentShards += dotaPlusProgress.max_level_hero_challenge_shard_reward;
			}

			if ( dotaPlusProgress.featured_gamemode_progress != null )
			{
				var nGainedShards = dotaPlusProgress.featured_gamemode_progress.end_value - dotaPlusProgress.featured_gamemode_progress.start_value;
				if ( nGainedShards > 0 )
				{
					this.actions.push( new AnimateShardRewardAction( panel, '#DOTA_PlusPostGame_FeaturedGameMode', nGainedShards, nTotalEarned, nCurrentShards ) );
					// this.actions.push( new AnimateShardProgressAction( panel, '#DOTA_PlusPostGame_FeaturedGameMode', dotaPlusProgress.featured_gamemode_wins, dotaPlusProgress.featured_gamemode_wins_goal, dotaPlusProgress.featured_gamemode_shard_reward, nTotalEarned, nCurrentShards ) );
					nTotalEarned += nGainedShards;
					nCurrentShards += nGainedShards;
				}
			}

			this.actions.push( new StopSkippingAheadAction() );
		}

		var guildProgress = this.data.guild_progress;
		if ( guildProgress )
		{
			var guildSection = panel.FindChildInLayoutFile( 'GuildMatchRewardsSection' );
			guildSection.AddClass( 'HasMatchRewardsSection' );
			this.actions.push( new AddClassAction( guildSection, 'ShowMatchRewardsSection' ) );

			guildSection.SetDialogVariableInt( 'guild_id', guildProgress.guild_id );

			var guildPointsTotal = guildSection.FindChildInLayoutFile( 'MatchRewardsTableTotalsRow' );
			guildPointsTotal.SetDialogVariableInt( 'guild_points', 0 );

			var guildImage = guildSection.FindChildInLayoutFile( 'MatchRewardsGuildImage' );
			guildImage.guildid = guildProgress.guild_id;

			var nContractGuildPoints = 0;
			if ( guildProgress.guild_contracts != null && guildProgress.guild_contracts.length > 0 )
			{
				var contractsList = guildSection.FindChildInLayoutFile( "MatchRewardsGuildContracts" );
				for ( var i = 0; i < guildProgress.guild_contracts.length; ++i )
				{
					var guildContract = guildProgress.guild_contracts[i];

					var contractPanel = $.CreatePanel( 'Panel', contractsList, '' );
					contractPanel.BLoadLayoutSnippet( 'MatchRewardsGuildContract' );
					var contract = contractPanel.FindChildInLayoutFile( 'GuildContract' );
					contract.SetContract( guildProgress.guild_event_id, guildContract.challenge_instance_id, guildContract.challenge_parameter, guildContract.completed );
					contractPanel.SetHasClass( "ContractCompleted", guildContract.completed );

					this.actions.push( new AddClassAction( contractPanel, 'ShowGuildContract' ) );
					this.actions.push( new WaitAction( 0.1 ) );

					if ( guildContract.completed )
					{
						nContractGuildPoints += guildContract.guild_point_reward;
					}
				}

				guildSection.AddClass( "HasGuildContracts" );
			}

			if ( guildProgress.guild_challenge != null )
			{
				var guildChallenge = guildProgress.guild_challenge;

				var challengeImage = panel.FindChildInLayoutFile( "MatchRewardsGuildChallengeImage" );
				challengeImage.SetImage( guildChallenge.challenge_image );

				guildSection.SetDialogVariable( "challenge_description", guildChallenge.challenge_description );

				guildSection.SetDialogVariableInt( "challenge_start_value", guildChallenge.challenge_start_value );
				guildSection.SetDialogVariableInt( "challenge_max_value", guildChallenge.challenge_max_value );
				guildSection.SetDialogVariableInt( "challenge_progress", guildChallenge.challenge_progress );

				var challengeProgressBar = panel.FindChildInLayoutFile( "MatchRewardsGuildChallengeProgressBar" );
				challengeProgressBar.min = 0;
				challengeProgressBar.max = guildChallenge.challenge_max_value;
				challengeProgressBar.lowervalue = guildChallenge.challenge_start_value;
				challengeProgressBar.uppervalue = guildChallenge.challenge_start_value + guildChallenge.challenge_progress;

				this.actions.push( new AddClassAction( guildSection, 'ShowGuildChallenge' ) );
				this.actions.push( new WaitAction( 0.1 ) );

				guildSection.AddClass( "HasGuildChallenge" );
			}

			var nGuildPointsEarned = 0;
			if ( guildProgress.match_guild_points != null )
			{
				if ( guildProgress.match_guild_points.match_completed_guild_points > 0 )
				{
					var pointsLabel = "";
					if ( guildProgress.match_guild_points.party_guild_member_count <= 1 )
					{
						pointsLabel = $.Localize( '#DOTA_MatchRewards_GuildSoloMatch' );
					}
					else
					{
						guildSection.SetDialogVariableInt( 'party_member_count', guildProgress.match_guild_points.party_guild_member_count );
						pointsLabel = $.LocalizePlural( '#DOTA_MatchRewards_GuildMembersInParty:p', guildProgress.match_guild_points.party_guild_member_count, guildSection );
					}

					this.actions.push( new AnimateGuildPointsRewardAction( guildSection, pointsLabel, nGuildPointsEarned, guildProgress.match_guild_points.match_completed_guild_points ) );
					nGuildPointsEarned += guildProgress.match_guild_points.match_completed_guild_points;

				}

				if ( guildProgress.match_guild_points.win_guild_points > 0 )
				{
					this.actions.push( new AnimateGuildPointsRewardAction( guildSection, $.Localize( '#DOTA_MatchRewards_WinGuildPoints' ), nGuildPointsEarned, guildProgress.match_guild_points.win_guild_points ) );
					nGuildPointsEarned += guildProgress.match_guild_points.win_guild_points;
				}
			}

			if ( nContractGuildPoints > 0 )
			{
				this.actions.push( new AnimateGuildPointsRewardAction( guildSection, $.Localize( '#DOTA_MatchRewards_ContractsCompleted' ), nGuildPointsEarned, nContractGuildPoints ) );
				nGuildPointsEarned += nContractGuildPoints;
			}
		}

		this.actions.push( new StopSkippingAheadAction() );
		this.actions.push( new SkippableAction( new WaitAction( 1.0 ) ) );
		this.actions.push( new SwitchClassAction( panel, 'current_screen', '' ) );
		this.actions.push( new SkippableAction( new WaitAction( 0.5 ) ) );
		this.actions.push( new RunFunctionAction( function() { $.DispatchEvent( 'DOTASetDashboardBackgroundVisible', true ); } ) );

		super.start();
	}
}


function TestAnimateMatchRewards()
{
	var data =
	{
		hero_id: 6,

		// hero_badge_xp_start: 22850,

		/* Uncomment to test what happens if leveling is plus restricted. */
		// hero_badge_xp_start: 2500,
		// hero_badge_xp_cap: 2749,

		/* Uncomment to test what happens at max level */
		hero_badge_xp_start: 71850,

		hero_badge_progress:
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

		hero_badge_level_up:
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
						},
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_CHAT_WHEEL,
							chat_wheel_message: "#dota_chatwheel_message_nevermore_4",
							all_chat: 1,
							sound_event: "soundboard.ay_ay_ay"
						},
						{
							reward_type: HERO_BADGE_LEVEL_REWARD_CURRENCY,
							currency_amount: 3000
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

		dota_plus_progress:
		{
			initial_shards: 4567,

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
				event_id: 36,
				hero_id: 87,
				hero_name: 'disruptor',
				shard_amount: 150,
			},

			victory_prediction_shard_reward: 20,
			guild_contracts_shard_reward: 250,
			role_call_shard_reward: 50,
			max_level_hero_challenge_shard_reward: 250,

			featured_gamemode_progress:
			{
				start_value: 0,
				end_value: 100,
				max_value: 300,
			}
		},

		guild_progress:
		{
			guild_id: 4,
			guild_event_id: 19,

			match_guild_points:
			{
				party_guild_member_count: 3,
				match_completed_guild_points: 50,
				win_guild_points: 50,
			},

			guild_contracts:
				[
					{
						challenge_instance_id: 2152900061,
						challenge_parameter: 23,
						completed: true,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
					{
						challenge_instance_id: 2506886225,
						challenge_parameter: 22000,
						completed: false,
						battle_point_reward: 150,
						guild_point_reward: 150
					},
				],

			guild_challenge:
			{
				challenge_image: "file://{images}/guilds/challenges/guild_challenge_assists.png",
				challenge_description: "Get 400 Assists",
				challenge_start_value: 1234,
				challenge_max_value: 4500,
				challenge_progress: 400
			}
		}

	};

	TestProgressAnimation( data );
}
