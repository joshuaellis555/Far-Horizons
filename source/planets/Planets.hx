package planets;

import flixel.FlxG;
import flixel.FlxState;
import planets.Planet;
/**
 * ...
 * @author JoshuaEllis
 */
class Planets 
{
	public var members:Array<Planet>;
	
	public function new() 
	{
		members = [];
	}
	public function addPlanet(planet:Planet)
	{
		members.push(planet);
		FlxG.state.add(planet);
	}
	
}