package planets;

import event.EventType;
import event.ResourceEvent;
import event.ResourceEventType;
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
	
	private var myPlanet:Subject;
	
	public function new(c:FlxColor,planet:Planet)
	{
		myPlanet = new Subject(planet);
		color = c;
		super(FlxColor.RED);
	}
	override public function create()
	{
		super.create();
		background = new Button(FlxG.width, FlxG.height, 0, 0 , color,this);
		add(background);
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
							myPlanet.notify(new ResourceEvent(new Resources(1,1,1,1,1),ResourceEventType.Gain));
						}
						case RightJustReleased:{
							trace("close");
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