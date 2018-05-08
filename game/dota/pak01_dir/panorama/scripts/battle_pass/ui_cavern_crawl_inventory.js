
var OnItemAdded = function ( id, count )
{
	var seq = new RunSequentialActions();

	var panel = $('#' + id);

	seq.actions.push( new AddClassAction( panel, 'AddingItem' ) );
	seq.actions.push( new RemoveClassAction( panel, 'Empty' ) );

	seq.actions.push( new WaitAction( 0.5 ) );

	seq.actions.push( new RemoveClassAction( panel, 'AddingItem' ) );
	seq.actions.push( new RunFunctionAction( function ()
	{
		panel.SetDialogVariableInt( "count", count );
	} ) );

	RunSingleAction( seq );
}

var OnItemRemoved = function ( id, count )
{
    var seq = new RunSequentialActions();

    var panel = $('#' + id);

    seq.actions.push( new AddClassAction( panel, 'RemovingItem' ) );

    seq.actions.push( new WaitAction( 0.5 ) );

    seq.actions.push( new RemoveClassAction( panel, 'RemovingItem' ) );

    seq.actions.push(new RunFunctionAction(function ()
    {
    	panel.SetDialogVariableInt( "count", count );
    	if ( count == 0 )
    	{
    		panel.AddClass( "Empty" );
    	}
    }));

    RunSingleAction(seq);
}
