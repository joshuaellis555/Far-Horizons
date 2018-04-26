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
	
	public function new(color:FlxColor) 
	{
		super(color);
		
	}
	override public function create()
	{
		super.create();
		backgroundButton = new Button(FlxG.width, FlxG.height, 0, 0 ,FlxColor.WHITE,this.Clicked,this.RightClicked);
		backgroundButton.alpha = 0;
		add(backgroundButton);
	}
	
	public function Clicked(button:Button):Void 
	{
		
	}
	public function RightClicked(button:Button):Void 
	{
		this.exitMenu();
	}
}