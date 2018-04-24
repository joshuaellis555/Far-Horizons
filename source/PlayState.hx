package;

import planets.Planet;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		var planet = new Planet(255, 255);
		add(planet);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}