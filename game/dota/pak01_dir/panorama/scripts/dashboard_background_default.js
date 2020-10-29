
var GetCameraName = function ( strPrimaryTabID )
{
    var tabCameras =
    [
        {
            tab_id: "TopBarHome",
            camera_name: "shot_cameraA"
        },
        {
            tab_id: "TopBarHeroes",
            camera_name: "shot_cameraB"
        },
        {
            tab_id: "TopBarStore",
            camera_name: "shot_cameraB"
        },
        {
            tab_id: "TopBarWatch",
            camera_name: "shot_cameraC"
        },
        {
            tab_id: "TopBarLearn",
            camera_name: "shot_cameraD"
        },
        {
            tab_id: "TopBarMods",
            camera_name: "shot_cameraE"
        }
    ];

    for ( var i = 0; i < tabCameras.length; ++i )
    {
        if ( tabCameras[i].tab_id == strPrimaryTabID )
            return tabCameras[i].camera_name;
    }

    // Default
    return "shot_cameraA";
}


var UpdateCamera = function ( strPrimaryTabID )
{
    var strCameraName = GetCameraName( strPrimaryTabID );
    $( "#BackgroundMap" ).LerpToCameraEntity( strCameraName, 1.2 );
};

$.RegisterForUnhandledEvent( 'PageManagerSelectedPrimaryTabChanged', function ( pageManager, strTabID )
{
    UpdateCamera( strTabID );
} );



