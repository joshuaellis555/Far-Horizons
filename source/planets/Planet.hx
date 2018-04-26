package planets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import planets.PlanetMenu;
import flixel.FlxState;

/**
 * ...
 * @author 
 */
class Planet extends FlxSprite
{
	private var menu:PlanetMenu;
	private var parent:FlxState;
	public function new(x:Int,y:Int,play:FlxState)
	{
		super(x, y);
		parent = play;
		super.makeGraphic(100, 100, FlxColor.WHITE);
		this.color=FlxColor.GREEN;
		FlxMouseEventManager.add(this, null, clicked);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function clicked(sprite:FlxSprite):Void
	{
		menu = new PlanetMenu(FlxColor.GRAY);
		parent.openSubState(menu);
	}
}