"use strict";

/* Action-RPG style input handling.

Left click moves or trigger ability 1.
Right click triggers ability 2.
*/

function GetMouseCastTarget()
{
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex !== localHeroIndex; } );
	for ( var e of mouseEntities )
	{
		if ( !e.accurateCollision )
			continue;
		return e.entityIndex;
	}

	for ( var e of mouseEntities )
	{
		return e.entityIndex;
	}

	return -1;
}

function GetMouseCastPosition( abilityIndex )
{
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	var localHeroPosition = Entities.GetAbsOrigin( localHeroIndex );
	var position = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
	var targetDelta = [ position[0] - localHeroPosition[0], position[1] - localHeroPosition[1] ];
	var targetDist = Math.sqrt( targetDelta[0] * targetDelta[0] + targetDelta[1] * targetDelta[1] );
	var abilityRange = Abilities.GetCastRange( abilityIndex );
	if ( targetDist > abilityRange && abilityRange > 0 )
	{
		position[0] = localHeroPosition[0] + targetDelta[0] * abilityRange / targetDist;
		position[1] = localHeroPosition[1] + targetDelta[1] * abilityRange / targetDist;
	}
	return position;
}

// Tracks the left-button held when attacking a target
function BeginAttackState( nMouseButton, abilityIndex, targetEntityIndex )
{
	var order = {
		AbilityIndex : abilityIndex,
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};

	var abilityBehavior = Abilities.GetBehavior( abilityIndex );
	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
	{
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
		order.Position = GetMouseCastPosition( abilityIndex );
	}


	if ( ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) && ( targetEntityIndex !== -1 ) )
	{
		// If shift is held down and we've a valid point target order and our unit target is out of range,
		// just use the point target.
		if ( ! ( GameUI.IsShiftDown() 
				&& order.OrderType !== undefined 
				&& !Entities.IsEntityInRange( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), targetEntityIndex, abilityRange ) ) )
		{
			order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TARGET;
			order.TargetIndex = targetEntityIndex;
		}
	}

	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_NO_TARGET )
	{
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
	}

	if ( order.OrderType === undefined )
		return;

	(function tic()
	{
		if ( GameUI.IsMouseDown( nMouseButton ) )
		{
			if ( order.TargetIndex !== undefined )
			{
				if ( Entities.GetTeamNumber( order.TargetIndex ) === DOTATeam_t.DOTA_TEAM_GOODGUYS )
				{
					return;
				}
				if ( !Entities.IsAlive( order.TargetIndex) )
				{
					return;
				}
			}
	
			if ( order.TargetIndex === undefined && GameUI.IsShiftDown() )
			{
				order.Position = GetMouseCastPosition( abilityIndex );
			}

			if ( Abilities.IsCooldownReady( order.AbilityIndex ) && !Abilities.IsInAbilityPhase( order.AbilityIndex ) )
			{
				Game.PrepareUnitOrders( order );
			}
			$.Schedule( 1.0/30.0, tic );
		}	
	})();
}

// Tracks the left-button helf when picking up an item.
function BeginPickUpState( targetEntIndex )
{
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_PICKUP_ITEM,
		TargetIndex : targetEntIndex,
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			$.Schedule( 1.0/30.0, tic );
			if ( Entities.IsValidEntity( order.TargetIndex) )
			{
				Game.PrepareUnitOrders( order );
			}
		}	
	})();
}

// Tracks the left-button held state when moving.
function BeginMoveState()
{
	var order = {
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position : [0, 0, 0],
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false
	};
	(function tic()
	{
		if ( GameUI.IsMouseDown( 0 ) )
		{
			$.Schedule( 1.0/30.0, tic );
			var mouseWorldPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition() );
			if ( mouseWorldPos !== null )
			{
				if ( GameUI.IsMouseDown( 1 ) || GameUI.IsMouseDown( 2 ) )
				{
					return;
				}			
				order.Position = mouseWorldPos;
				Game.PrepareUnitOrders( order );
			}
		}
	})();
}

// Handle Left Button events
function OnLeftButtonPressed()
{
	var castAbilityIndex = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 0 );
	var targetIndex = GetMouseCastTarget();
	if ( targetIndex === -1 )
	{
		if ( GameUI.IsShiftDown() )
		{
			BeginAttackState( 0, castAbilityIndex, -1 );
		}
		else
		{
			BeginMoveState();
		}
	}
	else if ( Entities.IsItemPhysical( targetIndex ) )
	{
		BeginPickUpState( targetIndex );
	}
	else
	{
		BeginAttackState( 0, castAbilityIndex, targetIndex );
	}
}

// Handle Right Button events
function OnRightButtonPressed( nMouseButton )
{
	var castAbilityIndex = Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 1 );
	var targetIndex = GetMouseCastTarget();
	if ( targetIndex === -1 )
	{
		BeginAttackState( 1, castAbilityIndex, -1 );
	}
	else if ( Entities.IsItemPhysical( targetIndex ) )
	{
		BeginPickUpState( targetIndex );
	}
	else
	{
		BeginAttackState( 1, castAbilityIndex, targetIndex );
	}
}


// Camera yaw smoothing.
var g_yaw = 0;
var g_targetYaw = 0;
(function smoothCameraYaw()
{
	$.Schedule( 1.0/30.0, smoothCameraYaw );
	while ( g_targetYaw > 360 && g_yaw > 360 )
	{
		g_targetYaw -= 360;
		g_yaw -= 360;
	}
	while ( g_targetYaw < 0 && g_yaw < 0 )
	{
		g_targetYaw += 360;
		g_yaw += 360;
	}

	var minStep = 1;
	var delta = ( g_targetYaw - g_yaw );
	if ( Math.abs( delta ) < minStep )
	{
		g_yaw = g_targetYaw;
	}
	else
	{
		var step = delta * 0.3;
		if ( Math.abs( step ) < minStep )
		{
			if ( delta > 0 )
				step = minStep;
			else
				step = -minStep;
		}
		g_yaw += step;
	}
	GameUI.SetCameraYaw( g_yaw );
	return;
})();


// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {
	var nMouseButton = arg
	var CONSUME_EVENT = true;
	var CONTINUE_PROCESSING_EVENT = false;
	if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
		return CONTINUE_PROCESSING_EVENT;

	if ( eventName === "pressed" )
	{
		// Left-click is move to position or attack
		if ( arg === 0 )
		{
			OnLeftButtonPressed();
			return CONSUME_EVENT;
		}

		// Right-click is use ability #2
		if ( arg === 1 )
		{
			OnRightButtonPressed();
			return CONSUME_EVENT;
		}

		// Middle-click is reset yaw.
		if ( arg === 2 )
		{
			g_targetYaw = 0;
			g_yaw = g_targetYaw;
			return CONSUME_EVENT;
		}
	}

	if ( eventName === "wheeled" )
	{
		g_targetYaw += arg * 10;
		return CONSUME_EVENT;
	}

	if ( eventName === "doublepressed" )
	{
		return CONSUME_EVENT;
	}
	return CONTINUE_PROCESSING_EVENT;
} );

GameUI.SetCameraPitchMax( 55 );
GameUI.SetCameraDistance( 1234 );

// Alternate camera settings
if ( 0 )
{
	GameUI.SetCameraPitchMax( 45 );
	GameUI.SetCameraDistance( 850 );
	GameUI.SetCameraLookAtPositionHeightOffset( 50 );
}

function OnExecuteAbility1ButtonPressed( cmdName )
{
	$.Msg( "ExecuteAbility1 as " + cmdName ); 
	var order = {
		AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 1 ),
		QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
		ShowEffects : false,
		OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
	};
	var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
	if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
	{
		order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
		order.Position = GetMouseCastPosition( order.AbilityIndex );
	}

	Game.PrepareUnitOrders( order );
}

var nParticleIndex = -1;
function OnTestButtonPressed()
{
	$.Msg( "Test button pressed." );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	nParticleIndex = Particles.CreateParticle( "particles/generic_gameplay/generic_stunned.vpcf", ParticleAttachment_t.PATTACH_OVERHEAD_FOLLOW, localHeroIndex );
}

function OnTestButtonReleased()
{
	$.Msg( "Test button released." ); 
	Particles.DestroyParticleEffect( nParticleIndex, true );
}

Game.AddCommand( "CustomGameExecuteAbility1", OnExecuteAbility1ButtonPressed, "", 0 );
Game.AddCommand( "+CustomGameTestButton", OnTestButtonPressed, "", 0 );
Game.AddCommand( "-CustomGameTestButton", OnTestButtonReleased, "", 0 );
