package planets;

import event.EventType;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import button.Button;
import event.Event;
import event.MouseEvent;
import event.MouseEventType;
import observer.Observer;
import observer.Subject;
import resources.ResourceTypes;
import resources.Resources;
import templates.Menu;

/**
 * ...
 * @author ...
 */
class PlanetMenu extends Menu implements Observer
{
	private var background:Button;
	private var color:FlxColor;
	private var alpha:Float;
	
	private var menuSubject:Subject;
	private var myPlanet:Planet;
	
	public var upgradeIcons:Map<FlxColor, FlxSprite>;
	
	public function new(color:FlxColor,alpha:Float,planet:Planet)
	{
		menuSubject = new Subject(planet);
		myPlanet = planet;
		this.color = color;
		this.alpha = alpha;
		super(FlxColor.TRANSPARENT);
	}
	override public function create()
	{
		super.create();
		background = new Button(FlxG.width, FlxG.height, 0, 0 , color, this,FlxG.cameras.list[3]);
		background.alpha = alpha;
		add(background);
		
		FlxG.cameras.list[4].scroll.set(myPlanet.x+myPlanet.size/2-FlxG.width/2, myPlanet.y+myPlanet.size/2-FlxG.height/2);
		
		myPlanet.cameras.push(FlxG.cameras.list[4]);
		for (key in myPlanet.planetResources.types())
			myPlanet.statsImgs[key].cameras.push(FlxG.cameras.list[4]);
			
		upgradeIcons = [for (key in  ResourceTypes.types) key => new FlxSprite()];
		var rTypes:Array<FlxColor> = ResourceTypes.types;
		
		for (i in 0...ResourceTypes.types.length)
		{
			upgradeIcons[rTypes[i]].loadGraphic(AssetPaths.Icons__jpg, true, 52, 52);
			upgradeIcons[rTypes[i]].camera = FlxG.cameras.list[5];
			///*
			upgradeIcons[rTypes[i]].offset.x = 26;
			upgradeIcons[rTypes[i]].offset.y = 26;
			//*/
			/*
			upgradeIcons[rTypes[i]].origin.x = 26;
			upgradeIcons[rTypes[i]].origin.y = 26;
			//*/
			upgradeIcons[rTypes[i]].antialiasing = true;
			upgradeIcons[rTypes[i]].visible = false;
			FlxG.state.add(upgradeIcons[rTypes[i]]);
			upgradeIcons[rTypes[i]].animation.add(Std.string(rTypes[i]), [i], 1, false);
		}
		var NofResources:Int = myPlanet.planetResources.types().length;
		var pTypes:Array<FlxColor> = myPlanet.planetResources.types();
		var screenCenter:FlxPoint = new FlxPoint(FlxG.width/2, FlxG.height/2);
		for (i in 0...NofResources){
			var iconPosition:FlxPoint = new FlxPoint(screenCenter.x,screenCenter.y);
			iconPosition.add(0, 190).rotate(screenCenter, (i) / NofResources * 360 +180);
			upgradeIcons[pTypes[i]].setPosition(iconPosition.x, iconPosition.y);
			upgradeIcons[pTypes[i]].animation.play(Std.string(pTypes[i]));
			upgradeIcons[pTypes[i]].visible = true;
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
						case LeftJustReleased:{
							trace("pay");
							menuSubject.notify(new ResourceEvent(new Resources([for (i in 0...ResourceTypes.types.length) 1]),ResourceEventType.Gain));
						}
						case RightJustReleased:{
							trace("close");
							myPlanet.unlock();
							myPlanet.cameras.pop();
							for (key in myPlanet.planetResources.types())
								myPlanet.statsImgs[key].cameras.pop();
							for (key in ResourceTypes.types)
								FlxG.state.remove(upgradeIcons[key]);
							close();
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}