package planets;

import arbiters.Arbiters;
import event.EventType;
import event.MerchantEvent;
import event.MerchantEventType;
import event.ResourceEvent;
import event.ResourceEventType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import button.Button;
import event.Event;
import event.MouseEvent;
import event.MouseEventType;
import observer.Observer;
import observer.Subject;
import resources.ResourceTypes;
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
	private var alpha:Float;
	
	private var menuSubject:Subject;
	private var myPlanet:Planet;
	
	public var upgradeIcons:Map<FlxColor, Button>;
	
	public function new(color:FlxColor,alpha:Float,planet:Planet)
	{
		menuSubject = new Subject([planet,Arbiters.merchant]);
		myPlanet = planet;
		this.color = color;
		this.alpha = alpha;
		super(FlxColor.TRANSPARENT);
	}
	override public function create()
	{
		super.create();
		trace("menu");
		background = new Button(FlxG.width, FlxG.height, 0, 0 , color, this, 99, FlxG.cameras.list[3]);
		background.alpha = alpha;
		add(background);
		
		FlxG.cameras.list[4].scroll.set(myPlanet.x + myPlanet.size / 2 - FlxG.width/2, myPlanet.y + myPlanet.size / 2 - FlxG.height / 2);
		//trace(FlxG.cameras.list[4].scroll);
		
		myPlanet.cameras.push(FlxG.cameras.list[4]);
		for (key in myPlanet.resources.types())
			myPlanet.statsImgs[key].cameras.push(FlxG.cameras.list[4]);
		
	// ######### icons ############
		upgradeIcons = new Map<FlxColor, Button>(); 
		var rTypes:Array<FlxColor> = ResourceTypes.types;
		
		for (i in 0...ResourceTypes.types.length)
		{
			upgradeIcons[rTypes[i]] = new Button(0, 0, 0, 0, FlxColor.WHITE, this, i, FlxG.cameras.list[5], false, false, AssetPaths.Icons__png, true, 52, 52);
			
			upgradeIcons[rTypes[i]].antialiasing = true;
			upgradeIcons[rTypes[i]].visible = false;
			
			
			upgradeIcons[rTypes[i]].animation.add(Std.string(rTypes[i]), [i], 1, false);
			upgradeIcons[rTypes[i]].animation.play(Std.string(rTypes[i]));
		}
		
		var NofResources:Int = myPlanet.resources.types().length;
		var pTypes:Array<FlxColor> = myPlanet.resources.types();
		var screenCenter:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
		
		for (i in 0...NofResources){
			var iconPosition:FlxPoint = new FlxPoint(screenCenter.x,screenCenter.y);
			iconPosition.add(0, 190).rotate(screenCenter, (i) / NofResources * 360 +180);
			upgradeIcons[pTypes[i]].setPosition(iconPosition.x-26, iconPosition.y-26);
			
			upgradeIcons[pTypes[i]].visible = true;
			upgradeIcons[pTypes[i]].updateHitbox();
			
			add(upgradeIcons[pTypes[i]]);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//FlxG.cameras.list[5].scroll.set(myPlanet.x + myPlanet.size / 2 - FlxG.width / 2, myPlanet.y + myPlanet.size / 2 - FlxG.height / 2);
		//trace(FlxG.cameras.list[5].scroll,"planet menu");
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
							trace("upgrade");
							var type:Int = event.eventSource;
							if (type < ResourceTypes.types.length){
								//menuSubject.notify(new ResourceEvent(menuSubject, new Resources([for (i in 0...ResourceTypes.types.length) i == id ? 1 : null]), ResourceEventType.Gain));
								var upgrade:Resources = new Resources([for (i in 0...ResourceTypes.types.length) i == type ? 1 : null]);
								var cost:Resources = new Resources([for (i in 0...ResourceTypes.types.length) i == type ? myPlanet.resources.get(ResourceTypes.types[type])+1 : null]);
								if (menuSubject.notify(new MerchantEvent(menuSubject, MerchantEventType.Charge, [myPlanet.getOwner()], [cost]))[0])
									menuSubject.notify(new MerchantEvent(menuSubject, MerchantEventType.Pay, [myPlanet], [upgrade]));
								myPlanet.getOwner().updateIncome();
							}
						}
						case RightJustReleased:{
							if (event.eventSource == 99)
							{
								trace("close");
								myPlanet.unlock();
								myPlanet.cameras.pop();
								for (key in myPlanet.resources.types())
									myPlanet.statsImgs[key].cameras.pop();
								//myPlanet.updatePlayers();
								//myPlanet.getOwner().updateIncome();
								close();
							}
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}