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
	private var originX:Float=0;
	private var originY:Float=0;
	
	override public function create():Void
	{
		trace("play");
		super.create();
		
		activePlayer = new Player();
		
		var background = new Button(FlxG.width*10, FlxG.height*10, -FlxG.width*5, -FlxG.height*5 , FlxColor.BLACK,this);
		add(background);
		
		planets = new Planets(this);
		
		var planet = new Planet(Std.int(FlxG.width/2), Std.int(FlxG.height/2),100,FlxColor.GREEN,this,activePlayer, new Resources(100,100,100,100,100));
		planets.addPlanet(planet);
		
		var planet = new Planet(0, 0,60,FlxColor.BROWN,this,activePlayer, new Resources(0,0,0,0,0));
		planets.addPlanet(planet);
		var planet = new Planet(FlxG.width, 0,60,FlxColor.BROWN,this,activePlayer, new Resources(0,0,0,0,0));
		planets.addPlanet(planet);
		var planet = new Planet(0, FlxG.height,60,FlxColor.BROWN,this,activePlayer, new Resources(0,0,0,0,0));
		planets.addPlanet(planet);
		var planet = new Planet(FlxG.width, FlxG.height,60,FlxColor.BROWN,this,activePlayer, new Resources(0,0,0,0,0));
		planets.addPlanet(planet);
		
		FlxG.camera.zoom = 0.9;
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.wheel != 0)
		{
			FlxG.camera.zoom = Math.min(Math.max(0.05, FlxG.camera.zoom+(FlxG.mouse.wheel / 20)),0.9);
		}
		var x:Float = Std.int((FlxG.mouse.screenX + FlxG.camera.x)*FlxG.camera.zoom);
		var y:Float = Std.int((FlxG.mouse.screenY + FlxG.camera.y)*FlxG.camera.zoom);
		trace("origin", originX, originY, "mouse", FlxG.mouse.x, FlxG.mouse.y, "x,y", x, y , FlxG.camera.zoom);
		
		if (FlxG.mouse.justPressedMiddle)
		{
			originX += x;
			originY += y;
		}
		if (FlxG.mouse.pressedMiddle)
		{	
			FlxG.camera.x = Std.int((x-originX ));
			FlxG.camera.y = Std.int((y-originY ));
		}
		if (FlxG.mouse.justReleasedMiddle)
		{
			originX -= x;
			originY -= y;
		}
		
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