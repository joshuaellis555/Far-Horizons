package planets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import planets.PlanetMenu;

/**
 * ...
 * @author 
 */
class Planet extends FlxSprite
{
	private var menu:PlanetMenu;
	public function new(x:Int,y:Int)
	{
		super(x, y);
		super.makeGraphic(100, 100, FlxColor.WHITE);
		this.color=FlxColor.GREEN;
		FlxMouseEventManager.add(this, clicked);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function clicked(sprite:FlxSprite):Void
	{
		menu = new PlanetMenu(FlxG.state);
		FlxG.switchState(menu);
	}
}