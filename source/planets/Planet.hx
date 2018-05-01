package planets;
import button.Button;
import event.EventType;
import event.MouseEventType;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import event.Event;
import event.MouseEvent;
import observer.Observer;
import observer.Subject;
import planets.PlanetMenu;
import player.Player;
import resources.Resources;

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
	
	private var resourceSubject:Subject;
	
	public function new(x:Int,y:Int,color:FlxColor,state:FlxState,player:Player,resources:Resources)
	{
		primaryState = state;
		super(100,100,x, y,color,this);
		
		owner = player;
		planetResources = resources;
		resourceSubject = new Subject(owner);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	public function getOwner():Player
	{
		return owner;
	}
	public function setOwner(player:Player)
	{
		owner = player;
		resourceSubject = new Subject(owner);
	}
	public function upkeep()
	{
		resourceSubject.notify(new ResourceEvent(planetResources, ResourceEventType.Gain));
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
						case MouseEventType.LeftJustClicked:{
							trace("menu");
							menu = new PlanetMenu(FlxColor.GRAY, this);
							primaryState.openSubState(menu);
						}
						default:null;
					}
				}
			}
			case Resource:{
				var resourceEvent:ResourceEvent = cast event;
				switch(resourceEvent.transactionType)
				{
					case Gain:{
						trace("Gain");
						planetResources.add(resourceEvent.resources);
					}
					case Lose:{
						trace("Lose");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(planetResources.remove(resourceEvent.resources));
						}else{
							planetResources.remove(resourceEvent.resources);
						}
					}
					case LoseNoCheck:{
						trace("LoseNoCheck");
						planetResources.remove(resourceEvent.resources,false);
					}
					case Check:{
						trace("Check");
						if (resourceEvent.returnCall!=null){
							resourceEvent.returnCall(planetResources.check(resourceEvent.resources));
						}
					}
					default:null;
				}
			}
			default:null;
		}
		trace(planetResources);
	}
}