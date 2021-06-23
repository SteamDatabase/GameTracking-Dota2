"use strict";


//------------- LISTENER ------------------------------------------------------------------
var serverConstants = CustomNetTables.GetTableValue( 'globals', 'constants' );
var serverValues = CustomNetTables.GetTableValue( 'globals', 'values' );
CustomNetTables.SubscribeNetTableListener( "globals", function ( table_name, key, data )
{
	if ( key == 'constants' )
	{
		serverConstants = data;
	}
	else if ( key == 'values' )
	{
		serverValues = data;
	}
} );


//------------- LISTENER ------------------------------------------------------------------

///// Game State /////

var mapStateTowers = CustomNetTables.GetTableValue( 'mapstate', 'towers' );
var mapStateLanes = CustomNetTables.GetTableValue( 'mapstate', 'lanes' );
CustomNetTables.SubscribeNetTableListener( "mapstate", function ( table_name, key, data )
{
	var bChanged = false;
	if ( key == 'towers' )
	{
		mapStateTowers = data;
		bChanged = true;
	}
	if ( key == 'lanes' )
	{
		mapStateLanes = data;
		bChanged = true;
	}

	if ( bChanged )
	{
		OnMapStateChanged();  // function is defined in the javascript file using this shared code
	}
} );


//-----------------------------------------------------------------------------------------

//// Utility functions

function objectValues( obj )
{
	return Object.keys( obj ).map( key => obj[ key ] );
}

function objectForEach( obj, fn ) // fn is ( key, value, index )
{
	Object.keys( obj ).forEach( ( key, index ) => fn( key, obj[ key ], index ) );
}

function arraySum( array, fn ) // fn is ( value, index ) => number
{
	var s = 0;
	var f = fn ? fn : n => n;
	array.forEach( ( value, index ) => s += f( value, index ) );
	return s;
}

function angle2d( vec1, vec2 )
{
    return Math.atan2( vec2[ 1 ] - vec1[ 1 ], vec2[ 0 ] - vec1[ 0 ] ) * 180 / Math.PI;
}
