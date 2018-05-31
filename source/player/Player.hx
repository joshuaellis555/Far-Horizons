package player;

import event.Event;
import observer.Observer;
import observer.Subject;
import groups.Players;
import planets.Planet;
import resources.ResourceEnabled;
import resources.ResourceTypes;
import resources.Resources;

/**
 * ...
 * @author ...
 */
class Player implements ResourceEnabled
{
	public var income:Resources = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
	private var incomeSources:Map<Int,Resources>=new Map<Int,Resources>();
	
	public var resources:Resources;
	
	public var ownedPlanets:Array<Planet> = [];
	
	private var id:Int;
	
	public function new(resources:Resources) 
	{
		this.resources = resources;
		
		var players:Players = new Players();
		players.add(this);
	}
	public function updateIncome()
	{
		income = new Resources([0, 0, 0, 0, 0, 0, 0, 0]);
		for (key in incomeSources.keys())
		{
			income.add(incomeSources[key]);
		}
		
	}
	public function reportIncome(planet:Planet)
	{
		incomeSources[planet.getID()] = planet.resources;
	}
	public function getID():Int
	{
		return id;
	}
	public function setID(newID:Int)
	{
		id = newID;
	}
}