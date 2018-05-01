package;

import observer.Event;
import observer.Subject;
import planets.Planet;
import flixel.FlxState;
import player.Player;
import player.Resources;

class PlayState extends FlxState
{
	public var activePlayer:Player;
	
	override public function create():Void
	{
		trace("play");
		super.create();
		
		activePlayer = new Player();
		
		var planet = new Planet(255, 255,this,activePlayer, new Resources(100,100,100,100,100));
		add(planet);
		
		var planet = new Planet(455, 155,this,activePlayer, new Resources(-100,-100,-100,-100,-100));
		add(planet);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}