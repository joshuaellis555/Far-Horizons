package planets;

import event.EventType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.text.FlxText;
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
	private var menuSubject:Subject;
	private var myPlanet:Planet;
	
	public var upgradeIcons:Map<FlxColor, Button>;
	
	private var costText:Map<FlxColor,FlxText> = new Map<FlxColor,FlxText>();
	private var popText:FlxText;
	
	public function new(color:FlxColor,alpha:Float,planet:Planet)
	{
		menuSubject = new Subject([planet]);
		myPlanet = planet;
		super(color,alpha,this);
	}
	override public function create()
	{
		super.create();
		
		FlxG.cameras.list[4].scroll.set(myPlanet.x + myPlanet.size / 2 - FlxG.width/2, myPlanet.y + myPlanet.size / 2 - FlxG.height / 2);
		
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
			
			costText[rTypes[i]] = new FlxText(54 + i * 128, 50, 74, null, 20, true);
			costText[rTypes[i]].color = FlxColor.RED;
			costText[rTypes[i]].cameras = [FlxG.cameras.list[6]];
			add(costText[rTypes[i]]);
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
		
		popText = new FlxText(FlxG.width/2-250,FlxG.height-50, 500,"Pop. "+Std.string(myPlanet.population())); // x, y, width
		popText.setFormat(null, 30, FlxColor.WHITE, CENTER);
		popText.cameras = [FlxG.cameras.list[5]];
		add(popText);
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
							var type:Int = event.eventSource;
							if (type < ResourceTypes.types.length){
								
								if (ResourceTypes.types[type] == ResourceTypes.Materials && myPlanet.resources.get(ResourceTypes.Organic)==1)
								{
									myPlanet.upgrade(ResourceTypes.types[type]);
									if (myPlanet.resources.get(ResourceTypes.Organic) == null)
									{
										upgradeIcons[ResourceTypes.Organic].visible = false;
										
										var NofResources:Int = myPlanet.resources.types().length;
										var pTypes:Array<FlxColor> = myPlanet.resources.types();
										var screenCenter:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
										
										for (i in 0...NofResources){
											var iconPosition:FlxPoint = new FlxPoint(screenCenter.x,screenCenter.y);
											iconPosition.add(0, 190).rotate(screenCenter, (i) / NofResources * 360 +180);
											upgradeIcons[pTypes[i]].setPosition(iconPosition.x-26, iconPosition.y-26);
											upgradeIcons[pTypes[i]].updateHitbox();
										}
									}
								}else{
									myPlanet.upgrade(ResourceTypes.types[type]);
								}
								var cost:Resources = myPlanet.getUpgradeCost(ResourceTypes.types[event.eventSource]);
								for (key in ResourceTypes.types)
									if (cost.get(key) != null)
										costText[key].text = "-" + Std.string(cost.get(key));
									else
										costText[key].text = "";
								popText.text = "Pop. " + Std.string(myPlanet.population());
							}
						}
						case RightJustReleased:{
							if (event.eventSource == 99)
							{
								myPlanet.unlock();
								myPlanet.cameras.pop();
								for (key in myPlanet.resources.types())
									myPlanet.statsImgs[key].cameras.pop();
								myPlanet.showResources = false;
								close();
							}
						}
						case MouseEventType.MouseOver:{
							{
								if (event.eventSource<ResourceTypes.types.length){
									var cost:Resources = myPlanet.getUpgradeCost(ResourceTypes.types[event.eventSource]);
									for (key in ResourceTypes.types)
										if (cost.get(key) != null)
											costText[key].text = "-" + Std.string(cost.get(key));
										else
											costText[key].text = "";
								}
							}
						}
						case MouseEventType.MouseOff:{
							if (event.eventSource < ResourceTypes.types.length)
								for (key in ResourceTypes.types)
									costText[key].text = "";
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}