package planets;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import templates.Button;
import templates.Menu;

/**
 * ...
 * @author ...
 */
class PlanetMenu extends Menu 
{
	private var backgroundButton:Button;
	
	public function new(state:FlxState) 
	{
		super(state);
		//backgroundButton = new Button(640, 480, 0, 0 ,FlxColor.WHITE,this.Clicked,this.RightClicked);
		//backgroundButton.alpha = 0;
		trace("loaded");
	}
	public function foo():Void{}
	
	public function Clicked(button:Button):Void 
	{
		
	}
	public function RightClicked(button:Button):Void 
	{
		trace("right");
		if (FlxG.mouse.justReleasedRight){
			this.switchBack();
		}
	}
}