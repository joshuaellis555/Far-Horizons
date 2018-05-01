package planets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import button.Button;
import observer.Event;
import observer.MouseEvent;
import observer.MouseEventType;
import observer.Observer;
import templates.Menu;
import button.ButtonTriggers;

/**
 * ...
 * @author ...
 */
class PlanetMenu extends Menu implements Observer
{
	private var background:Button;
	private var color:FlxColor;
	
	private var myPlanet:Planet;
	
	public function new(c:FlxColor,planet:Planet)
	{
		myPlanet = planet;
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
		for (mouseEvent in cast(event, MouseEvent).mouseEvents)
		{
			switch(mouseEvent)
			{
				case LeftJustReleased:{
					trace("pay");
					myPlanet.getOwner().charge(myPlanet.planetResources);
					trace(myPlanet.getOwner().playerResources);
				}
				case RightJustReleased:{
					trace("close");
					close();
				}
				default:null;
			}
		}
	}
}