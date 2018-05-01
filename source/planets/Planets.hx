package planets;

import flixel.FlxState;
import planets.Planet;
/**
 * ...
 * @author JoshuaEllis
 */
class Planets 
{
	public var members:Array<Planet>;
	private var playState:FlxState;
	
	public function new(play) 
	{
		members = [];
		playState = play;
	}
	public function addPlanet(planet:Planet)
	{
		members.push(planet);
		playState.add(planet);
	}
	
}