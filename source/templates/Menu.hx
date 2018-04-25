package templates;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Menu extends FlxSubState
{
	private var priorState:FlxState;
	public function new(state:FlxState) 
	{
		super(FlxColor.GRAY);
		priorState = state;
	}
	
	private function switchBack()
	{
		FlxG.switchState(priorState);
		
	}
	
}