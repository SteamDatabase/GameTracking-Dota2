
var http = require('http');
var express = require('express');
var fs = require('fs');
var path = require('path');
var bodyParser = require('body-parser');
var dateformat = require('dateformat');

var app = express();
console.log( "setting static to " + __dirname + "/public" );
app.use( express.static( 'public' ) );
app.use( bodyParser.json() );


const PORT=8081;
app.listen( PORT );

console.log( "\ndata will be POSTed to:" );
console.log( "=======================" );
console.log( "	http://localhost:" + PORT + "/upload" );

console.log( "\nendpoints:" );
console.log( "==========" );
console.log( "	http://localhost:" + PORT + "/admin" );
console.log( "	http://localhost:" + PORT + "/json" );

var jsonData = "<no data>";

app.get( "/json", function( req, res ) {

	res.writeHead(200, {'Content-Type': 'application/json'});
	res.write( jsonData );
	res.end();
});

app.get( "/admin", function( req, res ) {
	res.sendFile( path.join( __dirname + '/admin.html' ) );
});

app.post( "/upload", function( req, res ) {

	console.log( "(" + dateformat("h:MM:ss::L") + ") got a post to upload" );

	jsonData = JSON.stringify( req.body );

	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('Got POST Data');
});