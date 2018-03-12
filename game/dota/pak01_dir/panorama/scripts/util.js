
function Clamp( num, min, max )
{
	return num <= min ? min : ( num >= max ? max : num );
}
function Lerp( percent, a, b )
{
	return a + percent * ( b - a );
}
function RemapVal( num, a, b, c, d )
{
	if ( a == b )
		return c;

	var percent = ( num - a ) / ( b - a );
	return Lerp( percent, c, d );
}
function RemapValClamped( num, a, b, c, d )
{
	if ( a == b )
		return c;

	var percent = ( num - a ) / ( b - a );
	percent = Clamp( percent, 0.0, 1.0 );

	return Lerp( percent, c, d );
}
