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
	
	private var planetCam:FlxCamera;
	
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
		
		planetCam = new FlxCamera(0,0,FlxG.width,FlxG.height);
		planetCam.bgColor = FlxColor.TRANSPARENT;
		planetCam.scroll.set(myPlanet.x+myPlanet.size/2-FlxG.width/2, myPlanet.y+myPlanet.size/2-FlxG.height/2);
		planetCam.antialiasing = true;
		
		FlxG.cameras.add(planetCam);
		
		myPlanet.cameras.push(planetCam);
		for (key in myPlanet.planetResources.types())
			myPlanet.statsImgs[key].cameras.push(planetCam);
			
		
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
							FlxG.cameras.remove(planetCam);
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