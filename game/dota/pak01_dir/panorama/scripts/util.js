//@ts-check

/**
 * @param {number} num 
 * @param {number} min 
 * @param {number} max 
 * @returns {number}
 */
function Clamp( num, min, max )
{
	return num <= min ? min : ( num >= max ? max : num );
}
/**
 * @param {number} percent 
 * @param {number} a 
 * @param {number} b 
 * @returns {number}
 */
function Lerp( percent, a, b )
{
	return a + percent * ( b - a );
}

/**
 * @param {number} num 
 * @param {number} a 
 * @param {number} b 
 * @param {number} c 
 * @param {number} d 
 * @returns {number}
 */
function RemapVal( num, a, b, c, d )
{
	if ( a == b )
		return c;

	var percent = ( num - a ) / ( b - a );
	return Lerp( percent, c, d );
}

/**
 * @param {number} num 
 * @param {number} a 
 * @param {number} b 
 * @param {number} c 
 * @param {number} d 
 * @returns {number}
 */
function RemapValClamped( num, a, b, c, d )
{
	if ( a == b )
		return c;

	var percent = ( num - a ) / ( b - a );
	percent = Clamp( percent, 0.0, 1.0 );

	return Lerp( percent, c, d );
}

/**
 * @template {string | number} K
 * @template V
 * @param {V[]} arr 
 * @param {function(V, number, V[]): K} key 
 * @returns {Record<K, V>}
 */
function ToMap( arr, key )
{
	/** @type {Record<string | number, V>} */
	var map = {};
	arr.forEach( ( v, i ) => map[key( v, i, arr )] = v );
	return map;
}

