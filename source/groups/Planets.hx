package groups;

import flixel.FlxG;
import flixel.FlxState;
import planets.Planet;
import resources.ResourceTypes;
/**
 * ...
 * @author JoshuaEllis
 */
class Planets 
{
	public static var members:Array<Planet> = [];
	private static var pID:Int=1000;
	
	public function new(){}
	
	public function add(planet:Planet)
	{
		planet.setID(pID);
		pID++;
		members.push(planet);
		FlxG.state.add(planet);
	}
	
	public function all():Array<Planet>
	{
		return members;
	}
	
	public function upkeep()
	{
		for (planet in members)
		{
			planet.upkeep();
		}
	}
	
	public function updatePlayers()
	{
		for (planet in members)
		{
			planet.reportIncome();
		}
	}
}