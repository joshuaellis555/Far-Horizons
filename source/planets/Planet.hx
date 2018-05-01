package planets;
import button.Button;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import observer.Event;
import observer.MouseEvent;
import observer.Observer;
import planets.PlanetMenu;
import player.Player;
import player.Resources;

/**
 * ...
 * @author 
 */
class Planet extends Button implements Observer
{
	private var menu:PlanetMenu;
	private var primaryState:FlxState;
	
	public var planetResources:Resources;
	private var owner:Player;
	
	
	
	public function new(x:Int,y:Int,state:FlxState,player:Player,resources:Resources)
	{
		primaryState = state;
		super(100,100,x, y,FlxColor.GREEN,this);
		
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
	
	/* INTERFACE observer.Observer */
	
	public function onNotify(event:Event):Void 
	{
		for (mouseEvent in cast(event, MouseEvent).mouseEvents)
		{
			switch(mouseEvent)
			{
				case LeftJustReleased:{
					trace("menu");
					menu = new PlanetMenu(FlxColor.GRAY, this);
					primaryState.openSubState(menu);
				}
				default:null;
			}
		}
	}
}