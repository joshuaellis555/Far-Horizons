package planets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import templates.Button;
import templates.Menu;
import templates.ButtonTriggers;

/**
 * ...
 * @author ...
 */
class PlanetMenu extends Menu implements ButtonTriggers
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
	public function Clicked(button:Button):Void 
	{
		if (FlxG.mouse.justReleased){
			trace("pay");
			myPlanet.getOwner().charge(myPlanet.planetResources);
			trace(myPlanet.getOwner().playerResources);
		}
		else if (FlxG.mouse.justReleasedRight)
		{
			trace("close");
			close();
		}
		
	}
	public function RightClicked(button:Button):Void 
	{
		
	}
}