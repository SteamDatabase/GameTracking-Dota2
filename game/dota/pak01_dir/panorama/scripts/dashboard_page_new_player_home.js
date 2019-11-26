var rgTiers = 
[
	{
		tierName: 'The Basics',
		missions:
		[
			{
				major: true,
				title: 'PA Murderfest',
				subtitle: 'The Phantom Assassin approaches the temple...',
				scenario: 'npx_basics'
			},
			{
				title: 'Explore',
				subtitle: 'Do the exploring',
				scenario: 'npx_explore'
			}
		]
	},
	{
		tierName: 'Farming & Items',
		missions:
		[
			{
				major: true,
				title: 'Alchemist, the Farmer',
				subtitle: 'There is nothing better than turning a profit.',
				scenario: 'npx_farming'
			},
			{
				title: 'Last Hit Trainer',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Neutral Farming Challenge',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Stacking/Pulling Challenge',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: "Shopkeeper's Quiz",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Taking Objectives',
		missions:
		[
			{
				major: true,
				title: "Nature's Prophet, the Rat",
				subtitle: 'Ignore fights, and take the buildings.',
				scenario: 'npx_objectives'
			},
			{
				title: 'Roshan',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Runes & Bottles',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Taking Barracks',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: "Backdoor Protection",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: "Shrines",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Teamfighting',
		missions:
		[
			{
				major: true,
				title: "Echo Slamma Jamma",
				subtitle: 'BOOOM'
			},
			{
				title: 'Counter-Initiation',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Saves & Healing',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Disables & Interrupts',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Laning',
		missions:
		[
			{
				major: true,
				title: 'Mid 1v1',
				subtitle: 'Beat the Bot',
				scenario: 'npx_mid1v1'
			},
			{
				title: 'Hard Support Challenge',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Bot Matches',
		missions:
		[
			{
				major: true,
				title: "Play 5 Bot Matches",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Medium Bots',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Hard Bots',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Unfair Bots',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Matchmaking',
		missions:
		[
			{
				major: true,
				title: "Queue Up!",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
	{
		tierName: 'Hero Mastery',
		missions:
		[
			{
				major: true,
				title: "4 Matches on Every Hero",
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Pudge Hooks',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Mirana Arrows',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Lina Euls Combo',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			},
			{
				title: 'Disruptor Combo',
				subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
			}
		]
	},
];

function SetupScenarioLink( panel, scenario )
{
	panel.SetPanelEvent('onactivate', function ()
	{
		$.DispatchEvent('DOTAShowNewPlayerScenarioDetails', panel, scenario)
	} );
}

function SetupMissions()
{
	var tiersPanel = $( '#Tiers' );
	tiersPanel.RemoveAndDeleteChildren();
		
	for ( var i = 0; i < rgTiers.length; ++i )
	{
		var tier = rgTiers[ i ];

		var tierPanel = $.CreatePanel('Panel', tiersPanel, '');
		tierPanel.BLoadLayoutSnippet('Tier');
		tierPanel.SetDialogVariableInt('tier_number', i + 1);
		tierPanel.SetDialogVariable( 'tier_title', tier.tierName );

		var tierMissionsPanel = tierPanel.FindChildInLayoutFile( 'TierMissions' );

		var tierMissions = tier.missions;

		for (var j = 0; j < tierMissions.length; j++)
		{
			var mission = tierMissions[j];

			var missionPanel = $.CreatePanel('Panel', tierMissionsPanel, '');
			missionPanel.BLoadLayoutSnippet('WelcomeMission');
			missionPanel.SetHasClass('Major', mission.major == true );
			missionPanel.SetDialogVariable('mission_title', mission.title);
			missionPanel.SetDialogVariable('mission_subtitle', mission.subtitle);

			missionPanel.SetHasClass( 'HasScenario', ( 'scenario' in mission ) );
			if ( 'scenario' in mission )
			{
				SetupScenarioLink( missionPanel, mission.scenario );
			}
		}
	}
}