package planets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import planets.PlanetMenu;
import player.Player;
import player.Resources;

/**
 * ...
 * @author 
 */
class Planet extends FlxSprite
{
	private var menu:PlanetMenu;
	private var primaryState:FlxState;
	
	public var planetResources:Resources;
	private var owner:Player;
	
	
	
	public function new(x:Int,y:Int,state:FlxState,player:Player,resources:Resources)
	{
		primaryState = state;
		super(x, y);
		super.makeGraphic(100, 100, FlxColor.WHITE);
		this.color=FlxColor.GREEN;
		FlxMouseEventManager.add(this, null, clicked);
		
		owner = player;
		planetResources = resources;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	public function clicked(sprite:FlxSprite):Void
	{
		trace("menu");
		menu = new PlanetMenu(FlxColor.GRAY, this);
		primaryState.openSubState(menu);
	}
	public function getOwner():Player
	{
		return owner;
	}
	public function setOwner(player:Player)
	{
		owner = player;
	}
}