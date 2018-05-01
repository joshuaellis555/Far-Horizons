package;

import button.Button;
import event.Event;
import event.EventType;
import event.MouseEvent;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxG;
import flixel.util.FlxColor;
import observer.Observer;
import observer.Subject;
import planets.Planet;
import flixel.FlxState;
import planets.Planets;
import player.Player;
import resources.Resources;

class PlayState extends FlxState implements Observer
{
	public var activePlayer:Player;
	
	private var planets:Planets;
	
	override public function create():Void
	{
		trace("play");
		super.create();
		
		activePlayer = new Player();
		
		var background = new Button(FlxG.width, FlxG.height, 0, 0 , FlxColor.BLACK,this);
		add(background);
		
		planets = new Planets(this);
		
		var planet = new Planet(255, 255,FlxColor.GREEN,this,activePlayer, new Resources(100,100,100,100,100));
		planets.addPlanet(planet);
		
		var planet = new Planet(455, 155,FlxColor.GREEN,this,activePlayer, new Resources(0,0,0,0,0));
		planets.addPlanet(planet);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void 
	{
		switch(event.eventType){
			case Mouse:{
				var m:MouseEvent = cast event;
				for (mouseEvent in m.mouseEvents)
				{
					switch(mouseEvent)
					{
						case RightJustReleased:{
							trace("upkeep");
							for (planet in planets.members)
							{
								planet.upkeep();
							}
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}