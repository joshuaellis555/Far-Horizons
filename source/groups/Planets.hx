package groups;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import planets.Planet;
import planets.PlanetType;
import player.Player;
import resources.ResourceTypes;
import resources.Resources;
/**
 * ...
 * @author JoshuaEllis
 */
class Planets 
{
	public static var members:Array<Planet> = [];
	private static var pID:Int = 1000;
	
	private static var minScrollX:Float = 0;
	private static var maxScrollX:Float = 0;
	private static var minScrollY:Float = 0;
	private static var maxScrollY:Float = 0;
	
	public function new(){}
	
	public function add(planet:Planet)
	{
		planet.setID(pID);
		pID++;
		members.push(planet);
		FlxG.state.add(planet);
		if (minScrollX > planet.x - FlxG.width/1)
			minScrollX = planet.x - FlxG.width/1;
		if (maxScrollX < planet.x + FlxG.width/2.5)
			maxScrollX = planet.x + FlxG.width/2.5;
		if (minScrollY > planet.y - FlxG.height/1)
			minScrollY = planet.y - FlxG.height/1;
		if (maxScrollY < planet.y + FlxG.height/2.5)
			maxScrollY = planet.y + FlxG.height / 2.5;
		/*
		FlxG.cameras.list[2].setScrollBounds(minScrollX, maxScrollX, minScrollY, maxScrollY);
		FlxG.cameras.list[1].setScrollBounds(minScrollX / 40, maxScrollX / 40, minScrollY / 40, maxScrollY / 40);
		maxZ = Math.max(FlxG.width / (maxScrollX - minScrollX-FlxG.width/1.5), FlxG.height / (maxScrollY - minScrollY-FlxG.height/1.5));*/
	}
	public function getCameraBounds():Array<Float>{
		return [minScrollX,maxScrollX,minScrollY,maxScrollY];
	}
	
	public function upgrade(planet:Planet,type:FlxColor)
	{
		var cost:Resources = planet.getUpgradeCost(type);
		
		if (planet.getOwner().resources.remove(cost)){
			switch (type)
			{	//							O,P,S,C,M
				case ResourceTypes.Organic:{
					planet.resources.add(new Resources([1,0,0,0,0]));
				}
				case ResourceTypes.Productivity:{
					planet.resources.add(new Resources([0,1,0,0,0]));
				}
				case ResourceTypes.Science:{
					planet.resources.add(new Resources([0,0,1,0,0]));
				}
				case ResourceTypes.Credits:{
					planet.resources.add(new Resources([0,0,0,1,0]));
				}
				case ResourceTypes.Materials:{
					planet.resources.add(new Resources([-1,0,0,0,1]));
					if (planet.resources.get(ResourceTypes.Organic) == 0)
						planet.resources.setResource(ResourceTypes.Organic, null);
				}
				default:null;
			}
		}
		
		planet.updateStatsImg();
		planet.getOwner().updateIncome();
	}
	
	public function addRandom(x:Int, y:Int, size:Int, type:PlanetType, player:Player):Planet
	{
		var resources:Resources = new Resources([]);
		switch (type)
		{	//										O		,P	  ,S	,C	  ,M
			case GREEN: resources = new Resources([vhigh(),low(),med(),low(),low()]);
			case BLUE: resources = new Resources([low(),vhigh(),vlow(),med(),med()]);
			case WHITE: resources = new Resources([low(),med(),high(),med(),med()]);
			case ORANGE: resources = new Resources([low(),high(),low(),vhigh(),med()]);
			case GRAY: resources = new Resources([vlow(),med(),vlow(),med(),vhigh()]);
			case PURPLE: resources = new Resources([med()+2, high()+2, med()+2, high()+2, med()+2]);
			default:trace("default", type);
		}
		
		if (resources.get(ResourceTypes.Credits) < 1) resources.setResource(ResourceTypes.Credits, 1);
		for (j in 0...5){
			if (resources.get(ResourceTypes.types[j]) < 1)
				resources.setResource(ResourceTypes.types[j], null);
		}
		
		var planet:Planet = new Planet(x, y, size, cast type, player, resources);
		
		return planet;
	}
	private function vhigh():Int{return Std.random(12) + 7; }
	private function high():Int{return Std.random(9) + 3; }
	private function med():Int{return Std.random(7) - 1; }
	private function low():Int{return Std.random(6) -2; }
	private function vlow():Int{return Std.random(5) -3; }
	
	
	public function all():Array<Planet>
	{
		return members;
	}
	
	public function upkeep()
	{
		for (planet in members)
		{
			planet.upkeep();
			planet.grow();
			planet.updateStatsImg();
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