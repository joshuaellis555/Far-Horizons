package;

import button.Button;
import event.Event;
import event.EventType;
import event.MouseEvent;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import observer.Observer;
import observer.Subject;
import planets.Planet;
import flixel.FlxState;
import planets.PlanetType;
import planets.Planets;
import player.Player;
import resources.Resources;

class PlayState extends FlxState implements Observer
{
	public var activePlayer:Player;
	
	private var planets:Planets;
	private var originX:Float = 0;
	private var originY:Float = 0;
	
	var mapCam:FlxCamera; //The camera that renders the tilemap being drawn
	var uiCam:FlxCamera; //The camera that renders the UI elements
	var bgCam:FlxCamera; //The camera that renders background elements
	
	var grabbedPos:FlxPoint = new FlxPoint( -1, -1); //For camera scrolling
	var initialScroll:FlxPoint = new FlxPoint(0, 0); //Ditto ^
	
	var img:FlxSprite;
	
	override public function create():Void
	{
		trace("play");
		super.create();
		
		activePlayer = new Player();
		
		mapCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		mapCam.bgColor = FlxColor.TRANSPARENT;
		mapCam.antialiasing = true;
		
		bgCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		bgCam.antialiasing = true;
		
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCam.bgColor = FlxColor.TRANSPARENT;
		uiCam.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		uiCam.antialiasing = true;
		
		FlxG.camera.antialiasing = true;
		
		FlxG.cameras.add(bgCam);
		FlxG.cameras.add(mapCam);
		FlxG.cameras.add(uiCam);
		
		var background = new Button(FlxG.width*4, FlxG.height*4, Std.int(-FlxG.width*2), Std.int(-FlxG.height*2) , FlxColor.BLACK,this,bgCam,AssetPaths.Stars__png, 4096, 2304);
		add(background);
		
		planets = new Planets();
		
		var planet = new Planet(Std.int(FlxG.width/2), Std.int(FlxG.height/2),200,PlanetType.GREEN,activePlayer, new Resources([13,2,8,0,7]));
		planets.addPlanet(planet);
		
		var planet = new Planet(0, 0,140,PlanetType.RED,activePlayer, new Resources([11,null,6,2,null]));
		planets.addPlanet(planet);
		var planet = new Planet(FlxG.width, 0,140,PlanetType.PURPLE,activePlayer, new Resources([7,14,null,null,null]));
		planets.addPlanet(planet);
		var planet = new Planet(0, FlxG.height,140,PlanetType.BLUE,activePlayer, new Resources([7,15,null,4,1]));
		planets.addPlanet(planet);
		var planet = new Planet(FlxG.width, FlxG.height,140,PlanetType.GRAY,activePlayer, new Resources([null,null,7,null,null]));
		planets.addPlanet(planet);
		
		mapCam.zoom = 1;
		bgCam.zoom = (mapCam.zoom + 39) /60;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.wheel != 0)
		{
			mapCam.zoom = Math.min(Math.max(0.1, mapCam.zoom + (FlxG.mouse.wheel / Math.abs(FlxG.mouse.wheel) * mapCam.zoom / 4)), 1);
			bgCam.zoom = (mapCam.zoom + 39) / 60;
			if (FlxG.mouse.wheel>0){
				var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
				mapCam.scroll.subtractPoint(mousePosChange);
				bgCam.scroll.subtract(mousePosChange.x/40,mousePosChange.y/40);
			}
		}
		
		if (!FlxG.mouse.pressedMiddle || FlxG.mouse.justPressedMiddle){
			grabbedPos = FlxG.mouse.getWorldPosition(mapCam);
		}else{
			var mousePosChange:FlxPoint = FlxG.mouse.getWorldPosition(mapCam).subtractPoint(grabbedPos);
			mapCam.scroll.subtractPoint(mousePosChange);
			bgCam.scroll.subtract(mousePosChange.x / 40, mousePosChange.y / 40);
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